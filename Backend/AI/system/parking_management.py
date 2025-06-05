import cv2
import requests
import json
import time
import numpy as np
from ultralytics import solutions
from collections import deque

class ParkingDatabaseManager:
    def __init__(self, base_url="http://localhost:8000"):
        """
        Initialize database manager
        
        Args:
            base_url: URL backend Django (sesuaikan dengan server Anda)
        """
        self.base_url = base_url
        self.previous_status = {}  # Menyimpan status sebelumnya untuk deteksi perubahan
        
        # Buffer untuk menyimpan status region selama 30 frame
        self.region_status_buffer = {}  # {region_idx: deque([0,1,0,1,...], maxlen=30)}
        self.buffer_size = 30
        
    def initialize_region_buffers(self, region_count):
        """
        Initialize buffers untuk setiap region
        """
        for region_idx in range(region_count):
            self.region_status_buffer[region_idx] = deque(maxlen=self.buffer_size)
        print(f"✓ Initialized buffers for {region_count} regions")
        
    def update_slot_status(self, slot_id, status):
        """
        Update status slot parkir ke database
        
        Args:
            slot_id: ID slot parkir (string)
            status: 'AVAILABLE' atau 'UNAVAILABLE'
        """
        url = f"{self.base_url}/slotparkir/{slot_id}/status/"
        data = {"status": status}
        
        try:
            response = requests.patch(url, json=data, timeout=5)
            if response.status_code == 200:
                print(f"✓ Slot {slot_id} updated to {status}")
                return True
            else:
                print(f"✗ Failed to update slot {slot_id}: {response.status_code}")
                print(f"Response: {response.text}")
                return False
        except requests.RequestException as e:
            print(f"✗ Error updating slot {slot_id}: {e}")
            return False
    
    def load_bounding_boxes(self, json_file="bounding_boxes.json"):
        """
        Load bounding boxes dari file JSON
        """
        try:
            with open(json_file, 'r') as f:
                data = json.load(f)
                
                # Debug: Print struktur data
                print(f"Loaded JSON type: {type(data)}")
                print(f"JSON content preview: {str(data)[:200]}...")
                
                return data
        except Exception as e:
            print(f"Error loading bounding boxes: {e}")
            return None
    
    def point_in_polygon(self, point, polygon):
        """
        Check if point is inside polygon using ray casting algorithm
        """
        x, y = point
        n = len(polygon)
        inside = False
        
        p1x, p1y = polygon[0]
        for i in range(1, n + 1):
            p2x, p2y = polygon[i % n]
            if y > min(p1y, p2y):
                if y <= max(p1y, p2y):
                    if x <= max(p1x, p2x):
                        if p1y != p2y:
                            xinters = (y - p1y) * (p2x - p1x) / (p2y - p1y) + p1x
                        if p1x == p2x or x <= xinters:
                            inside = not inside
            p1x, p1y = p2x, p2y
        
        return inside
    
    def detect_region_status(self, results, bounding_boxes):
        """
        Detect status untuk setiap region (0 = kosong, 1 = terisi)
        Returns: dict {region_idx: status_binary}
        """
        region_status = {}
        
        if not hasattr(results, 'boxes') or results.boxes is None:
            print("No detection boxes found in results")
            # Semua region dianggap kosong
            regions = self.get_regions_from_bounding_boxes(bounding_boxes)
            for region_idx in range(len(regions)):
                region_status[region_idx] = 0
            return region_status
        
        # Get detection boxes (vehicles)
        boxes = results.boxes
        if len(boxes) == 0:
            print("No vehicles detected")
            # Semua region dianggap kosong
            regions = self.get_regions_from_bounding_boxes(bounding_boxes)
            for region_idx in range(len(regions)):
                region_status[region_idx] = 0
            return region_status
        
        # Convert boxes to center points
        vehicle_centers = []
        for box in boxes:
            if hasattr(box, 'xyxy'):
                coords = box.xyxy[0].cpu().numpy()
                x1, y1, x2, y2 = coords
                center_x = (x1 + x2) / 2
                center_y = (y1 + y2) / 2
                vehicle_centers.append((center_x, center_y))
        
        print(f"Found {len(vehicle_centers)} vehicles")
        
        # Parse regions
        regions = self.get_regions_from_bounding_boxes(bounding_boxes)
        if not regions:
            print("No parking regions found in bounding boxes")
            return region_status
        
        print(f"Analyzing {len(regions)} parking regions")
        
        # Check each parking region
        for region_idx, region_data in enumerate(regions):
            # Handle different region data formats
            polygon = []
            if isinstance(region_data, dict):
                polygon = region_data.get("points", [])
            elif isinstance(region_data, list):
                polygon = region_data
            
            if not polygon:
                print(f"No polygon points found for region {region_idx}")
                region_status[region_idx] = 0
                continue
            
            # Check if any vehicle center is in this region
            is_occupied = False
            for vehicle_center in vehicle_centers:
                if self.point_in_polygon(vehicle_center, polygon):
                    is_occupied = True
                    break
            
            # Set binary status (0 = kosong, 1 = terisi)
            binary_status = 1 if is_occupied else 0
            region_status[region_idx] = binary_status
            
            print(f"Region {region_idx}: {'OCCUPIED' if binary_status else 'EMPTY'} ({binary_status})")
        
        return region_status
    
    def get_regions_from_bounding_boxes(self, bounding_boxes):
        """
        Extract regions dari berbagai format bounding boxes
        """
        if isinstance(bounding_boxes, dict):
            return bounding_boxes.get("regions", [])
        elif isinstance(bounding_boxes, list):
            return bounding_boxes
        return []
    
    def update_region_buffers(self, region_status):
        """
        Update buffer untuk setiap region dengan status terbaru
        """
        for region_idx, status in region_status.items():
            if region_idx not in self.region_status_buffer:
                self.region_status_buffer[region_idx] = deque(maxlen=self.buffer_size)
            
            self.region_status_buffer[region_idx].append(status)
            print(f"Region {region_idx} buffer: {list(self.region_status_buffer[region_idx])}")
    
    def should_send_update(self, region_idx):
        """
        Check apakah sudah waktunya mengirim update (buffer sudah penuh dengan 30 frame)
        """
        if region_idx not in self.region_status_buffer:
            return False
        
        buffer = self.region_status_buffer[region_idx]
        return len(buffer) >= self.buffer_size
    
    def get_majority_status(self, region_idx):
        """
        Get majority status dari buffer (ambil status yang paling sering muncul)
        """
        if region_idx not in self.region_status_buffer:
            return 0
        
        buffer = list(self.region_status_buffer[region_idx])
        if not buffer:
            return 0
        
        # Hitung jumlah 0 dan 1
        count_0 = buffer.count(0)
        count_1 = buffer.count(1)
        
        # Return majority (jika sama, prioritas kosong/0)
        majority_binary = 1 if count_1 > count_0 else 0
        print(f"Region {region_idx} majority: {majority_binary} (0:{count_0}, 1:{count_1})")
        
        return majority_binary
    
    def binary_to_status_string(self, binary_status):
        """
        Convert binary status ke string status
        """
        return "UNAVAILABLE" if binary_status == 1 else "AVAILABLE"
    
    def process_frame_detections(self, results, bounding_boxes, slot_mapping):
        """
        Process detections untuk satu frame
        """
        # Detect status untuk setiap region
        region_status = self.detect_region_status(results, bounding_boxes)
        
        # Update buffers
        self.update_region_buffers(region_status)
        
        # Check apakah ada region yang siap untuk update database
        updates_sent = []
        for region_idx in region_status.keys():
            if self.should_send_update(region_idx):
                # Get majority status dari 30 frame terakhir
                majority_binary = self.get_majority_status(region_idx)
                
                # Convert ke slot ID
                if region_idx in slot_mapping:
                    slot_id = slot_mapping[region_idx]
                    status_string = self.binary_to_status_string(majority_binary)
                    
                    # Check apakah status berubah dari sebelumnya
                    if self.previous_status.get(slot_id) != status_string:
                        # Send update ke database
                        success = self.update_slot_status(slot_id, status_string)
                        if success:
                            self.previous_status[slot_id] = status_string
                            updates_sent.append({
                                'region_idx': region_idx,
                                'slot_id': slot_id,
                                'binary_status': majority_binary,
                                'status_string': status_string
                            })
                        
                        # Clear buffer setelah update
                        self.region_status_buffer[region_idx].clear()
        
        return updates_sent
    
    def debug_results_comprehensive(self, results):
        """
        Comprehensive debug function
        """
        print("\n=== COMPREHENSIVE DEBUG ===")
        print(f"Results type: {type(results)}")
        
        # Check all attributes
        attributes = [attr for attr in dir(results) if not attr.startswith('_')]
        print(f"Available attributes: {attributes}")
        
        # Check specific attributes
        for attr in ['boxes', 'occupied_spaces', 'available_spaces', 'plot_im']:
            if hasattr(results, attr):
                value = getattr(results, attr)
                print(f"{attr}: {type(value)} = {value}")
                
                # If it's boxes, get more details
                if attr == 'boxes' and value is not None:
                    print(f"  Boxes length: {len(value)}")
                    if len(value) > 0:
                        first_box = value[0]
                        print(f"  First box type: {type(first_box)}")
                        if hasattr(first_box, 'xyxy'):
                            print(f"  First box coords: {first_box.xyxy}")
            else:
                print(f"{attr}: NOT FOUND")
        
        print("=== END DEBUG ===\n")

def main():
    # Konfigurasi
    VIDEO_PATH = "assets/parkiran_landscape.mp4"
    BACKEND_URL = "http://127.0.0.1:8000/api"
    BOUNDING_BOXES_FILE = "bounding_boxes.json"
    
    # Mapping area parkir ke slot ID
    SLOT_MAPPING = {
        0: "A1", 1: "A2", 2: "A3", 3: "A4"
    }
    
    print(f"Slot mapping: {SLOT_MAPPING}")
    
    # Initialize database manager
    db_manager = ParkingDatabaseManager(base_url=BACKEND_URL)
    
    # Load bounding boxes
    bounding_boxes = db_manager.load_bounding_boxes(BOUNDING_BOXES_FILE)
    if not bounding_boxes:
        print("Error: Could not load bounding boxes. Cannot proceed.")
        return
    
    # Initialize region buffers
    regions = db_manager.get_regions_from_bounding_boxes(bounding_boxes)
    region_count = len(regions)
    if region_count == 0:
        print("Error: No regions found in bounding boxes.")
        return
    
    db_manager.initialize_region_buffers(region_count)
    print(f"✓ Found {region_count} regions")
    
    # Test backend connection
    print("Testing backend connection...")
    try:
        response = requests.get(f"{BACKEND_URL}/", timeout=5)
        print(f"✓ Backend accessible: {response.status_code}")
    except Exception as e:
        print(f"✗ Backend connection failed: {e}")
        print("Make sure Django server is running on", BACKEND_URL)
        return
    
    # Test slot update
    try:
        url = f"{BACKEND_URL}/slotparkir/A1/status/"
        data = {"status": "AVAILABLE"}
        response = requests.patch(url, json=data, timeout=5)
        if response.status_code == 200:
            print("✓ Test update successful")
        else:
            print(f"✗ Test update failed: {response.status_code} - {response.text}")
            return
    except Exception as e:
        print(f"✗ Test update error: {e}")
        return
    
    # Video setup
    cap = cv2.VideoCapture(VIDEO_PATH)
    if not cap.isOpened():
        print(f"Error: Cannot open video file {VIDEO_PATH}")
        return
    
    # Video writer
    w, h, fps = (int(cap.get(x)) for x in (cv2.CAP_PROP_FRAME_WIDTH, cv2.CAP_PROP_FRAME_HEIGHT, cv2.CAP_PROP_FPS))
    video_writer = cv2.VideoWriter("parking_management_output.avi", cv2.VideoWriter_fourcc(*"mp4v"), fps, (w, h))
    
    # Initialize parking management
    print("Initializing parking management...")
    try:
        parkingmanager = solutions.ParkingManagement(
            model="models/best.pt",
            json_file=BOUNDING_BOXES_FILE,
        )
        print("✓ Parking management initialized")
    except Exception as e:
        print(f"✗ Error initializing parking management: {e}")
        return
    
    frame_count = 0
    total_updates = 0
    
    print("Starting parking management system...")
    print("System will send updates after collecting 30 frames of data per region")
    
    while cap.isOpened():
        ret, im0 = cap.read()
        if not ret:
            break
        
        # Process frame
        results = parkingmanager(im0)
        
        # Process detections untuk frame ini
        updates_sent = db_manager.process_frame_detections(results, bounding_boxes, SLOT_MAPPING)
        
        # Log updates yang dikirim
        if updates_sent:
            print(f"\n=== Frame {frame_count} - Updates Sent ===")
            for update in updates_sent:
                print(f"Region {update['region_idx']} -> Slot {update['slot_id']}: "
                      f"{update['binary_status']} -> {update['status_string']}")
            total_updates += len(updates_sent)
        
        # Write processed frame
        if hasattr(results, 'plot_im'):
            video_writer.write(results.plot_im)
        else:
            video_writer.write(im0)
        
        # Show frame untuk debugging (frame awal saja)
        if frame_count < 150:
            display_frame = results.plot_im if hasattr(results, 'plot_im') else im0
            cv2.imshow('Parking Management', display_frame)
            if cv2.waitKey(1) & 0xFF == ord('q'):
                break
        
        frame_count += 1
        
        if frame_count % 100 == 0:
            print(f"Processed {frame_count} frames...")
        
        # Stop setelah beberapa update untuk testing (opsional)
        if total_updates >= 10:
            print("Stopping after 10 updates for testing...")
            break
    
    # Cleanup
    cap.release()
    video_writer.release()
    cv2.destroyAllWindows()
    
    print(f"\nParking management finished.")
    print(f"Total frames processed: {frame_count}")
    print(f"Total database updates sent: {total_updates}")
    
    # Print final buffer status
    print("\n=== Final Buffer Status ===")
    for region_idx, buffer in db_manager.region_status_buffer.items():
        print(f"Region {region_idx}: {list(buffer)} (length: {len(buffer)})")

if __name__ == "__main__":
    main()
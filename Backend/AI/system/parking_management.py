import cv2
import requests
import json
import time
import numpy as np
from ultralytics import solutions
from collections import deque

class ParkingDatabaseManager:
    def __init__(self, base_url="http://localhost:8000"):
        self.base_url = base_url
        self.previous_status = {}
        self.region_status_buffer = {}
        self.buffer_size = 30
        self.parking_manager = None

    def set_parking_manager(self, parking_manager_instance):
        """Set the ParkingManagement instance after it's initialized in main."""
        self.parking_manager = parking_manager_instance
        print("✓ ParkingManagement instance set in ParkingDatabaseManager.")
        
    def initialize_region_buffers(self, region_count):
        for region_idx in range(region_count):
            self.region_status_buffer[region_idx] = deque(maxlen=self.buffer_size)
        print(f"✓ Initialized buffers for {region_count} regions")
        
    def update_slot_status(self, slot_id, status):
        url = f"{self.base_url}/slotparkir/{slot_id}/status/"
        data = {"status": status}
        
        print(f"DEBUG: Attempting to send PATCH to {url} with data {data}")
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
        try:
            with open(json_file, 'r') as f:
                data = json.load(f)
                print(f"Loaded JSON type: {type(data)}")
                print(f"JSON content preview: {str(data)[:200]}...")
                return data
        except Exception as e:
            print(f"Error loading bounding boxes: {e}")
            return None
    
    def detect_region_status(self, bounding_boxes):
        """
        Detect status for each region using the internal state of the ParkingManagement instance.
        0 = available, 1 = unavailable
        Args:
            bounding_boxes: The bounding box data to get all region indices.
        Returns: dict {region_idx: status_binary}
        """
        if self.parking_manager is None:
            print("ERROR: ParkingManagement instance not set in ParkingDatabaseManager.")
            return {}

        def point_in_polygon(point, polygon):
            num_vertices = len(polygon)
            x, y = point
            inside = False
            
            p1x, p1y = polygon[0]
            for i in range(num_vertices + 1):
                p2x, p2y = polygon[i % num_vertices]
                if y > min(p1y, p2y):
                    if y <= max(p1y, p2y):
                        if x <= max(p1x, p2x):
                            if p1y != p2y:
                                xinters = (y - p1y) * (p2x - p1x) / (p2y - p1y) + p1x
                            if p1x == p2x or x <= xinters:
                                inside = not inside
                p1x, p1y = p2x, p2y
            return inside

        regions_data = self.get_regions_from_bounding_boxes(bounding_boxes)
        all_region_indices = range(len(regions_data))
        region_status = {}
        for idx in all_region_indices:
            region_status[idx] = 0

        vehicle_centers = []
        if hasattr(self.parking_manager, 'boxes') and self.parking_manager.boxes is not None and \
           hasattr(self.parking_manager, 'clss') and self.parking_manager.clss is not None and \
           len(self.parking_manager.boxes) > 0:
            
            if hasattr(self.parking_manager.model, 'names') and self.parking_manager.model.names is not None:
                print(f"DEBUG: Model class names: {self.parking_manager.model.names}")

            for box, cls in zip(self.parking_manager.boxes, self.parking_manager.clss):
                class_id = int(cls)
                
                # Adjust class IDs based on what your model detects as vehicles.
                # Classes IDs: 0: pedestrian, 1: people, 2: bicycle, 3: car, 4: van, 5: truck, 6: tricycle, 7: awning-tricycle, 8: bus, 9: motor.
                vehicle_class_ids = [3, 4, 5, 8] 
                
                if class_id in vehicle_class_ids:
                    x1, y1, x2, y2 = box
                    center_x = (x1 + x2) / 2
                    center_y = (y1 + y2) / 2
                    vehicle_centers.append((center_x, center_y))
                else:
                    pass 

            print(f"DEBUG: Detected vehicle centers: {vehicle_centers}")

        else:
            print("No vehicle detection boxes found on parkingmanager_instance. All regions assumed empty for per-region check.")
            return region_status

        for region_idx, region_data in enumerate(regions_data):
            polygon_points = region_data["points"]
            
            is_occupied = False
            for v_center_x, v_center_y in vehicle_centers:
                if point_in_polygon((v_center_x, v_center_y), polygon_points):
                    is_occupied = True
                    break 
            
            if is_occupied:
                region_status[region_idx] = 1 # Mark as UNAVAILABLE

        print(f"Overall region status for this frame: {region_status}")
        
        return region_status
    
    def get_regions_from_bounding_boxes(self, bounding_boxes):
        if isinstance(bounding_boxes, dict) and "regions" in bounding_boxes:
            return bounding_boxes["regions"]
        elif isinstance(bounding_boxes, list):
            return bounding_boxes
        return []
    
    def update_region_buffers(self, region_status):
        for region_idx, status in region_status.items():
            if region_idx not in self.region_status_buffer:
                self.region_status_buffer[region_idx] = deque(maxlen=self.buffer_size)
            self.region_status_buffer[region_idx].append(status)
    
    def should_send_update(self, region_idx):
        if region_idx not in self.region_status_buffer:
            return False
        buffer = self.region_status_buffer[region_idx]
        return len(buffer) >= self.buffer_size
    
    def get_majority_status(self, region_idx):
        if region_idx not in self.region_status_buffer:
            return 0
        buffer = list(self.region_status_buffer[region_idx])
        if not buffer:
            return 0
        count_0 = buffer.count(0)
        count_1 = buffer.count(1)
        majority_binary = 1 if count_1 > count_0 else 0
        print(f"Region {region_idx} majority: {majority_binary} (0s: {count_0}, 1s: {count_1})")
        return majority_binary
    
    def binary_to_status_string(self, binary_status):
        return "UNAVAILABLE" if binary_status == 1 else "AVAILABLE"
    
    def process_frame_detections(self, results, bounding_boxes, slot_mapping):
        """
        Process detections for one frame.
        Args:
            results: The SolutionResults object from model inference (contains plot_im etc.).
            bounding_boxes: The raw bounding box data.
            slot_mapping: Mapping of region indices to slot IDs.
        """
        print(f"\n--- Processing frame detections ---")
        
        region_status = self.detect_region_status(bounding_boxes)
        
        for region_idx, current_status_binary in region_status.items():
            slot_id = slot_mapping.get(region_idx)
            if slot_id and slot_id not in self.previous_status:
                self.previous_status[slot_id] = "UNKNOWN"

        self.update_region_buffers(region_status)
        
        updates_sent = []
        for region_idx in region_status.keys():
            if self.should_send_update(region_idx):
                majority_binary = self.get_majority_status(region_idx)
                
                if region_idx in slot_mapping:
                    slot_id = slot_mapping[region_idx]
                    status_string = self.binary_to_status_string(majority_binary)
                    
                    print(f"DEBUG: Slot {slot_id} - Previous status: {self.previous_status.get(slot_id)}, New majority status: {status_string}")
                    
                    if self.previous_status.get(slot_id) != status_string:
                        print(f"DEBUG: Status change detected for Slot {slot_id}. Sending update...")
                        success = self.update_slot_status(slot_id, status_string)
                        if success:
                            self.previous_status[slot_id] = status_string
                            updates_sent.append({
                                'region_idx': region_idx,
                                'slot_id': slot_id,
                                'binary_status': majority_binary,
                                'status_string': status_string
                            })
                        else:
                            print(f"DEBUG: Update for Slot {slot_id} failed, not updating previous_status.")
                    else:
                        print(f"DEBUG: Slot {slot_id} status (majority {status_string}) is same as previous. No update needed.")
                    
                    self.region_status_buffer[region_idx].clear()
                    print(f"DEBUG: Buffer for region {region_idx} cleared.")
                else:
                    print(f"Warning: Region index {region_idx} not found in SLOT_MAPPING. Skipping update for this region.")
            else:
                current_buffer = self.region_status_buffer.get(region_idx, [])
                print(f"DEBUG: Region {region_idx} buffer not yet full ({len(current_buffer)} / {self.buffer_size}). No update.")
        
        print(f"--- Finished processing frame detections ---")
        return updates_sent
    
    def debug_results_comprehensive(self, results):
        print("\n=== COMPREHENSIVE DEBUG (SolutionResults object) ===")
        print(f"Results type: {type(results)}")
        
        attributes = [attr for attr in dir(results) if not attr.startswith('_')]
        print(f"Available attributes: {attributes}")
        
        for attr in ['plot_im', 'filled_slots', 'available_slots', 'total_tracks', 'boxes', 'masks', 'keypoints', 'probs']:
            if hasattr(results, attr):
                value = getattr(results, attr)
                print(f"{attr}: {type(value)} = {value}")
                
                if attr == 'boxes' and value is not None:
                    print(f"  Boxes length: {len(value)}")
                    if len(value) > 0:
                        first_box = value[0]
                        print(f"  First box type: {type(first_box)}")
                        if hasattr(first_box, 'xyxy'):
                            print(f"  First box coords (xyxy): {first_box.xyxy.cpu().numpy()}")
                        if hasattr(first_box, 'cls'):
                            print(f"  First box class (cls): {first_box.cls.cpu().numpy()}")
            else:
                print(f"{attr}: NOT FOUND")
        
        print("=== END DEBUG ===\n")

def main():
    VIDEO_PATH = "assets/parkiran_landscape.mp4"
    BACKEND_URL = "http://127.0.0.1:8000/api"
    BOUNDING_BOXES_FILE = "bounding_boxes.json"
    
    SLOT_MAPPING = {
        0: "A1", 1: "A2", 2: "A3", 3: "A4"
    }
    
    print(f"Slot mapping: {SLOT_MAPPING}")
    
    db_manager = ParkingDatabaseManager(base_url=BACKEND_URL)
    
    bounding_boxes_data = db_manager.load_bounding_boxes(BOUNDING_BOXES_FILE)
    if not bounding_boxes_data:
        print("Error: Could not load bounding boxes. Cannot proceed.")
        return
    
    regions = db_manager.get_regions_from_bounding_boxes(bounding_boxes_data)
    region_count = len(regions)
    if region_count == 0:
        print("Error: No regions found in bounding boxes.")
        return
    
    db_manager.initialize_region_buffers(region_count)
    print(f"✓ Found {region_count} regions")
    
    print("Testing backend connection...")
    try:
        response = requests.get(f"{BACKEND_URL}/", timeout=5)
        print(f"✓ Backend accessible: {response.status_code}")
    except Exception as e:
        print(f"✗ Backend connection failed: {e}")
        print("Make sure Django server is running on", BACKEND_URL)
        return
    
    try:
        url = f"{BACKEND_URL}/slotparkir/A1/status/"
        data = {"status": "AVAILABLE"}
        print(f"Initial test: Attempting to send PATCH to {url} with data {data}")
        response = requests.patch(url, json=data, timeout=5)
        if response.status_code == 200:
            print("✓ Initial test update successful")
        else:
            print(f"✗ Initial test update failed: {response.status_code} - {response.text}")
            print("WARNING: Initial test update failed. This might indicate a problem with the backend or the A1 slot setup.")
    except Exception as e:
        print(f"✗ Initial test update error: {e}")
        print("WARNING: Initial test update caused an error. This might indicate a problem with the backend.")
        
    cap = cv2.VideoCapture(VIDEO_PATH)
    if not cap.isOpened():
        print(f"Error: Cannot open video file {VIDEO_PATH}")
        return
    
    w, h, fps = (int(cap.get(x)) for x in (cv2.CAP_PROP_FRAME_WIDTH, cv2.CAP_PROP_FRAME_HEIGHT, cv2.CAP_PROP_FPS))
    video_writer = cv2.VideoWriter("parking_management_output.avi", cv2.VideoWriter_fourcc(*"mp4v"), fps, (w, h))
    
    print("Initializing parking management...")
    try:
        parkingmanager = solutions.ParkingManagement(
            model="models/best.pt",
            json_file=BOUNDING_BOXES_FILE,
        )
        db_manager.set_parking_manager(parkingmanager)
        print("✓ Parking management initialized")
    except Exception as e:
        print(f"✗ Error initializing parking management: {e}")
        return
    
    frame_count = 0
    total_updates = 0
    
    print("Starting parking management system...")
    print("System will send updates after collecting 30 frames of data per region and detecting a status change.")
    
    while cap.isOpened():
        ret, im0 = cap.read()
        if not ret:
            print("End of video stream or error reading frame.")
            break
        
        results = parkingmanager(im0) 
        
        if frame_count < 5: 
            db_manager.debug_results_comprehensive(results) 

        updates_sent = db_manager.process_frame_detections(results, regions, SLOT_MAPPING)
        
        if updates_sent:
            print(f"\n=== Frame {frame_count} - Updates Sent ===")
            for update in updates_sent:
                print(f"Region {update['region_idx']} -> Slot {update['slot_id']}: "
                      f"{update['binary_status']} -> {update['status_string']}")
            total_updates += len(updates_sent)
        
        if hasattr(results, 'plot_im') and results.plot_im is not None:
            video_writer.write(results.plot_im)
        else:
            video_writer.write(im0)
        
        if frame_count < 150 or updates_sent:
            display_frame = results.plot_im if hasattr(results, 'plot_im') and results.plot_im is not None else im0
            cv2.imshow('Parking Management', display_frame)
            if cv2.waitKey(1) & 0xFF == ord('q'):
                print("User pressed 'q', exiting...")
                break
        
        frame_count += 1
        
        if frame_count % 100 == 0:
            print(f"Processed {frame_count} frames...")
            
    cap.release()
    video_writer.release()
    cv2.destroyAllWindows()
    
    print(f"\nParking management finished.")
    print(f"Total frames processed: {frame_count}")
    print(f"Total database updates sent: {total_updates}")
    
    print("\n=== Final Buffer Status ===")
    for region_idx, buffer in db_manager.region_status_buffer.items():
        print(f"Region {region_idx}: {list(buffer)} (length: {len(buffer)})")

if __name__ == "__main__":
    main()
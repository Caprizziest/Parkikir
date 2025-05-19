import 'package:flutter/material.dart';

class bookingparkir extends StatefulWidget {
  const bookingparkir({super.key});

  @override
  State<bookingparkir> createState() => _bookingparkirState();
}

class _bookingparkirState extends State<bookingparkir> {
  String? selectedSpot;
  final double spotPrice = 10000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () {
          Navigator.of(context).pop(); // or use context.pop() if using GoRouter or similar
        },
      ),
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose a Spot',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Row(
            children: [
              Icon(Icons.location_on, size: 14, color: Colors.black54),
              SizedBox(width: 4),
              Text(
                'Parkiran Mobil UC',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    ),

      body: Column(
        children: [
          // Legend
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                _buildLegendItem(Colors.grey.shade800, 'Tersedia'),
                const SizedBox(width: 16),
                _buildLegendItem(Colors.red, 'Tidak Tersedia'),
                const SizedBox(width: 16),
                _buildLegendItem(Colors.blue, 'Pilihanmu'),
              ],
            ),
          ),
          
          // Parking Map
          Expanded(
            child: InteractiveParkingMap(
              onSpotSelected: (spot) {
                setState(() {
                  if (selectedSpot == spot) {
                    selectedSpot = null;
                  } else {
                    selectedSpot = spot;
                  }
                });
              },
              selectedSpot: selectedSpot,
            ),
          ),
          
          // Selected Spot Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selected Spot :',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  selectedSpot != null ? 'Rp. ${spotPrice.toStringAsFixed(0)}' : 'Rp. -',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: selectedSpot != null ? 20 : 16,
                  ),
                ),
              ],
            ),
          ),
          
          // Payment Button
          Container(
            width: double.infinity,
            height: 56,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: selectedSpot != null ? () {} : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedSpot != null ? Colors.blue : Colors.grey.shade300,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Payment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

class InteractiveParkingMap extends StatefulWidget {
  final Function(String) onSpotSelected;
  final String? selectedSpot;

  const InteractiveParkingMap({
    super.key,
    required this.onSpotSelected,
    this.selectedSpot,
  });

  @override
  State<InteractiveParkingMap> createState() => _InteractiveParkingMapState();
}

class _InteractiveParkingMapState extends State<InteractiveParkingMap> {
  final TransformationController _transformationController = TransformationController();
  
  // Define parking spots with their status
  // 0 = available, 1 = unavailable, 2 = selected
  final Map<String, List<ParkingSpot>> parkingData = {
    'topLeft': [
      ParkingSpot('A1', 0, const Offset(50, 240)),
      ParkingSpot('A1', 0, const Offset(80, 220)),
      ParkingSpot('A1', 1, const Offset(40, 270)),
    ],
    'topRight': [
      ParkingSpot('A1', 0, const Offset(340, 240)),
      ParkingSpot('A1', 0, const Offset(340, 270)),
      ParkingSpot('D1', 0, const Offset(340, 300)),
      ParkingSpot('A1', 1, const Offset(340, 330)),
      ParkingSpot('A1', 1, const Offset(340, 360)),
      ParkingSpot('A1', 1, const Offset(340, 390)),
      ParkingSpot('A1', 1, const Offset(340, 420)),
      ParkingSpot('A1', 1, const Offset(340, 450)),
    ],
    'middleTop': [
      ParkingSpot('A1', 0, const Offset(150, 300)),
      ParkingSpot('A1', 1, const Offset(180, 300)),
      ParkingSpot('A1', 1, const Offset(210, 300)),
      ParkingSpot('A1', 1, const Offset(240, 300)),
      ParkingSpot('A1', 1, const Offset(270, 300)),
      ParkingSpot('A1', 1, const Offset(300, 300)),
    ],
    'middleRow': [
      ParkingSpot('A1', 0, const Offset(90, 330)),
      ParkingSpot('A1', 0, const Offset(120, 330)),
      ParkingSpot('A1', 0, const Offset(150, 330)),
      ParkingSpot('A1', 1, const Offset(180, 330)),
      ParkingSpot('A1', 0, const Offset(210, 330)),
      ParkingSpot('A1', 0, const Offset(240, 330)),
      ParkingSpot('A1', 0, const Offset(270, 330)),
      ParkingSpot('A1', 0, const Offset(300, 330)),
    ],
    'bottomRow': [
      ParkingSpot('A1', 0, const Offset(30, 450)),
      ParkingSpot('A1', 1, const Offset(60, 450)),
      ParkingSpot('A1', 1, const Offset(90, 450)),
      ParkingSpot('A1', 1, const Offset(120, 450)),
      ParkingSpot('A1', 1, const Offset(150, 450)),
      ParkingSpot('A1', 0, const Offset(180, 450)),
      ParkingSpot('A1', 0, const Offset(210, 450)),
      ParkingSpot('A1', 1, const Offset(240, 450)),
      ParkingSpot('A1', 1, const Offset(270, 450)),
      ParkingSpot('A1', 1, const Offset(300, 450)),
    ],
    'bottomLeft': [
      ParkingSpot('A1', 1, const Offset(120, 480)),
      ParkingSpot('A1', 1, const Offset(120, 510)),
      ParkingSpot('A1', 0, const Offset(120, 540)),
    ],
    'bottomRight': [
      ParkingSpot('A1', 1, const Offset(210, 510)),
      ParkingSpot('A1', 1, const Offset(210, 540)),
      ParkingSpot('A1', 1, const Offset(210, 570)),
      ParkingSpot('A1', 1, const Offset(210, 600)),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: _transformationController,
      minScale: 0.5,
      maxScale: 2.5,
      boundaryMargin: const EdgeInsets.all(double.infinity),
      child: Stack(
        children: [
          // Background map
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey.shade200,
          ),
          
          // Draw all parking spots
          ...parkingData.entries.expand((entry) {
            return entry.value.map((spot) {
              // Check if this spot is the selected one
              bool isSelected = widget.selectedSpot == spot.id;
              
              // Determine spot color based on status and selection
              Color spotColor;
              if (isSelected) {
                spotColor = Colors.blue;
              } else if (spot.status == 0) {
                spotColor = Colors.grey.shade800;
              } else {
                spotColor = Colors.red;
              }
              
              return Positioned(
                left: spot.position.dx,
                top: spot.position.dy,
                child: GestureDetector(
                  onTap: () {
                    if (spot.status == 0 || isSelected) {
                      widget.onSpotSelected(spot.id);
                    }
                  },
                  child: Container(
                    width: 40,
                    height: 24,
                    decoration: BoxDecoration(
                      color: spotColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        spot.id,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            });
          }).toList(),
        ],
      ),
    );
  }
}

class ParkingSpot {
  final String id;
  final int status; // 0 = available, 1 = unavailable
  final Offset position;

  ParkingSpot(this.id, this.status, this.position);
}
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
  // Updated parking spot positions to match the exact layout
  final Map<String, List<ParkingSpot>> parkingData = {
    // Top row spots
    'topLeft': [
      ParkingSpot('A1', 0, const Offset(425, 480)),
      ParkingSpot('A1', 0, const Offset(455, 480)),
    ],
    // Right vertical column spots
    'rightSide': [
      ParkingSpot('A1', 0, const Offset(680, 500)),
      ParkingSpot('D1', 0, const Offset(680, 553)),
    ],
    // Bottom spots on the right side
    'bottomRight': [
      ParkingSpot('A1', 1, const Offset(680, 600)),
      ParkingSpot('A1', 1, const Offset(680, 630)),
      ParkingSpot('A1', 1, const Offset(680, 660)),
    ],
    // Middle top row of spots
    'middleTop': [
      ParkingSpot('A1', 0, const Offset(515, 553)),
      ParkingSpot('A1', 0, const Offset(545, 553)),
      ParkingSpot('A1', 0, const Offset(575, 553)),
      ParkingSpot('A1', 0, const Offset(605, 553)),
      ParkingSpot('A1', 0, const Offset(635, 553)),
      ParkingSpot('A1', 0, const Offset(665, 553)),
    ],
    // Middle row of spots
    'middle': [
      ParkingSpot('A1', 0, const Offset(455, 580)),
      ParkingSpot('A1', 0, const Offset(485, 580)),
      ParkingSpot('A1', 0, const Offset(515, 580)),
      ParkingSpot('A1', 1, const Offset(545, 580)),
      ParkingSpot('A1', 0, const Offset(575, 580)),
      ParkingSpot('A1', 0, const Offset(605, 580)),
      ParkingSpot('A1', 0, const Offset(635, 580)),
      ParkingSpot('A1', 0, const Offset(665, 580)),
    ],
    // Bottom row of spots
    'bottom': [
      ParkingSpot('A1', 0, const Offset(425, 680)),
      ParkingSpot('A1', 1, const Offset(455, 680)),
      ParkingSpot('A1', 1, const Offset(485, 680)),
      ParkingSpot('A1', 1, const Offset(515, 680)),
      ParkingSpot('A1', 1, const Offset(545, 680)),
      ParkingSpot('A1', 0, const Offset(575, 680)),
      ParkingSpot('A1', 0, const Offset(605, 680)),
      ParkingSpot('A1', 1, const Offset(635, 680)),
      ParkingSpot('A1', 1, const Offset(665, 680)),
      ParkingSpot('A1', 1, const Offset(695, 680)),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Stack(
          children: [
            // Base parking layout with exact dimensions
            CustomPaint(
              size: const Size(642, 713),
              painter: RPSCustomPainter(),
            ),

            // Add all parking spots on top of the layout
            ...parkingData.entries.expand((entry) {
              return entry.value.map((spot) {
                bool isSelected = widget.selectedSpot == spot.id;

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
                      width: 28,
                      height: 24,
                      decoration: BoxDecoration(
                        color: spotColor,
                        borderRadius: BorderRadius.circular(4),
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

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(289.348, 4.3514);
    path_0.lineTo(2.25296, 269.103);
    path_0.cubicTo(-0.63295, 271.764, -0.775463, 276.275, 1.9367, 279.113);
    path_0.lineTo(212.639, 499.605);
    path_0.cubicTo(213.964, 500.991, 215.797, 501.775, 217.714, 501.775);
    path_0.lineTo(315.532, 501.775);
    path_0.cubicTo(319.409, 501.775, 322.552, 498.632, 322.552, 494.755);
    path_0.lineTo(322.552, 439.209);
    path_0.cubicTo(322.552, 435.557, 325.513, 432.596, 329.165, 432.596);
    path_0.cubicTo(332.817, 432.596, 335.778, 435.557, 335.778, 439.209);
    path_0.lineTo(335.778, 619.035);
    path_0.cubicTo(335.778, 620.742, 336.4, 622.391, 337.528, 623.673);
    path_0.lineTo(414.052, 710.618);
    path_0.cubicTo(415.385, 712.132, 417.304, 713, 419.321, 713);
    path_0.lineTo(467.117, 713);
    path_0.cubicTo(470.994, 713, 474.137, 709.857, 474.137, 705.98);
    path_0.lineTo(474.137, 353.835);
    path_0.cubicTo(474.137, 349.958, 470.994, 346.815, 467.117, 346.815);
    path_0.lineTo(364.067, 346.815);
    path_0.cubicTo(361.656, 346.815, 359.414, 348.052, 358.129, 350.092);
    path_0.lineTo(337.843, 382.278);
    path_0.cubicTo(336.557, 384.318, 334.315, 385.555, 331.904, 385.555);
    path_0.lineTo(329.572, 385.555);
    path_0.cubicTo(325.695, 385.555, 322.552, 382.412, 322.552, 378.535);
    path_0.lineTo(322.552, 303.104);
    path_0.cubicTo(322.552, 299.227, 325.695, 296.084, 329.572, 296.084);
    path_0.lineTo(634.98, 296.084);
    path_0.cubicTo(638.857, 296.084, 642, 292.941, 642, 289.064);
    path_0.lineTo(642, 45.7597);
    path_0.cubicTo(642, 41.8828, 638.857, 38.74, 634.98, 38.74);
    path_0.lineTo(557.56, 38.74);
    path_0.cubicTo(544.081, 38.74, 531.998, 20.3993, 528.241, 7.8075);
    path_0.cubicTo(527.132, 4.09245, 523.897, 0.92238, 520.02, 0.92238);
    path_0.lineTo(454.706, 0.92238);
    path_0.cubicTo(450.829, 0.92238, 447.581, 4.09539, 446.41, 7.7911);
    path_0.cubicTo(442.419, 20.3834, 429.633, 38.74, 416.148, 38.74);
    path_0.lineTo(339.503, 38.74);
    path_0.cubicTo(337.76, 38.74, 336.08, 38.0915, 334.788, 36.9207);
    path_0.lineTo(298.822, 4.31134);
    path_0.cubicTo(296.129, 1.87041, 292.019, 1.88779, 289.348, 4.3514);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = const Color(0xffD9D9D9).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
}
}

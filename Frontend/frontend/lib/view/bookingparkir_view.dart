import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
          context.go('/');
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
                Row(
                  children: [
                    const Text(
                      'Selected Spot : ',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (selectedSpot != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3C39F2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          selectedSpot!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  selectedSpot != null
                      ? 'Rp. ${spotPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}'
                      : 'Rp. -',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: selectedSpot != null ? 22 : 16,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            height: 56,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: selectedSpot != null
                  ? () {
                      // Pass data menggunakan extra parameter
                      context.go('/pembayaran', extra: {
                        'selectedSpot': selectedSpot!,
                        'price': spotPrice,
                      });
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedSpot != null ? const Color(0xFF3C39F2) : Colors.grey.shade300,
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
  final Map<String, List<ParkingSpot>> parkingData = {
    // A row spots
    'aRow': [
      ParkingSpot('A1', 0, const Offset(339.6, 90.6)),
      ParkingSpot('A2', 1, const Offset(366.7, 90.6)), // Red in image
      ParkingSpot('A3', 1, const Offset(393.8, 90.6)), // Red in image
      ParkingSpot('A4', 1, const Offset(421, 90.6)), // Red in image
      ParkingSpot('A5', 1, const Offset(448.1, 90.6)), // Red in image
      ParkingSpot('A6', 0, const Offset(475.2, 90.6)),
      ParkingSpot('A7', 0, const Offset(502.3, 90.6)),
    ],
    
    // B row spots
    'bRow': [
      ParkingSpot('B1', 0, const Offset(593.6, 41.4)),
      ParkingSpot('B2', 0, const Offset(593.6, 66)),
      ParkingSpot('B3', 1, const Offset(593.6, 90.6)), // Red in image
      ParkingSpot('B4', 1, const Offset(593.6, 115.2)), // Red in image
      ParkingSpot('B5', 1, const Offset(593.6, 139.8)), // Red in image
      ParkingSpot('B6', 1, const Offset(593.6, 164.3)), // Red in image
      ParkingSpot('B7', 1, const Offset(593.6, 188.9)), // Red in image
      ParkingSpot('B8', 1, const Offset(593.6, 213.5)), // Red in image
    ],
    
    // C row spots
    'cRow': [
      ParkingSpot('C1', 0, const Offset(285.4, 135.9)),
      ParkingSpot('C2', 0, const Offset(312.5, 135.9)),
      ParkingSpot('C3', 0, const Offset(339.6, 135.9)),
      ParkingSpot('C4', 0, const Offset(366.7, 135.9)),
      ParkingSpot('C5', 1, const Offset(393.9, 135.9)), // Red in image
      ParkingSpot('C6', 0, const Offset(421, 135.9)),
      ParkingSpot('C7', 0, const Offset(448.1, 135.9)),
      ParkingSpot('C8', 0, const Offset(475.2, 135.9)),
      ParkingSpot('C9', 0, const Offset(502.3, 135.9)),
    ],
    
    // D row spots
    'dRow': [
      ParkingSpot('D1', 0, const Offset(204.1, 247.2)),
      ParkingSpot('D2', 0, const Offset(231.2, 247.2)),
      ParkingSpot('D3', 0, const Offset(258.3, 247.2)),
      ParkingSpot('D4', 1, const Offset(285.4, 247.2)), // Red in image
      ParkingSpot('D5', 1, const Offset(312.5, 247.2)), // Red in image
      ParkingSpot('D6', 0, const Offset(339.6, 247.2)),
      ParkingSpot('D7', 0, const Offset(366.7, 247.2)),
      ParkingSpot('D8', 0, const Offset(393.9, 247.2)),
      ParkingSpot('D9', 0, const Offset(421, 247.2)),
      ParkingSpot('D10', 1, const Offset(448.1, 247.2)), // Red in image
      ParkingSpot('D11', 1, const Offset(475.2, 247.2)), // Red in image
      ParkingSpot('D12', 1, const Offset(502.3, 247.2)), // Red in image
      ParkingSpot('D13', 1, const Offset(529.4, 247.2)), // Red in image
    ],
    
    // E row spots (left diagonal)
    'eRow': [
      ParkingSpot('E1', 0, const Offset(287.1, 10.8)),
      ParkingSpot('E2', 0, const Offset(268.1, 28.3)),
      ParkingSpot('E3', 1, const Offset(249.0, 45.8)), // Red in image
      ParkingSpot('E4', 1, const Offset(230.0, 63.4)), // Red in image
      ParkingSpot('E5', 1, const Offset(211.0, 80.9)), // Red in image
      ParkingSpot('E6', 1, const Offset(192.0, 98.4)), // Red in image
      ParkingSpot('E7', 1, const Offset(172.9, 115.9)), // Red in image
      ParkingSpot('E8', 0, const Offset(153.9, 133.4)),
      ParkingSpot('E9', 0, const Offset(134.9, 150.9)),
      ParkingSpot('E10', 0, const Offset(115.9, 168.5)),
      ParkingSpot('E11', 0, const Offset(96.8, 186.0)),
      ParkingSpot('E12', 0, const Offset(77.0, 203.5)),
      ParkingSpot('E13', 0, const Offset(57.1, 221)),
      ParkingSpot('E14', 0, const Offset(37.3, 238.6)),
    ],
    
    // F row spots (left diagonal bottom)
    'fRow': [
      ParkingSpot('F1', 1, const Offset(47.1, 291.2)), // Red in image
      ParkingSpot('F2', 1, const Offset(64.2, 309.3)), // Red in image
      ParkingSpot('F3', 1, const Offset(82, 327.9)), // Red in image
      ParkingSpot('F4', 1, const Offset(99.7, 346.5)), // Red in image
      ParkingSpot('F5', 1, const Offset(117.4, 365)), // Red in image
      ParkingSpot('F6', 1, const Offset(135.6, 384.3)), // Red in image
      ParkingSpot('F7', 1, const Offset(153.3, 402.9)), // Red in image
      ParkingSpot('F8', 0, const Offset(171, 421.5)),
      ParkingSpot('F9', 0, const Offset(188.8, 440.1)),
      ParkingSpot('F10', 0, const Offset(231, 456.8)),
      ParkingSpot('F11', 0, const Offset(256.1, 456.8)),
      ParkingSpot('F12', 0, const Offset(281.2, 456.8)),
    ],
    
    // G row spots
    'gRow': [
      ParkingSpot('G1', 1, const Offset(274, 301.5)), // Red in image
      ParkingSpot('G2', 1, const Offset(274, 326.1)), // Red in image
      ParkingSpot('G3', 0, const Offset(274, 350.7)),
    ],
    
    // H row spots (right column)
    'hRow': [
      ParkingSpot('H1', 1, const Offset(425.2, 349.4)), // Red in image
      ParkingSpot('H2', 1, const Offset(425.2, 374)), // Red in image
      ParkingSpot('H3', 1, const Offset(425.2, 398.6)), // Red in image
      ParkingSpot('H4', 1, const Offset(425.2, 423.1)), // Red in image
      ParkingSpot('H5', 1, const Offset(425.2, 447.7)), // Red in image
      ParkingSpot('H6', 1, const Offset(425.2, 472.3)), // Red in image
      ParkingSpot('H7', 1, const Offset(425.2, 496.9)), // Red in image
      ParkingSpot('H8', 0, const Offset(425.2, 521.5)),
      ParkingSpot('H9', 1, const Offset(425.2, 546.1)), // Red in image
      ParkingSpot('H10', 0, const Offset(425.2, 570.7)),
      ParkingSpot('H11', 0, const Offset(425.2, 595.2)),
      ParkingSpot('H12', 0, const Offset(425.2, 619.8)),
      ParkingSpot('H13', 0, const Offset(425.2, 644.4)),
      ParkingSpot('H14', 0, const Offset(425.2, 669)),
      ParkingSpot('H15', 0, const Offset(331.1, 434.8)),
      ParkingSpot('H16', 0, const Offset(331.1, 480.1)),
      ParkingSpot('H17', 0, const Offset(331.1, 525.4)),
      ParkingSpot('H18', 0, const Offset(331.1, 570.7)),
    ],
  };

  @override
  Widget build(BuildContext context) {
  return Center(
    child: InteractiveViewer(
      minScale: 0.5,
      maxScale: 2.5,
      boundaryMargin: const EdgeInsets.all(100),
      constrained: false, // allows free movement within the boundaryMargin
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
                  spotColor = Color(0xFF3C39F2);
                } else if (spot.status == 0) {
                  spotColor = Colors.grey.shade800;
                } else {
                  spotColor = Colors.red;
                }

                return Positioned(
                  left: spot.position.dx,
                  top: spot.position.dy,
                  child: Transform.rotate(
                    angle: () {
                      if (entry.key == 'eRow') return 41.8 * (3.1415926535 / 180); // convert to radians      
                      if (entry.key == 'fRow') {
                        final idNum = int.tryParse(spot.id.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
                        if (idNum >= 1 && idNum <= 9) return -38.1 * (3.1415926535 / 180);
                        if (idNum >= 10 && idNum <= 12) return 90 * (3.1415926535 / 180);
                      }
                      if (entry.key == 'aRow' || entry.key == 'cRow' || entry.key == 'dRow') return 90 * (3.1415926535 / 180);
                      if (entry.key == 'hRow') {
                        final idNum = int.tryParse(spot.id.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
                        if (idNum >= 15 && idNum <= 18) return 90 * (3.1415926535 / 180);
                      }
                      return 0.0;
                    } (),
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        if (spot.status == 0 || isSelected) {
                          widget.onSpotSelected(spot.id);
                        }
                      },
                    child: Container(
                      width: 44,
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
                )
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

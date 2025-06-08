import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodel/notice_detail_view_model.dart';
import '../model/notice_model.dart';
import '../model/slot_parkir_model.dart';

class NoticeDetailView extends ConsumerWidget {
  final int noticeId;

  const NoticeDetailView({Key? key, required this.noticeId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticeDetailState =
        ref.watch(noticeDetailViewModelProvider(noticeId));

    return Scaffold(
      body: Column(
        children: [
          // Custom app bar with blue background
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
            ),
            color: const Color(0xFF4040FF),
            child: SafeArea(
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: const Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Notice Detail',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 32),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: noticeDetailState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text('Error: ${error.toString()}'),
              ),
              data: (noticeDetail) => SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date
                    Text(
                      noticeDetail.tanggal,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Title
                    Text(
                      noticeDetail.judul,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Event subtitle
                    Text(
                      noticeDetail.event,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Parking map (only show if there are closed parking slots)
                    if (noticeDetail.hasClosedParking) ...[
                      _buildParkingMap(context, noticeDetail),
                      const SizedBox(height: 24),
                    ],

                    // Description
                    Text(
                      noticeDetail.description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParkingMap(BuildContext context, NoticeModel noticeDetail) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Legend
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: [
                _buildLegendItem(Colors.grey.shade800, 'Tersedia'),
                const SizedBox(width: 16),
                _buildLegendItem(Colors.red, '*Tidak dapat digunakan'),
              ],
            ),
          ),

          // Parking grid representation
          Container(
            width: double.infinity,
            height: 400,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 2.0,
                boundaryMargin: const EdgeInsets.all(50),
                constrained: false,
                child: NoticeParkingMap(
                  closedSlots: noticeDetail.parkiranTertutup
                          ?.map((p) => p.slotparkir.slotparkirid)
                          .toList() ??
                      [],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: text.contains('*') ? Colors.red : Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// Parking map specifically for notice detail view (non-interactive)
class NoticeParkingMap extends StatelessWidget {
  final List<String> closedSlots;

  const NoticeParkingMap({
    Key? key,
    required this.closedSlots,
  }) : super(key: key);

  // All parking spots data (same as in booking page)
  final Map<String, List<ParkingSpotData>> parkingData = const {
    'aRow': [
      ParkingSpotData('A1', Offset(339.6, 90.6)),
      ParkingSpotData('A2', Offset(366.7, 90.6)),
      ParkingSpotData('A3', Offset(393.8, 90.6)),
      ParkingSpotData('A4', Offset(421, 90.6)),
      ParkingSpotData('A5', Offset(448.1, 90.6)),
      ParkingSpotData('A6', Offset(475.2, 90.6)),
      ParkingSpotData('A7', Offset(502.3, 90.6)),
    ],
    'bRow': [
      ParkingSpotData('B1', Offset(593.6, 41.4)),
      ParkingSpotData('B2', Offset(593.6, 66)),
      ParkingSpotData('B3', Offset(593.6, 90.6)),
      ParkingSpotData('B4', Offset(593.6, 115.2)),
      ParkingSpotData('B5', Offset(593.6, 139.8)),
      ParkingSpotData('B6', Offset(593.6, 164.3)),
      ParkingSpotData('B7', Offset(593.6, 188.9)),
      ParkingSpotData('B8', Offset(593.6, 213.5)),
    ],
    'cRow': [
      ParkingSpotData('C1', Offset(285.4, 135.9)),
      ParkingSpotData('C2', Offset(312.5, 135.9)),
      ParkingSpotData('C3', Offset(339.6, 135.9)),
      ParkingSpotData('C4', Offset(366.7, 135.9)),
      ParkingSpotData('C5', Offset(393.9, 135.9)),
      ParkingSpotData('C6', Offset(421, 135.9)),
      ParkingSpotData('C7', Offset(448.1, 135.9)),
      ParkingSpotData('C8', Offset(475.2, 135.9)),
      ParkingSpotData('C9', Offset(502.3, 135.9)),
    ],
    'dRow': [
      ParkingSpotData('D1', Offset(204.1, 247.2)),
      ParkingSpotData('D2', Offset(231.2, 247.2)),
      ParkingSpotData('D3', Offset(258.3, 247.2)),
      ParkingSpotData('D4', Offset(285.4, 247.2)),
      ParkingSpotData('D5', Offset(312.5, 247.2)),
      ParkingSpotData('D6', Offset(339.6, 247.2)),
      ParkingSpotData('D7', Offset(366.7, 247.2)),
      ParkingSpotData('D8', Offset(393.9, 247.2)),
      ParkingSpotData('D9', Offset(421, 247.2)),
      ParkingSpotData('D10', Offset(448.1, 247.2)),
      ParkingSpotData('D11', Offset(475.2, 247.2)),
      ParkingSpotData('D12', Offset(502.3, 247.2)),
      ParkingSpotData('D13', Offset(529.4, 247.2)),
    ],
    'eRow': [
      ParkingSpotData('E1', Offset(287.1, 10.8)),
      ParkingSpotData('E2', Offset(268.1, 28.3)),
      ParkingSpotData('E3', Offset(249.0, 45.8)),
      ParkingSpotData('E4', Offset(230.0, 63.4)),
      ParkingSpotData('E5', Offset(211.0, 80.9)),
      ParkingSpotData('E6', Offset(192.0, 98.4)),
      ParkingSpotData('E7', Offset(172.9, 115.9)),
      ParkingSpotData('E8', Offset(153.9, 133.4)),
      ParkingSpotData('E9', Offset(134.9, 150.9)),
      ParkingSpotData('E10', Offset(115.9, 168.5)),
      ParkingSpotData('E11', Offset(96.8, 186.0)),
      ParkingSpotData('E12', Offset(77.0, 203.5)),
      ParkingSpotData('E13', Offset(57.1, 221)),
      ParkingSpotData('E14', Offset(37.3, 238.6)),
    ],
    'fRow': [
      ParkingSpotData('F1', Offset(47.1, 291.2)),
      ParkingSpotData('F2', Offset(64.2, 309.3)),
      ParkingSpotData('F3', Offset(82, 327.9)),
      ParkingSpotData('F4', Offset(99.7, 346.5)),
      ParkingSpotData('F5', Offset(117.4, 365)),
      ParkingSpotData('F6', Offset(135.6, 384.3)),
      ParkingSpotData('F7', Offset(153.3, 402.9)),
      ParkingSpotData('F8', Offset(171, 421.5)),
      ParkingSpotData('F9', Offset(188.8, 440.1)),
      ParkingSpotData('F10', Offset(231, 456.8)),
      ParkingSpotData('F11', Offset(256.1, 456.8)),
      ParkingSpotData('F12', Offset(281.2, 456.8)),
    ],
    'gRow': [
      ParkingSpotData('G1', Offset(274, 301.5)),
      ParkingSpotData('G2', Offset(274, 326.1)),
      ParkingSpotData('G3', Offset(274, 350.7)),
    ],
    'hRow': [
      ParkingSpotData('H1', Offset(425.2, 349.4)),
      ParkingSpotData('H2', Offset(425.2, 374)),
      ParkingSpotData('H3', Offset(425.2, 398.6)),
      ParkingSpotData('H4', Offset(425.2, 423.1)),
      ParkingSpotData('H5', Offset(425.2, 447.7)),
      ParkingSpotData('H6', Offset(425.2, 472.3)),
      ParkingSpotData('H7', Offset(425.2, 496.9)),
      ParkingSpotData('H8', Offset(425.2, 521.5)),
      ParkingSpotData('H9', Offset(425.2, 546.1)),
      ParkingSpotData('H10', Offset(425.2, 570.7)),
      ParkingSpotData('H11', Offset(425.2, 595.2)),
      ParkingSpotData('H12', Offset(425.2, 619.8)),
      ParkingSpotData('H13', Offset(425.2, 644.4)),
      ParkingSpotData('H14', Offset(425.2, 669)),
      ParkingSpotData('H15', Offset(331.1, 434.8)),
      ParkingSpotData('H16', Offset(331.1, 480.1)),
      ParkingSpotData('H17', Offset(331.1, 525.4)),
      ParkingSpotData('H18', Offset(331.1, 570.7)),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base parking layout
        CustomPaint(
          size: const Size(642, 713),
          painter: RPSCustomPainter(),
        ),

        // Add all parking spots on top of the layout
        ...parkingData.entries.expand((entry) {
          return entry.value.map((spot) {
            bool isClosed = closedSlots.contains(spot.id);

            Color spotColor = isClosed ? Colors.red : Colors.grey.shade800;

            return Positioned(
              left: spot.position.dx,
              top: spot.position.dy,
              child: Transform.rotate(
                angle: _getRotationAngle(entry.key, spot.id),
                alignment: Alignment.center,
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
            );
          });
        }).toList(),
      ],
    );
  }

  double _getRotationAngle(String rowKey, String spotId) {
    if (rowKey == 'eRow') return 41.8 * (3.1415926535 / 180);
    if (rowKey == 'fRow') {
      final idNum = int.tryParse(spotId.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      if (idNum >= 1 && idNum <= 9) return -38.1 * (3.1415926535 / 180);
      if (idNum >= 10 && idNum <= 12) return 90 * (3.1415926535 / 180);
    }
    if (rowKey == 'aRow' || rowKey == 'cRow' || rowKey == 'dRow') {
      return 90 * (3.1415926535 / 180);
    }
    if (rowKey == 'hRow') {
      final idNum = int.tryParse(spotId.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      if (idNum >= 15 && idNum <= 18) return 90 * (3.1415926535 / 180);
    }
    return 0.0;
  }
}

// Simple data class for parking spots (non-interactive version)
class ParkingSpotData {
  final String id;
  final Offset position;

  const ParkingSpotData(this.id, this.position);
}

// Custom painter for the parking layout (same as booking page)
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodel/notice_detail_view_model.dart';

class NoticeDetailView extends ConsumerWidget {
  final int noticeId;

  const NoticeDetailView({Key? key, required this.noticeId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticeDetailState =
        ref.watch(noticeDetailViewModelProvider(noticeId));
    final viewModel =
        ref.read(noticeDetailViewModelProvider(noticeId).notifier);

    return Scaffold(
      body: Column(
        children: [
          // Custom app bar with blue background
          Container(
            color: const Color(0xFF4040FF),
            child: SafeArea(
              child: Container(
                height: 56, // Standard app bar height
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      child: Text(
                        'Notice Details',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 32), // Balance the back button
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Terjadi kesalahan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Error: ${error.toString()}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => viewModel.refresh(),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
              data: (state) => RefreshIndicator(
                onRefresh: viewModel.refresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date with icon
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 20,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            state.noticeDetail.tanggal,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Title
                      Text(
                        state.noticeDetail.judul,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Event subtitle with icon
                      Row(
                        children: [
                          Icon(
                            Icons.event,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              state.noticeDetail.event,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Parking summary card (always show, with different content)
                      _buildParkingSummaryCard(viewModel, state),
                      const SizedBox(height: 16),

                      // Parking map (only show if there are closed parking slots)
                      if (state.hasClosedParking) ...[
                        _buildParkingMap(context, viewModel, state),
                        const SizedBox(height: 24),
                      ],

                      // Description section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 20,
                                  color: Colors.blue[600],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Informasi Detail',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              state.noticeDetail.description,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParkingSummaryCard(
      NoticeDetailViewModel viewModel, NoticeDetailState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: state.hasClosedParking ? Colors.red[50] : Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: state.hasClosedParking ? Colors.red[200]! : Colors.green[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  state.hasClosedParking ? Colors.red[100] : Colors.green[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              state.hasClosedParking ? Icons.warning : Icons.check_circle,
              color:
                  state.hasClosedParking ? Colors.red[600] : Colors.green[600],
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status Parkir',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  viewModel.getClosedParkingSummary(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: state.hasClosedParking
                        ? Colors.red[700]
                        : Colors.green[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParkingMap(BuildContext context, NoticeDetailViewModel viewModel,
      NoticeDetailState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.local_parking,
                size: 20,
                color: Colors.grey[700],
              ),
              const SizedBox(width: 8),
              Text(
                'Peta Parkir',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Legend
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: [
                _buildLegendItem(
                    viewModel.getLegendColor('available'), 'Tersedia'),
                const SizedBox(width: 16),
                _buildLegendItem(viewModel.getLegendColor('closed'),
                    '*Tidak dapat digunakan'),
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
                  viewModel: viewModel,
                  state: state,
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
  final NoticeDetailViewModel viewModel;
  final NoticeDetailState state;

  const NoticeParkingMap({
    Key? key,
    required this.viewModel,
    required this.state,
  }) : super(key: key);

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
        ...state.parkingData.entries.expand((entry) {
          return entry.value.map((spot) {
            Color spotColor = viewModel.getSpotColor(spot.id);

            return Positioned(
              left: spot.position.dx,
              top: spot.position.dy,
              child: Transform.rotate(
                angle: viewModel.getRotationAngle(entry.key, spot.id),
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
}

// Custom painter for the parking layout - Complete implementation
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

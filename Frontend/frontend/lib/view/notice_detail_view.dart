import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodel/notice_detail_view_model.dart';
import 'components/parking_map_painter.dart';

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
                            state.formattedDateRange,
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
              color: const Color.fromARGB(255, 255, 255, 255),
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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/bookingparkir_view_model.dart';
import '../model/slot_parkir_model.dart';
import 'components/parking_map_painter.dart'; // <--- Add this line

class bookingparkir extends ConsumerStatefulWidget {
  const bookingparkir({super.key});

  @override
  ConsumerState<bookingparkir> createState() => _bookingparkirState();
}

class _bookingparkirState extends ConsumerState<bookingparkir> {
  String? selectedSpot;
  final double spotPrice = 10000;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Gunakan bookingparkirViewModelProvider
      ref.read(bookingparkirViewModelProvider.notifier).initializeConnection();
    });
  }

  @override
  void dispose() {
    // Gunakan bookingparkirViewModelProvider
    try {
      ref.read(bookingparkirViewModelProvider.notifier).disconnect();
    } catch (e) {
      // Handle any potential errors during disconnect
      debugPrint('Error during disconnect: $e');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan bookingparkirViewModelProvider
    final parkingState = ref.watch(bookingparkirViewModelProvider);
    final slots = ref.watch(parkingSlotsProvider);
    final errorMessage = ref.watch(parkingErrorMessageProvider);

    // Gunakan bookingparkirViewModelProvider
    final bookingparkirViewModel =
        ref.watch(bookingparkirViewModelProvider.notifier);

    if (parkingState == ParkingState.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (parkingState == ParkingState.error) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error: ${errorMessage ?? 'Unknown error'}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => bookingparkirViewModel.reconnect(),
                child: const Text('Try to Reconnect'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            context.pop();
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
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                _buildLegendItem(Colors.grey.shade800, 'Tersedia'),
                const SizedBox(width: 16),
                _buildLegendItem(Colors.red, 'Tidak Tersedia'),
                const SizedBox(width: 16),
                _buildLegendItem(const Color(0xFF3C39F2), 'Pilihanmu'),
              ],
            ),
          ),
          Expanded(
            child: InteractiveParkingMap(
              onSpotSelected: (spotId) {
                // Gunakan bookingparkirViewModel.isSlotAvailable
                if (bookingparkirViewModel.isSlotAvailable(spotId) ||
                    selectedSpot == spotId) {
                  setState(() {
                    if (selectedSpot == spotId) {
                      selectedSpot = null;
                    } else {
                      selectedSpot = spotId;
                    }
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Slot ini tidak tersedia.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              selectedSpot: selectedSpot,
              parkingData: slots,
            ),
          ),
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
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
                      context.go('/pembayaran', extra: {
                        'selectedSpot': selectedSpot!,
                        'price': spotPrice,
                      });
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedSpot != null
                    ? const Color(0xFF3C39F2)
                    : Colors.grey.shade300,
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
  final List<SlotParkir> parkingData;

  const InteractiveParkingMap({
    super.key,
    required this.onSpotSelected,
    this.selectedSpot,
    required this.parkingData,
  });

  @override
  State<InteractiveParkingMap> createState() => _InteractiveParkingMapState();
}

class _InteractiveParkingMapState extends State<InteractiveParkingMap> {
  final Map<String, Offset> _spotPositions = {
    // ... (Posisi tetap sama)
    'A1': const Offset(339.6, 90.6),
    'A2': const Offset(366.7, 90.6),
    'A3': const Offset(393.8, 90.6),
    'A4': const Offset(421, 90.6),
    'A5': const Offset(448.1, 90.6),
    'A6': const Offset(475.2, 90.6),
    'A7': const Offset(502.3, 90.6),
    'B1': const Offset(593.6, 41.4),
    'B2': const Offset(593.6, 66),
    'B3': const Offset(593.6, 90.6),
    'B4': const Offset(593.6, 115.2),
    'B5': const Offset(593.6, 139.8),
    'B6': const Offset(593.6, 164.3),
    'B7': const Offset(593.6, 188.9),
    'B8': const Offset(593.6, 213.5),
    'C1': const Offset(285.4, 135.9),
    'C2': const Offset(312.5, 135.9),
    'C3': const Offset(339.6, 135.9),
    'C4': const Offset(366.7, 135.9),
    'C5': const Offset(393.9, 135.9),
    'C6': const Offset(421, 135.9),
    'C7': const Offset(448.1, 135.9),
    'C8': const Offset(475.2, 135.9),
    'C9': const Offset(502.3, 135.9),
    'D1': const Offset(204.1, 247.2),
    'D2': const Offset(231.2, 247.2),
    'D3': const Offset(258.3, 247.2),
    'D4': const Offset(285.4, 247.2),
    'D5': const Offset(312.5, 247.2),
    'D6': const Offset(339.6, 247.2),
    'D7': const Offset(366.7, 247.2),
    'D8': const Offset(393.9, 247.2),
    'D9': const Offset(421, 247.2),
    'D10': const Offset(448.1, 247.2),
    'D11': const Offset(475.2, 247.2),
    'D12': const Offset(502.3, 247.2),
    'D13': const Offset(529.4, 247.2),
    'E1': const Offset(287.1, 10.8),
    'E2': const Offset(268.1, 28.3),
    'E3': const Offset(249.0, 45.8),
    'E4': const Offset(230.0, 63.4),
    'E5': const Offset(211.0, 80.9),
    'E6': const Offset(192.0, 98.4),
    'E7': const Offset(172.9, 115.9),
    'E8': const Offset(153.9, 133.4),
    'E9': const Offset(134.9, 150.9),
    'E10': const Offset(115.9, 168.5),
    'E11': const Offset(96.8, 186.0),
    'E12': const Offset(77.0, 203.5),
    'E13': const Offset(57.1, 221),
    'E14': const Offset(37.3, 238.6),
    'F1': const Offset(47.1, 291.2),
    'F2': const Offset(64.2, 309.3),
    'F3': const Offset(82, 327.9),
    'F4': const Offset(99.7, 346.5),
    'F5': const Offset(117.4, 365),
    'F6': const Offset(135.6, 384.3),
    'F7': const Offset(153.3, 402.9),
    'F8': const Offset(171, 421.5),
    'F9': const Offset(188.8, 440.1),
    'F10': const Offset(231, 456.8),
    'F11': const Offset(256.1, 456.8),
    'F12': const Offset(281.2, 456.8),
    'G1': const Offset(274, 301.5),
    'G2': const Offset(274, 326.1),
    'G3': const Offset(274, 350.7),
    'H1': const Offset(425.2, 349.4),
    'H2': const Offset(425.2, 374),
    'H3': const Offset(425.2, 398.6),
    'H4': const Offset(425.2, 423.1),
    'H5': const Offset(425.2, 447.7),
    'H6': const Offset(425.2, 472.3),
    'H7': const Offset(425.2, 496.9),
    'H8': const Offset(425.2, 521.5),
    'H9': const Offset(425.2, 546.1),
    'H10': const Offset(425.2, 570.7),
    'H11': const Offset(425.2, 595.2),
    'H12': const Offset(425.2, 619.8),
    'H13': const Offset(425.2, 644.4),
    'H14': const Offset(425.2, 669),
    'H15': const Offset(331.1, 434.8),
    'H16': const Offset(331.1, 480.1),
    'H17': const Offset(331.1, 525.4),
    'H18': const Offset(331.1, 570.7),
  };

  String _getSpotRow(String spotId) {
    if (spotId.startsWith('A')) return 'aRow';
    if (spotId.startsWith('B')) return 'bRow';
    if (spotId.startsWith('C')) return 'cRow';
    if (spotId.startsWith('D')) return 'dRow';
    if (spotId.startsWith('E')) return 'eRow';
    if (spotId.startsWith('F')) return 'fRow';
    if (spotId.startsWith('G')) return 'gRow';
    if (spotId.startsWith('H')) return 'hRow';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 2.5,
        boundaryMargin: const EdgeInsets.all(100),
        constrained: false,
        child: Stack(
          children: [
            CustomPaint(
              size: const Size(642, 713),
              painter: RPSCustomPainter(),
            ),
            ...widget.parkingData.map((spot) {
              bool isSelected = widget.selectedSpot == spot.slotparkirid;
              Offset? position = _spotPositions[spot.slotparkirid];

              if (position == null) {
                debugPrint(
                    'Warning: Position not found for spot ID: ${spot.slotparkirid}');
                return const SizedBox.shrink();
              }

              Color spotColor;
              if (isSelected) {
                spotColor = const Color(0xFF3C39F2);
              } else if (spot.isAvailable) {
                spotColor = Colors.grey.shade800;
              } else {
                spotColor = Colors.red;
              }

              String rowKey = _getSpotRow(spot.slotparkirid);

              return Positioned(
                left: position.dx,
                top: position.dy,
                child: Transform.rotate(
                  angle: () {
                    if (rowKey == 'eRow') return 41.8 * (3.1415926535 / 180);
                    if (rowKey == 'fRow') {
                      final idNum = int.tryParse(spot.slotparkirid
                              .replaceAll(RegExp(r'[^0-9]'), '')) ??
                          0;
                      if (idNum >= 1 && idNum <= 9)
                        return -38.1 * (3.1415926535 / 180);
                      if (idNum >= 10 && idNum <= 12)
                        return 90 * (3.1415926535 / 180);
                    }
                    if (rowKey == 'aRow' ||
                        rowKey == 'cRow' ||
                        rowKey == 'dRow') return 90 * (3.1415926535 / 180);
                    if (rowKey == 'hRow') {
                      final idNum = int.tryParse(spot.slotparkirid
                              .replaceAll(RegExp(r'[^0-9]'), '')) ??
                          0;
                      if (idNum >= 15 && idNum <= 18)
                        return 90 * (3.1415926535 / 180);
                    }
                    return 0.0;
                  }(),
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      widget.onSpotSelected(spot.slotparkirid);
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
                          spot.displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

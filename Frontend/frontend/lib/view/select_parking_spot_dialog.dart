import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/slot_parkir_model.dart';
import 'components/parking_map_painter.dart';

class SelectParkingSpotDialog extends ConsumerStatefulWidget {
  final List<SlotParkir> allParkingSlots;
  final List<SlotParkir> initialSelectedSpots;

  const SelectParkingSpotDialog({
    super.key,
    required this.allParkingSlots,
    required this.initialSelectedSpots,
  });

  @override
  ConsumerState<SelectParkingSpotDialog> createState() =>
      _SelectParkingSpotDialogState();
}

class _SelectParkingSpotDialogState
    extends ConsumerState<SelectParkingSpotDialog> {
  // Use a Map to store spot positions for drawing on the CustomPainter canvas.
  // These positions are relative to the CustomPainter's size (642x713).
  final Map<String, Offset> _spotPositions = {
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

  Set<String> _currentSelectedSpotIds = {}; // Use a Set for efficient lookup

  @override
  void initState() {
    super.initState();
    // Initialize with all initially selected spots, regardless of their current 'isAvailable' status.
    // This is because this dialog is for *marking* spots to close, not just showing available ones.
    _currentSelectedSpotIds =
        widget.initialSelectedSpots.map((s) => s.slotparkirid).toSet();
  }

  // Helper to determine the row for rotation logic
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
    // Define the fixed size for the CustomPaint, which should match your RPSCustomPainter's internal dimensions.
    const Size parkingMapCanvasSize = Size(642, 713);

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 8.0,
      titlePadding: const EdgeInsets.only(top: 24.0, bottom: 0.0),
      title: const Center(
        child: Text(
          'Select Spot to Close',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 2.5,
            boundaryMargin: const EdgeInsets.all(100),
            constrained: false,
            child: Stack(
              children: [
                CustomPaint(
                  size: parkingMapCanvasSize,
                  painter: RPSCustomPainter(),
                ),
                ...widget.allParkingSlots.map((spot) {
                  bool isSelected =
                      _currentSelectedSpotIds.contains(spot.slotparkirid);
                  Offset? position = _spotPositions[spot.slotparkirid];

                  if (position == null) {
                    debugPrint(
                        'Warning: Position not found for spot ID: ${spot.slotparkirid}');
                    return const SizedBox.shrink();
                  }

                  // Determine color: Always grey unless selected by the user in this dialog,
                  // in which case it turns red. The 'isAvailable' status of the slot
                  // itself is ignored for visual representation here.
                  Color spotColor =
                      isSelected ? Colors.red : Colors.grey.shade800;

                  String rowKey = _getSpotRow(spot.slotparkirid);

                  return Positioned(
                    left: position.dx,
                    top: position.dy,
                    child: Transform.rotate(
                      angle: () {
                        if (rowKey == 'eRow')
                          return 41.8 * (3.1415926535 / 180);
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
                          setState(() {
                            // Toggle selection regardless of current 'isAvailable' status
                            if (_currentSelectedSpotIds
                                .contains(spot.slotparkirid)) {
                              _currentSelectedSpotIds.remove(spot.slotparkirid);
                            } else {
                              _currentSelectedSpotIds.add(spot.slotparkirid);
                            }
                          });
                        },
                        child: Container(
                          width: 44,
                          height: 24,
                          decoration: BoxDecoration(
                            color:
                                spotColor.withOpacity(isSelected ? 1.0 : 0.7),
                            border: isSelected // Apply border only if selected
                                ? Border.all(
                                    color: Colors.white,
                                    width: 2.0,
                                  )
                                : null, // No border when not selected
                            borderRadius: BorderRadius.circular(4),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            spot.slotparkirid,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
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
        ),
      ),
      actionsPadding: const EdgeInsets.all(16.0),
      actions: <Widget>[
        const Spacer(),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey,
            textStyle: const TextStyle(fontSize: 16),
          ),
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E88E5),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: const Text('Select'),
          onPressed: () {
            final List<SlotParkir> result = widget.allParkingSlots
                .where((slot) =>
                    _currentSelectedSpotIds.contains(slot.slotparkirid))
                .toList();
            Navigator.of(context).pop(result);
          },
        ),
      ],
    );
  }
}

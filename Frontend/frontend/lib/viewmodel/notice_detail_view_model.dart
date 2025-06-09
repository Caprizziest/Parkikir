import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../model/notice_model.dart';
import '../model/parkiran_tertutup_model.dart';
import '../model/slot_parkir_model.dart';

// Provider for the NoticeDetailViewModel
final noticeDetailViewModelProvider = StateNotifierProvider.family<
    NoticeDetailViewModel, AsyncValue<NoticeDetailState>, int>(
  (ref, noticeId) {
    return NoticeDetailViewModel(noticeId);
  },
);

// State class to encapsulate all data needed by the view
class NoticeDetailState {
  final NoticeModel noticeDetail;
  final List<String> closedSlots;
  final bool hasClosedParking;
  final Map<String, List<ParkingSpotData>> parkingData;

  NoticeDetailState({
    required this.noticeDetail,
    required this.closedSlots,
    required this.hasClosedParking,
    required this.parkingData,
  });

  NoticeDetailState copyWith({
    NoticeModel? noticeDetail,
    List<String>? closedSlots,
    bool? hasClosedParking,
    Map<String, List<ParkingSpotData>>? parkingData,
  }) {
    return NoticeDetailState(
      noticeDetail: noticeDetail ?? this.noticeDetail,
      closedSlots: closedSlots ?? this.closedSlots,
      hasClosedParking: hasClosedParking ?? this.hasClosedParking,
      parkingData: parkingData ?? this.parkingData,
    );
  }
}

// Data class for parking spots (moved from view)
class ParkingSpotData {
  final String id;
  final Offset position;

  const ParkingSpotData(this.id, this.position);
}

class NoticeDetailViewModel
    extends StateNotifier<AsyncValue<NoticeDetailState>> {
  final int noticeId;

  // All parking spots data (moved from view)
  static const Map<String, List<ParkingSpotData>> _parkingData = {
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

  NoticeDetailViewModel(this.noticeId) : super(const AsyncValue.loading()) {
    fetchNoticeDetail();
  }

  Future<void> fetchNoticeDetail() async {
    try {
      state = const AsyncValue.loading();

      // Simulate API call with a delay
      await Future.delayed(const Duration(seconds: 1));

      NoticeModel noticeDetail = _getNoticeData();

      // Extract closed slots
      List<String> closedSlots = noticeDetail.parkiranTertutup
              ?.map((p) => p.slotparkir.slotparkirid)
              .toList() ??
          [];

      // Create complete state
      final noticeState = NoticeDetailState(
        noticeDetail: noticeDetail,
        closedSlots: closedSlots,
        hasClosedParking: closedSlots.isNotEmpty,
        parkingData: _parkingData,
      );

      state = AsyncValue.data(noticeState);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  NoticeModel _getNoticeData() {
    switch (noticeId) {
      case 1:
        return NoticeModel(
          noticeId: 1,
          tanggal: '15 Mei 2025',
          judul: 'Parkiran Ditutup Sementara',
          event: 'Event Pertandingan Basket',
          description:
              '''Sehubungan dengan diselenggarakannya pertandingan basket kampus pada tanggal 15 Mei 2025, sebagian area parkiran mobil akan digunakan untuk keperluan acara. 

Kami menyarankan mahasiswa/i untuk mempertimbangkan opsi berikut:

• Menggunakan transportasi umum (seperti Grab, Gojek, dll)
• Parkir di area alternatif seperti business park atau kantong parkir terdekat
• Menggunakan sepeda atau kendaraan bermotor

Mohon pengertian dan kerja sama semuanya demi kelancaran acara. Terima kasih.''',
          parkiranTertutup: [
            ParkiranTertutup(
                id: 1,
                slotparkir: SlotParkir(slotparkirid: 'A2', status: 'closed'),
                noticeId: 1),
            ParkiranTertutup(
                id: 2,
                slotparkir: SlotParkir(slotparkirid: 'A3', status: 'closed'),
                noticeId: 1),
            ParkiranTertutup(
                id: 3,
                slotparkir: SlotParkir(slotparkirid: 'A4', status: 'closed'),
                noticeId: 1),
            ParkiranTertutup(
                id: 4,
                slotparkir: SlotParkir(slotparkirid: 'A5', status: 'closed'),
                noticeId: 1),
            ParkiranTertutup(
                id: 5,
                slotparkir: SlotParkir(slotparkirid: 'B3', status: 'closed'),
                noticeId: 1),
            ParkiranTertutup(
                id: 6,
                slotparkir: SlotParkir(slotparkirid: 'B4', status: 'closed'),
                noticeId: 1),
            ParkiranTertutup(
                id: 7,
                slotparkir: SlotParkir(slotparkirid: 'B5', status: 'closed'),
                noticeId: 1),
            ParkiranTertutup(
                id: 8,
                slotparkir: SlotParkir(slotparkirid: 'B6', status: 'closed'),
                noticeId: 1),
            ParkiranTertutup(
                id: 9,
                slotparkir: SlotParkir(slotparkirid: 'C5', status: 'closed'),
                noticeId: 1),
            ParkiranTertutup(
                id: 10,
                slotparkir: SlotParkir(slotparkirid: 'D10', status: 'closed'),
                noticeId: 1),
            ParkiranTertutup(
                id: 11,
                slotparkir: SlotParkir(slotparkirid: 'D11', status: 'closed'),
                noticeId: 1),
            ParkiranTertutup(
                id: 12,
                slotparkir: SlotParkir(slotparkirid: 'D12', status: 'closed'),
                noticeId: 1),
          ],
        );

      case 2:
        return NoticeModel(
          noticeId: 2,
          tanggal: '20 Mei 2025',
          judul: 'Penutupan Area Parkir untuk Renovasi',
          event: 'Renovasi Gedung Kampus',
          description:
              '''Mulai tanggal 20 Mei 2025, sebagian area parkir akan ditutup untuk keperluan renovasi gedung kampus. Penutupan ini diperkirakan berlangsung selama 2 minggu.

Alternatif parkir yang tersedia:
• Area parkir sebelah timur gedung
• Parkir terbuka di area lapangan
• Gedung parkir bertingkat (jika tersedia)

Mohon maaf atas ketidaknyamanan ini. Terima kasih atas pengertian dan kerja sama Anda.''',
          parkiranTertutup: [
            ParkiranTertutup(
                id: 13,
                slotparkir: SlotParkir(slotparkirid: 'A1', status: 'closed'),
                noticeId: 2),
            ParkiranTertutup(
                id: 14,
                slotparkir: SlotParkir(slotparkirid: 'A6', status: 'closed'),
                noticeId: 2),
            ParkiranTertutup(
                id: 15,
                slotparkir: SlotParkir(slotparkirid: 'B1', status: 'closed'),
                noticeId: 2),
            ParkiranTertutup(
                id: 16,
                slotparkir: SlotParkir(slotparkirid: 'B2', status: 'closed'),
                noticeId: 2),
            ParkiranTertutup(
                id: 17,
                slotparkir: SlotParkir(slotparkirid: 'C1', status: 'closed'),
                noticeId: 2),
          ],
        );

      case 3:
        return NoticeModel(
          noticeId: 3,
          tanggal: '25 Mei 2025',
          judul: 'Pembersihan Menyeluruh Area Parkir',
          event: 'Pembersihan Area Parkir',
          description:
              '''Akan dilakukan pembersihan menyeluruh area parkir kampus pada tanggal 25 Mei 2025. 

Kegiatan pembersihan meliputi:
• Pembersihan lantai dan marking parkir
• Perawatan fasilitas dan rambu-rambu
• Pengecatan ulang garis parkir
• Pemeriksaan sistem keamanan

Selama kegiatan ini berlangsung, tidak ada area parkir yang ditutup. Namun, mohon berhati-hati saat memarkir kendaraan.''',
          parkiranTertutup: [],
        );

      default:
        return NoticeModel(
          noticeId: noticeId,
          tanggal: 'Tanggal tidak tersedia',
          judul: 'Notice tidak ditemukan',
          event: 'Data tidak tersedia',
          description:
              'Notice dengan ID $noticeId tidak ditemukan dalam sistem. Silakan hubungi administrator untuk informasi lebih lanjut.',
          parkiranTertutup: [],
        );
    }
  }

  // Business logic methods
  Future<void> refresh() async {
    await fetchNoticeDetail();
  }

  List<String> getClosedParkingSlots() {
    return state.when(
      data: (noticeState) => noticeState.closedSlots,
      loading: () => [],
      error: (_, __) => [],
    );
  }

  bool isSlotClosed(String slotId) {
    return state.when(
      data: (noticeState) => noticeState.closedSlots.contains(slotId),
      loading: () => false,
      error: (_, __) => false,
    );
  }

  int getClosedSlotsCount() {
    return state.when(
      data: (noticeState) => noticeState.closedSlots.length,
      loading: () => 0,
      error: (_, __) => 0,
    );
  }

  String getClosedParkingSummary() {
    final count = getClosedSlotsCount();
    if (count == 0) return 'Tidak ada area parkir yang ditutup';
    return '$count area parkir ditutup sementara';
  }

  // Rotation angle calculation logic (moved from view)
  double getRotationAngle(String rowKey, String spotId) {
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

  Color getSpotColor(String spotId) {
    return isSlotClosed(spotId) ? Colors.red : Colors.grey.shade800;
  }

  Color getLegendColor(String legendType) {
    switch (legendType) {
      case 'available':
        return Colors.grey.shade800;
      case 'closed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

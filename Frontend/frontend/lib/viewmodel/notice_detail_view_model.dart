import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/notice_model.dart';
import '../model/parkiran_tertutup_model.dart';
import '../model/slot_parkir_model.dart';

// Provider for the NoticeDetailViewModel
final noticeDetailViewModelProvider = StateNotifierProvider.family<
    NoticeDetailViewModel, AsyncValue<NoticeModel>, int>(
  (ref, noticeId) {
    return NoticeDetailViewModel(noticeId);
  },
);

class NoticeDetailViewModel extends StateNotifier<AsyncValue<NoticeModel>> {
  final int noticeId;

  NoticeDetailViewModel(this.noticeId) : super(const AsyncValue.loading()) {
    fetchNoticeDetail();
  }

  Future<void> fetchNoticeDetail() async {
    try {
      state = const AsyncValue.loading();

      // Simulate API call with a delay
      await Future.delayed(const Duration(seconds: 1));

      // Optimized mock data - lebih fokus pada data utama
      NoticeModel noticeDetail;

      switch (noticeId) {
        case 1:
          // Notice utama dengan parkiran tertutup (untuk demo lengkap)
          noticeDetail = NoticeModel(
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
              // A row - beberapa slot ditutup
              ParkiranTertutup(
                id: 1,
                slotparkir: SlotParkir(slotparkirid: 'A2', status: 'closed'),
                noticeId: 1,
              ),
              ParkiranTertutup(
                id: 2,
                slotparkir: SlotParkir(slotparkirid: 'A3', status: 'closed'),
                noticeId: 1,
              ),
              ParkiranTertutup(
                id: 3,
                slotparkir: SlotParkir(slotparkirid: 'A4', status: 'closed'),
                noticeId: 1,
              ),
              ParkiranTertutup(
                id: 4,
                slotparkir: SlotParkir(slotparkirid: 'A5', status: 'closed'),
                noticeId: 1,
              ),
              // B row - area utama yang ditutup
              ParkiranTertutup(
                id: 5,
                slotparkir: SlotParkir(slotparkirid: 'B3', status: 'closed'),
                noticeId: 1,
              ),
              ParkiranTertutup(
                id: 6,
                slotparkir: SlotParkir(slotparkirid: 'B4', status: 'closed'),
                noticeId: 1,
              ),
              ParkiranTertutup(
                id: 7,
                slotparkir: SlotParkir(slotparkirid: 'B5', status: 'closed'),
                noticeId: 1,
              ),
              ParkiranTertutup(
                id: 8,
                slotparkir: SlotParkir(slotparkirid: 'B6', status: 'closed'),
                noticeId: 1,
              ),
              // C row - slot tengah
              ParkiranTertutup(
                id: 9,
                slotparkir: SlotParkir(slotparkirid: 'C5', status: 'closed'),
                noticeId: 1,
              ),
              // D row - area yang terdampak
              ParkiranTertutup(
                id: 10,
                slotparkir: SlotParkir(slotparkirid: 'D10', status: 'closed'),
                noticeId: 1,
              ),
              ParkiranTertutup(
                id: 11,
                slotparkir: SlotParkir(slotparkirid: 'D11', status: 'closed'),
                noticeId: 1,
              ),
              ParkiranTertutup(
                id: 12,
                slotparkir: SlotParkir(slotparkirid: 'D12', status: 'closed'),
                noticeId: 1,
              ),
            ],
          );
          break;

        case 2:
          // Notice kedua - renovasi dengan parkiran berbeda
          noticeDetail = NoticeModel(
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
                noticeId: 2,
              ),
              ParkiranTertutup(
                id: 14,
                slotparkir: SlotParkir(slotparkirid: 'A6', status: 'closed'),
                noticeId: 2,
              ),
              ParkiranTertutup(
                id: 15,
                slotparkir: SlotParkir(slotparkirid: 'B1', status: 'closed'),
                noticeId: 2,
              ),
              ParkiranTertutup(
                id: 16,
                slotparkir: SlotParkir(slotparkirid: 'B2', status: 'closed'),
                noticeId: 2,
              ),
              ParkiranTertutup(
                id: 17,
                slotparkir: SlotParkir(slotparkirid: 'C1', status: 'closed'),
                noticeId: 2,
              ),
            ],
          );
          break;

        case 3:
          // Notice ketiga - tanpa parkiran tertutup
          noticeDetail = NoticeModel(
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
            parkiranTertutup: [], // Tidak ada parkiran yang ditutup
          );
          break;

        default:
          // Default notice jika noticeId tidak ditemukan
          noticeDetail = NoticeModel(
            noticeId: noticeId,
            tanggal: 'Tanggal tidak tersedia',
            judul: 'Notice tidak ditemukan',
            event: 'Data tidak tersedia',
            description:
                'Notice dengan ID $noticeId tidak ditemukan dalam sistem. Silakan hubungi administrator untuk informasi lebih lanjut.',
            parkiranTertutup: [],
          );
          break;
      }

      state = AsyncValue.data(noticeDetail);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // Method untuk refresh data
  Future<void> refresh() async {
    await fetchNoticeDetail();
  }

  // Method untuk mendapatkan daftar slot parkir yang ditutup
  List<String> getClosedParkingSlots() {
    return state.when(
      data: (notice) =>
          notice.parkiranTertutup
              ?.map((parkiran) => parkiran.slotparkir.slotparkirid)
              .toList() ??
          [],
      loading: () => [],
      error: (_, __) => [],
    );
  }

  // Method untuk mengecek apakah slot parkir tertentu ditutup
  bool isSlotClosed(String slotId) {
    return state.when(
      data: (notice) =>
          notice.parkiranTertutup
              ?.any((parkiran) => parkiran.slotparkir.slotparkirid == slotId) ??
          false,
      loading: () => false,
      error: (_, __) => false,
    );
  }

  // Method untuk mendapatkan jumlah slot parkir yang ditutup
  int getClosedSlotsCount() {
    return state.when(
      data: (notice) => notice.parkiranTertutup?.length ?? 0,
      loading: () => 0,
      error: (_, __) => 0,
    );
  }

  // Method untuk mendapatkan summary parkiran tertutup
  String getClosedParkingSummary() {
    final count = getClosedSlotsCount();
    if (count == 0) return 'Tidak ada area parkir yang ditutup';
    return '$count area parkir ditutup sementara';
  }
}

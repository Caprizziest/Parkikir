import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/notice_model.dart';

// Provider for the NoticeListViewModel
final noticeListViewModelProvider =
    StateNotifierProvider<NoticeListViewModel, AsyncValue<List<NoticeModel>>>(
        (ref) {
  return NoticeListViewModel();
});

class NoticeListViewModel extends StateNotifier<AsyncValue<List<NoticeModel>>> {
  NoticeListViewModel() : super(const AsyncValue.loading()) {
    fetchNotices();
  }

  Future<void> fetchNotices() async {
    try {
      state = const AsyncValue.loading();

      // Simulate API call with a delay
      await Future.delayed(const Duration(seconds: 1));

      // Optimized mock data - satu data utama dengan detail yang lengkap
      final notices = [
        NoticeModel(
          noticeId: 1,
          tanggal: '15 Mei 2025',
          event: 'Event Pertandingan Basket',
          judul: 'Parkiran Ditutup Sementara',
          description:
              'Sehubungan dengan diselenggarakannya pertandingan basket kampus, sebagian area parkiran akan ditutup sementara.',
        ),
        NoticeModel(
          noticeId: 2,
          tanggal: '20 Mei 2025',
          event: 'Renovasi Gedung Kampus',
          judul: 'Penutupan Area Parkir untuk Renovasi',
          description:
              'Area parkir akan ditutup untuk keperluan renovasi gedung kampus selama 2 minggu.',
        ),
        NoticeModel(
          noticeId: 3,
          tanggal: '25 Mei 2025',
          event: 'Pembersihan Area Parkir',
          judul: 'Pembersihan Menyeluruh Area Parkir',
          description: 'Pembersihan dan perawatan fasilitas parkir kampus.',
        ),
      ];

      state = AsyncValue.data(notices);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Method untuk refresh data
  Future<void> refreshNotices() async {
    await fetchNotices();
  }

  // Method untuk menambah notice baru (jika diperlukan)
  Future<void> addNotice(NoticeModel notice) async {
    try {
      final currentNotices = state.value ?? [];
      final updatedNotices = [notice, ...currentNotices];
      state = AsyncValue.data(updatedNotices);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Method untuk menghapus notice (jika diperlukan)
  Future<void> deleteNotice(int noticeId) async {
    try {
      final currentNotices = state.value ?? [];
      final updatedNotices = currentNotices
          .where((notice) => notice.noticeId != noticeId)
          .toList();
      state = AsyncValue.data(updatedNotices);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Method untuk mencari notice berdasarkan ID
  NoticeModel? getNoticeById(int noticeId) {
    return state.when(
      data: (notices) {
        try {
          return notices.firstWhere((notice) => notice.noticeId == noticeId);
        } catch (e) {
          return null;
        }
      },
      loading: () => null,
      error: (_, __) => null,
    );
  }

  // Method untuk mendapatkan notice count
  int get noticeCount {
    return state.when(
      data: (notices) => notices.length,
      loading: () => 0,
      error: (_, __) => 0,
    );
  }
}

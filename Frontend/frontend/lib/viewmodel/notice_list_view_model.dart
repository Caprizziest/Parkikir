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

      // Mock data sesuai dengan gambar
      final notices = [
        NoticeModel(
          noticeId: 1,
          tanggal: '15 - 19 Mei 2025',
          event: 'Parkir Ditutup',
          judul: 'Penutupan Parkiran Sementara',
          description: 'Parkiran ditutup sementara',
        ),
        NoticeModel(
          noticeId: 2,
          tanggal: '2 - 5 Mei 2024',
          event: 'Parkir Ditutup',
          judul: 'Penutupan Parkiran Sementara',
          description: 'Parkiran ditutup sementara',
        ),
        NoticeModel(
          noticeId: 3,
          tanggal: '30 April 2024',
          event: 'Pembersihan Parkir',
          judul: 'Pembersihan Area Parkir',
          description: 'Mohon mengosongkan parkiran',
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
}
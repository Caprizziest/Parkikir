import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

  // MARK: - Data Management Methods

  Future<void> fetchNotices() async {
    try {
      state = const AsyncValue.loading();

      // Simulate API call with a delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock data
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

  Future<void> refreshNotices() async {
    await fetchNotices();
  }

  Future<void> addNotice(NoticeModel notice) async {
    try {
      final currentNotices = state.value ?? [];
      final updatedNotices = [notice, ...currentNotices];
      state = AsyncValue.data(updatedNotices);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

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

  // MARK: - Getter Methods

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

  int get noticeCount {
    return state.when(
      data: (notices) => notices.length,
      loading: () => 0,
      error: (_, __) => 0,
    );
  }

  List<NoticeModel> get notices {
    return state.when(
      data: (notices) => notices,
      loading: () => [],
      error: (_, __) => [],
    );
  }

  bool get hasNotices {
    return noticeCount > 0;
  }

  bool get isEmpty {
    return noticeCount == 0;
  }

  bool get isLoading {
    return state is AsyncLoading;
  }

  bool get hasError {
    return state is AsyncError;
  }

  // MARK: - Business Logic Methods

  /// Formats the notice date for display
  String formatNoticeDate(String? tanggal) {
    if (tanggal == null || tanggal.isEmpty) {
      return 'Tanggal tidak tersedia';
    }
    return tanggal;
  }

  /// Formats the notice description with fallback text
  String formatNoticeDescription(String? description) {
    if (description == null || description.isEmpty) {
      return 'Parkiran ditutup sementara';
    }

    // Truncate if too long for list display
    if (description.length > 80) {
      return '${description.substring(0, 80)}...';
    }

    return description;
  }

  /// Checks if a notice is recent (within last 7 days)
  bool isRecentNotice(String tanggal) {
    // This is a simplified check - in real app you'd parse the date
    // and compare with current date
    return tanggal.contains('2025');
  }

  /// Gets notice priority based on keywords
  NoticePriority getNoticePriority(NoticeModel notice) {
    final description = notice.description?.toLowerCase() ?? '';
    final judul = notice.judul?.toLowerCase() ?? '';

    if (description.contains('darurat') || judul.contains('darurat')) {
      return NoticePriority.urgent;
    } else if (description.contains('penting') || judul.contains('penting')) {
      return NoticePriority.important;
    }

    return NoticePriority.normal;
  }

  /// Filters notices by search query
  List<NoticeModel> searchNotices(String query) {
    if (query.isEmpty) return notices;

    final lowercaseQuery = query.toLowerCase();
    return notices.where((notice) {
      return notice.tanggal.toLowerCase().contains(lowercaseQuery) ||
          notice.description?.toLowerCase().contains(lowercaseQuery) == true ||
          notice.judul?.toLowerCase().contains(lowercaseQuery) == true ||
          notice.event?.toLowerCase().contains(lowercaseQuery) == true;
    }).toList();
  }

  /// Groups notices by month
  Map<String, List<NoticeModel>> groupNoticesByMonth() {
    final groupedNotices = <String, List<NoticeModel>>{};

    for (final notice in notices) {
      // Extract month from date (simplified - in real app parse properly)
      final month = _extractMonth(notice.tanggal);

      if (!groupedNotices.containsKey(month)) {
        groupedNotices[month] = [];
      }
      groupedNotices[month]!.add(notice);
    }

    return groupedNotices;
  }

  String _extractMonth(String tanggal) {
    // Simplified extraction - in real app use proper date parsing
    if (tanggal.contains('Mei')) return 'Mei 2025';
    if (tanggal.contains('Juni')) return 'Juni 2025';
    return 'Lainnya';
  }

  // MARK: - Navigation Methods

  /// Handles navigation to notice detail
  void navigateToNoticeDetail(BuildContext context, int noticeId) {
    final notice = getNoticeById(noticeId);
    if (notice != null) {
      context.push('/noticedetail/$noticeId');
    } else {
      _showErrorSnackBar(context, 'Notice tidak ditemukan');
    }
  }

  /// Handles back navigation
  void navigateBack(BuildContext context) {
    context.pop();
  }

  // MARK: - UI Helper Methods

  /// Shows error message to user
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Shows success message to user
  void showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Handles refresh indicator
  Future<void> handleRefresh() async {
    await refreshNotices();
  }

  // MARK: - Validation Methods

  /// Validates if notice data is complete
  bool isValidNotice(NoticeModel notice) {
    return notice.noticeId > 0 &&
        notice.tanggal.isNotEmpty &&
        (notice.description?.isNotEmpty ?? false);
  }

  /// Checks if notices list is empty after loading
  bool shouldShowEmptyState() {
    return !isLoading && !hasError && isEmpty;
  }

  /// Checks if should show retry button
  bool shouldShowRetryButton() {
    return hasError;
  }
}

// MARK: - Enums and Data Classes

enum NoticePriority {
  normal,
  important,
  urgent,
}

extension NoticePriorityExtension on NoticePriority {
  Color get color {
    switch (this) {
      case NoticePriority.urgent:
        return Colors.red;
      case NoticePriority.important:
        return Colors.orange;
      case NoticePriority.normal:
        return Colors.blue;
    }
  }

  String get label {
    switch (this) {
      case NoticePriority.urgent:
        return 'Darurat';
      case NoticePriority.important:
        return 'Penting';
      case NoticePriority.normal:
        return 'Normal';
    }
  }
}

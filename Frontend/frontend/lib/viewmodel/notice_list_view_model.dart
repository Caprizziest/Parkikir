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

      // Mock data with dateFrom and dateUntil
      final notices = [
        NoticeModel(
          noticeId: 1,
          dateFrom: DateTime(2025, 5, 15),
          dateUntil: DateTime(2025, 5, 15),
          event: 'Event Pertandingan Basket',
          judul: 'Parkiran Ditutup Sementara',
          description:
              'Sehubungan dengan diselenggarakannya pertandingan basket kampus, sebagian area parkiran akan ditutup sementara.',
        ),
        NoticeModel(
          noticeId: 2,
          dateFrom: DateTime(2025, 5, 20),
          dateUntil:
              DateTime(2025, 6, 3), // Example: different start and end date
          event: 'Renovasi Gedung Kampus',
          judul: 'Penutupan Area Parkir untuk Renovasi',
          description:
              'Area parkir akan ditutup untuk keperluan renovasi gedung kampus selama 2 minggu.',
        ),
        NoticeModel(
          noticeId: 3,
          dateFrom: DateTime(2025, 5, 25),
          dateUntil: DateTime(2025, 5, 25),
          event: 'Pembersihan Area Parkir',
          judul: 'Pembersihan Menyeluruh Area Parkir',
          description: 'Pembersihan dan perawatan fasilitas parkir kampus.',
        ),
        NoticeModel(
          noticeId: 4,
          dateFrom: DateTime(2025, 6, 10),
          dateUntil: DateTime(2025, 6, 12),
          event: 'Workshop Inovasi Teknologi',
          judul: 'Penyesuaian Area Parkir Gedung F',
          description:
              'Untuk mendukung Workshop Inovasi Teknologi, sebagian area parkir Gedung F akan disesuaikan.',
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

  /// Helper function to get month name
  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Januari';
      case 2:
        return 'Februari';
      case 3:
        return 'Maret';
      case 4:
        return 'April';
      case 5:
        return 'Mei';
      case 6:
        return 'Juni';
      case 7:
        return 'Juli';
      case 8:
        return 'Agustus';
      case 9:
        return 'September';
      case 10:
        return 'Oktober';
      case 11:
        return 'November';
      case 12:
        return 'Desember';
      default:
        return '';
    }
  }

  /// Formats a DateTime object into a readable date string.
  /// Includes year only if it's not the current year.
  String _formatDateTimeForDisplay(DateTime date) {
    final now = DateTime.now();
    String monthName = _getMonthName(date.month);

    // If it's today's date
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Hari ini, ${date.day} $monthName ${date.year}';
    }
    // If it's this year
    else if (date.year == now.year) {
      return '${date.day} $monthName';
    }
    // For other years
    return '${date.day} $monthName ${date.year}';
  }

  /// Formats the notice date range for display in the list.
  String formatNoticeDateRange(NoticeModel notice) {
    final dateFrom = notice.dateFrom;
    final dateUntil = notice.dateUntil;

    // If start and end dates are the same, just show one date.
    if (dateFrom.year == dateUntil.year &&
        dateFrom.month == dateUntil.month &&
        dateFrom.day == dateUntil.day) {
      return _formatDateTimeForDisplay(dateFrom);
    } else {
      // If dates are different, show a range.
      // E.g., "10 - 12 Juni" if month and year are the same.
      // Or "20 Mei - 3 Juni 2025" if month or year differs.
      if (dateFrom.month == dateUntil.month &&
          dateFrom.year == dateUntil.year) {
        return '${dateFrom.day} - ${_formatDateTimeForDisplay(dateUntil)}';
      } else if (dateFrom.year == dateUntil.year) {
        return '${dateFrom.day} ${_getMonthName(dateFrom.month)} - ${_formatDateTimeForDisplay(dateUntil)}';
      }
      return '${_formatDateTimeForDisplay(dateFrom)} - ${_formatDateTimeForDisplay(dateUntil)}';
    }
  }

  /// Formats the notice description with fallback text
  String formatNoticeDescription(String? description) {
    if (description == null || description.isEmpty) {
      return 'Parkiran ditutup sementara'; // Fallback text
    }

    // Truncate if too long for list display
    if (description.length > 80) {
      return '${description.substring(0, 80)}...';
    }

    return description;
  }

  /// Checks if a notice is recent (within last 7 days)
  bool isRecentNotice(NoticeModel notice) {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    // We compare dateFrom since it's the start of the event/notice period
    return notice.dateFrom.isAfter(sevenDaysAgo);
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
      // Convert dateFrom to string for searching
      final formattedDate = formatNoticeDateRange(notice).toLowerCase();
      return formattedDate.contains(lowercaseQuery) ||
          notice.description?.toLowerCase().contains(lowercaseQuery) == true ||
          notice.judul?.toLowerCase().contains(lowercaseQuery) == true ||
          notice.event?.toLowerCase().contains(lowercaseQuery) == true;
    }).toList();
  }

  /// Groups notices by month
  Map<String, List<NoticeModel>> groupNoticesByMonth() {
    final groupedNotices = <String, List<NoticeModel>>{};
    final currentYear = DateTime.now().year;

    for (final notice in notices) {
      // Using dateFrom for grouping
      final date = notice.dateFrom;
      final monthYearKey = '${_getMonthName(date.month)} ${date.year}';

      if (!groupedNotices.containsKey(monthYearKey)) {
        groupedNotices[monthYearKey] = [];
      }
      groupedNotices[monthYearKey]!.add(notice);
    }
    return groupedNotices;
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
        notice.dateFrom != null && // Check for non-null DateTime
        notice.dateUntil != null && // Check for non-null DateTime
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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/report_model.dart';

// Provider for the ReportDetailViewModel
final reportDetailViewModelProvider = StateNotifierProvider.family<
    ReportDetailViewModel, AsyncValue<ReportModel?>, int>((ref, reportId) {
  return ReportDetailViewModel(reportId);
});

// Provider for username by user ID
final usernameByIdProvider = Provider.family<String, int>((ref, userId) {
  final mockUsers = {
    1: 'john_doe',
    2: 'jane_smith',
    3: 'mike_wilson',
    4: 'sarah_johnson',
    5: 'david_brown',
    6: 'lisa_davis',
    7: 'tom_anderson',
  };
  return mockUsers[userId] ?? 'Unknown User';
});

// Provider for anonymized username
final anonymizedUsernameProvider = Provider.family<String, int>((ref, userId) {
  final username = ref.watch(usernameByIdProvider(userId));
  return _anonymizeUsername(username);
});

class ReportDetailViewModel extends StateNotifier<AsyncValue<ReportModel?>> {
  final int reportId;

  ReportDetailViewModel(this.reportId) : super(const AsyncValue.loading()) {
    fetchReportById(reportId);
  }

  Future<void> fetchReportById(int id) async {
    try {
      state = const AsyncValue.loading();

      // Simulate API call with a delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock data - same as in ReportListViewModel
      final allReports = [
        ReportModel(
          id: 1,
          user: 1,
          topic: 'Penggunaan slot parkir lebih dari 1',
          gambar: '',
          lokasi: 'Area A dekat asdkjfasasdfjalskdjfalskjfaslkjfaslkjdfasdjlkf',
          status: 'UNDONE',
          tanggal: DateTime.now().subtract(const Duration(minutes: 2)),
        ),
        ReportModel(
          id: 2,
          user: 2,
          topic: 'Parkir Sembarangan',
          gambar: '',
          lokasi: 'Area B',
          status: 'UNDONE',
          tanggal: DateTime.now().subtract(const Duration(minutes: 6)),
        ),
        ReportModel(
          id: 3,
          user: 3,
          topic: 'Parkir Sembarangan',
          gambar: '',
          lokasi: 'Area C',
          status: 'UNDONE',
          tanggal: DateTime.now().subtract(const Duration(minutes: 13)),
        ),
        ReportModel(
          id: 4,
          user: 4,
          topic: 'Parkir Sembarangan',
          gambar: '',
          lokasi: null,
          status: 'UNDONE',
          tanggal: DateTime.now().subtract(const Duration(minutes: 14)),
        ),
        ReportModel(
          id: 5,
          user: 5,
          topic: 'Parkir Sembarangan',
          gambar: '',
          lokasi: 'Area D',
          status: 'DONE',
          tanggal: DateTime.parse('2025-04-14'),
        ),
        ReportModel(
          id: 6,
          user: 6,
          topic: 'Parkir Sembarangan',
          gambar: '',
          lokasi: 'Area E',
          status: 'DONE',
          tanggal: DateTime.parse('2025-04-14'),
        ),
        ReportModel(
          id: 7,
          user: 7,
          topic: 'Parkir Sembarangan',
          gambar: '',
          lokasi: 'Area F',
          status: 'DONE',
          tanggal: DateTime.parse('2025-04-14'),
        ),
      ];

      // Find the specific report by ID
      final report = allReports.firstWhere(
        (r) => r.id == id,
        orElse: () => allReports.first, // Fallback to first report if not found
      );

      state = AsyncValue.data(report);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> refreshReport() async {
    await fetchReportById(reportId);
  }
}

// Helper function to anonymize username
String _anonymizeUsername(String username) {
  if (username.isEmpty) return 'Anonymous';

  final parts = username.split('_');
  if (parts.length >= 2) {
    final firstName = parts[0];
    final lastName = parts[1];

    final anonymizedFirst = firstName.isNotEmpty
        ? '${firstName[0].toUpperCase()}${'*' * (firstName.length - 1)}'
        : '***';

    final anonymizedLast = lastName.isNotEmpty
        ? '${lastName[0].toUpperCase()}${'*' * (lastName.length - 1)}'
        : '***';

    return '$anonymizedFirst $anonymizedLast';
  } else {
    return username.isNotEmpty
        ? '${username[0].toUpperCase()}${'*' * (username.length - 1)}'
        : 'Anonymous';
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/report_model.dart';
import '../repository/laporan_repository.dart';
import '../repository/user_repository.dart';
import '../services/laporan_service.dart';
import '../services/user_service.dart';
import '../services/token_storage.dart';

// Providers
final tokenStorageDetailProvider = Provider((ref) => TokenStorage());
final laporanServiceDetailProvider =
    Provider((ref) => LaporanService(ref.read(tokenStorageDetailProvider)));
final laporanRepositoryDetailProvider = Provider(
    (ref) => LaporanRepository(ref.read(laporanServiceDetailProvider)));
final userServiceDetailProvider =
    Provider((ref) => UserService(ref.read(tokenStorageDetailProvider)));
final userRepositoryDetailProvider =
    Provider((ref) => UserRepository(ref.read(userServiceDetailProvider)));

// Provider for the ReportDetailViewModel
final reportDetailViewModelProvider = StateNotifierProvider.family<
    ReportDetailViewModel, AsyncValue<ReportModel?>, int>((ref, reportId) {
  return ReportDetailViewModel(
      reportId, ref.read(laporanRepositoryDetailProvider));
});

// Provider for username by user ID (using API)
final usernameByIdDetailProvider =
    FutureProvider.family<String, int>((ref, userId) async {
  final userRepository = ref.read(userRepositoryDetailProvider);
  try {
    final user = await userRepository.getUserById(userId);
    return user.username;
  } catch (e) {
    print('Error fetching username for user $userId: $e');
    return 'User $userId';
  }
});

// Provider for anonymized username (using API)
final anonymizedUsernameDetailProvider =
    Provider.family<String, int>((ref, userId) {
  final usernameAsync = ref.watch(usernameByIdDetailProvider(userId));

  return usernameAsync.when(
    data: (username) => _anonymizeUsernameDetail(username),
    loading: () => 'User $userId',
    error: (_, __) => 'User $userId',
  );
});

// Helper function to anonymize username for detail view
String _anonymizeUsernameDetail(String username) {
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

class ReportDetailViewModel extends StateNotifier<AsyncValue<ReportModel?>> {
  final int reportId;
  final LaporanRepository _laporanRepository;

  ReportDetailViewModel(this.reportId, this._laporanRepository)
      : super(const AsyncValue.loading()) {
    fetchReportById(reportId);
  }
  Future<void> fetchReportById(int id) async {
    try {
      state = const AsyncValue.loading();

      // Fetch real data from API
      final report = await _laporanRepository.getLaporanById(id);

      state = AsyncValue.data(report);
    } catch (e, stackTrace) {
      print('Error fetching report detail: $e');

      // Check if it's a token-related error
      if (e.toString().contains('Session expired') ||
          e.toString().contains('Please login again') ||
          e.toString().contains('401') ||
          e.toString().contains('token not valid')) {
        // This is a session/token error - user needs to login again
        state = AsyncValue.error(
            'Your session has expired. Please login again.', stackTrace);
      } else {
        // Other types of errors
        state = AsyncValue.error(
            'Failed to load report details. Please check your connection and try again.',
            stackTrace);
      }
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

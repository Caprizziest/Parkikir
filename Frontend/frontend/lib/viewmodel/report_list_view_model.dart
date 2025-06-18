import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/report_model.dart';
import '../repository/laporan_repository.dart';
import '../repository/user_repository.dart';
import '../services/laporan_service.dart';
import '../services/user_service.dart';
import '../services/token_storage.dart';

// Providers
final tokenStorageReportProvider = Provider((ref) => TokenStorage());
final laporanServiceProvider =
    Provider((ref) => LaporanService(ref.read(tokenStorageReportProvider)));
final laporanRepositoryProvider =
    Provider((ref) => LaporanRepository(ref.read(laporanServiceProvider)));
final userServiceReportProvider =
    Provider((ref) => UserService(ref.read(tokenStorageReportProvider)));
final userRepositoryReportProvider =
    Provider((ref) => UserRepository(ref.read(userServiceReportProvider)));

// Provider untuk mendapatkan username by user ID
final usernameByUserIdProvider =
    FutureProvider.family<String, int>((ref, userId) async {
  final userRepository = ref.read(userRepositoryReportProvider);
  try {
    final user = await userRepository.getUserById(userId);
    return user.username;
  } catch (e) {
    print('Error fetching username for user $userId: $e');

    // If it's a session error, return specific message
    if (e.toString().contains('Session expired') ||
        e.toString().contains('Please login again')) {
      return 'Session Expired';
    }

    return 'User $userId';
  }
});

// Provider untuk anonymized username
final anonymizedUsernameByUserIdProvider =
    Provider.family<String, int>((ref, userId) {
  final usernameAsync = ref.watch(usernameByUserIdProvider(userId));

  return usernameAsync.when(
    data: (username) => _anonymizeUsernameStatic(username),
    loading: () => 'User $userId',
    error: (_, __) => 'User $userId',
  );
});

// Static helper function untuk anonymize username
String _anonymizeUsernameStatic(String username) {
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

// Provider for the ReportListViewModel
final reportListViewModelProvider =
    StateNotifierProvider<ReportListViewModel, AsyncValue<List<ReportModel>>>(
        (ref) {
  return ReportListViewModel(
    ref.read(laporanRepositoryProvider),
    ref.read(userRepositoryReportProvider),
  );
});

class ReportListViewModel extends StateNotifier<AsyncValue<List<ReportModel>>> {
  final LaporanRepository _laporanRepository;
  final UserRepository _userRepository;

  // Cache untuk menyimpan username berdasarkan user ID
  final Map<int, String> _usernameCache = {};

  ReportListViewModel(this._laporanRepository, this._userRepository)
      : super(const AsyncValue.loading()) {
    fetchReports();
  } // Method to get username by user ID from API
  Future<String> getUsernameById(int userId) async {
    try {
      // Check cache first
      if (_usernameCache.containsKey(userId)) {
        return _usernameCache[userId]!;
      }

      // Fetch from API
      final user = await _userRepository.getUserById(userId);
      final username = user.username;

      // Cache the result
      _usernameCache[userId] = username;

      return username;
    } catch (e) {
      print('Error fetching user $userId: $e');
      return 'User $userId'; // Fallback to show user ID
    }
  }

  // Method to get anonymized username by user ID (synchronous for UI)
  String getAnonymizedUsernameById(int userId) {
    // Check if we have cached username
    if (_usernameCache.containsKey(userId)) {
      return _anonymizeUsername(_usernameCache[userId]!);
    }

    // Return user ID as fallback while we fetch the username
    return 'User $userId';
  }

  // Method to fetch and cache usernames for all users in reports
  Future<void> _fetchUsernamesForReports(List<ReportModel> reports) async {
    final userIds = reports.map((report) => report.user).toSet();

    for (final userId in userIds) {
      if (!_usernameCache.containsKey(userId)) {
        try {
          final user = await _userRepository.getUserById(userId);
          _usernameCache[userId] = user.username;
        } catch (e) {
          print('Error fetching user $userId: $e');
          _usernameCache[userId] = 'User $userId';
        }
      }
    }
  }

  Future<void> fetchReports() async {
    try {
      state = const AsyncValue.loading();

      // Fetch real data from API
      final reports = await _laporanRepository.getAllLaporan();

      // Sort reports by date (newest first)
      reports.sort((a, b) {
        final dateA = a.tanggal ?? DateTime.now();
        final dateB = b.tanggal ?? DateTime.now();
        return dateB.compareTo(dateA);
      });

      // Fetch usernames for all users in the reports
      await _fetchUsernamesForReports(reports);

      state = AsyncValue.data(reports);
    } catch (e, stackTrace) {
      print('Error fetching reports: $e');

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
            'Failed to load reports. Please check your connection and try again.',
            stackTrace);
      }
    }
  }

  Future<void> refreshReports() async {
    await fetchReports();
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
}

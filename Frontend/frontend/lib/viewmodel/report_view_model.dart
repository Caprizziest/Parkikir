import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../model/report_model.dart';
import '../repository/report_repository.dart';
import '../services/report_service.dart';
import '../services/token_storage.dart';

// State for ReportViewModel
class ReportState {
  final ReportModel? report;
  final String errorMessage;
  final bool isLoading;
  final bool isSubmitted;

  ReportState({
    this.report,
    this.errorMessage = '',
    this.isLoading = false,
    this.isSubmitted = false,
  });

  ReportState copyWith({
    ReportModel? report,
    String? errorMessage,
    bool? isLoading,
    bool? isSubmitted,
  }) {
    return ReportState(
      report: report ?? this.report,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }
}

// ReportViewModel
class ReportViewModel extends StateNotifier<ReportState> {
  final ReportRepository _reportRepository;
  final TokenStorage _tokenStorage;

  ReportViewModel(this._reportRepository, this._tokenStorage)
      : super(ReportState());
  Future<int?> _getUserIdFromToken() async {
    try {
      final token = await _tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('No access token found');
      }

      Map<String, dynamic> payload = JwtDecoder.decode(token);
      return payload['user_id'] as int?;
    } catch (e) {
      print('Error getting user ID from token: $e');
      return null;
    }
  }

  Future<bool> submitReport({
    required File imageFile,
    required String topic,
    required String lokasi,
  }) async {
    state =
        state.copyWith(isLoading: true, errorMessage: '', isSubmitted: false);

    try {
      // Get user ID from token
      final userId = await _getUserIdFromToken();
      if (userId == null) {
        state = state.copyWith(
          errorMessage: 'Failed to get user information',
          isLoading: false,
        );
        return false;
      }

      // Create report
      final report = await _reportRepository.createReport(
        imageFile: imageFile,
        topic: topic,
        lokasi: lokasi,
        userId: userId,
      );

      state = state.copyWith(
        report: report,
        isLoading: false,
        isSubmitted: true,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
        isLoading: false,
        isSubmitted: false,
      );
      return false;
    }
  }

  void resetState() {
    state = ReportState();
  }
}

// Providers
final reportServiceProvider = Provider((ref) => ReportService(TokenStorage()));
final reportRepositoryProvider =
    Provider((ref) => ReportRepository(ref.read(reportServiceProvider)));
final reportViewModelProvider =
    StateNotifierProvider<ReportViewModel, ReportState>(
  (ref) => ReportViewModel(
    ref.read(reportRepositoryProvider),
    TokenStorage(),
  ),
);

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/report_model.dart';

// Provider for the ReportListViewModel
final reportListViewModelProvider =
    StateNotifierProvider<ReportListViewModel, AsyncValue<List<ReportModel>>>(
        (ref) {
  return ReportListViewModel();
});

class ReportListViewModel extends StateNotifier<AsyncValue<List<ReportModel>>> {
  ReportListViewModel() : super(const AsyncValue.loading()) {
    fetchReports();
  }

  Future<void> fetchReports() async {
    try {
      state = const AsyncValue.loading();

      // Simulate API call with a delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock data
      final reports = [
        ReportModel(
          id: '1',
          title: 'Parkir Sembarangan',
          userName: 'J**** B****',
          timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
          description: '-',
          isSolved: false,
        ),
        ReportModel(
          id: '2',
          title: 'Parkir Sembarangan',
          userName: 'D*** W****',
          timestamp: DateTime.now().subtract(const Duration(minutes: 6)),
          description:
              'Saya ingin keluar dari area parkir, tetapi',
          isSolved: false,
        ),
        ReportModel(
          id: '3',
          title: 'Parkir Sembarangan',
          userName: 'A**** K****',
          timestamp: DateTime.now().subtract(const Duration(minutes: 13)),
          description: '-',
          isSolved: false,
        ),
        ReportModel(
          id: '4',
          title: 'Parkir Sembarangan',
          userName: 'F***** J***',
          timestamp: DateTime.now().subtract(const Duration(minutes: 14)),
          description: '-',
          isSolved: false,
        ),
        ReportModel(
          id: '5',
          title: 'Parkir Sembarangan',
          userName: 'J**** A****',
          timestamp: DateTime.parse('2025-04-14'),
          description: 'Solved!',
          isSolved: true,
        ),
        ReportModel(
          id: '6',
          title: 'Parkir Sembarangan',
          userName: 'P**** R***',
          timestamp: DateTime.parse('2025-04-14'),
          description: 'Solved!',
          isSolved: true,
        ),
        ReportModel(
          id: '7',
          title: 'Parkir Sembarangan',
          userName: 'G**** P******',
          timestamp: DateTime.parse('2025-04-14'),
          description: 'Solved!',
          isSolved: true,
        ),
      ];

      state = AsyncValue.data(reports);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

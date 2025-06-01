import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';

import 'package:frontend/view/report_list_view.dart';
import 'package:frontend/viewmodel/report_list_view_model.dart';
import 'package:frontend/model/report_list_model.dart';

// Create a controllable fake StateNotifier
class TestReportListViewModel extends ReportListViewModel {
  TestReportListViewModel() : super();

  // Override the state with a controllable one
  @override
  AsyncValue<List<ReportModel>> get state => _state;
  AsyncValue<List<ReportModel>> _state = const AsyncValue.loading();

  // Method to update state for testing
  void setTestState(AsyncValue<List<ReportModel>> newState) {
    state = newState; // This will notify listeners automatically
  }
}

void main() {
  late TestReportListViewModel testViewModel;

  setUp(() {
    testViewModel = TestReportListViewModel();
  });

  group('ReportListView', () {
    final testReports = [
      ReportModel(
        id: '1',
        title: 'Test Report 1',
        description: 'This is a test description',
        userName: 'User1',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isSolved: false,
      ),
      ReportModel(
        id: '2',
        title: 'Solved Report',
        description: 'This is solved',
        userName: 'User2',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        isSolved: true,
      ),
    ];

    testWidgets('displays loading state', (tester) async {
      testViewModel.setTestState(const AsyncValue.loading());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProviderScope(
              overrides: [
                reportListViewModelProvider.overrideWith((ref) => testViewModel),
              ],
              child: const ReportListView(),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays error state', (tester) async {
      testViewModel.setTestState(AsyncValue.error('Test Error', StackTrace.empty));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProviderScope(
              overrides: [
                reportListViewModelProvider.overrideWith((ref) => testViewModel),
              ],
              child: const ReportListView(),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('Error: Test Error'), findsOneWidget);
    });

    testWidgets('displays data correctly', (tester) async {
      testViewModel.setTestState(AsyncValue.data(testReports));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProviderScope(
              overrides: [
                reportListViewModelProvider.overrideWith((ref) => testViewModel),
              ],
              child: const ReportListView(),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('Test Report 1'), findsOneWidget);
      expect(find.text('Solved Report'), findsOneWidget);
    });

    testWidgets('displays correct styling for solved/unsolved reports', (tester) async {
      testViewModel.setTestState(AsyncValue.data(testReports));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProviderScope(
              overrides: [
                reportListViewModelProvider.overrideWith((ref) => testViewModel),
              ],
              child: const ReportListView(),
            ),
          ),
        ),
      );

      await tester.pump();
      final unsolvedTitle = tester.widget<Text>(find.text('Test Report 1').first);
      expect(unsolvedTitle.style?.color, Colors.black);

      final solvedTitle = tester.widget<Text>(find.text('Solved Report').first);
      expect(solvedTitle.style?.color, Colors.grey);
    });
  });
}
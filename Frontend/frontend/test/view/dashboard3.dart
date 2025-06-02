import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/view/dashboard.dart'; // Adjust this import path accordingly

// === Mocks ===
class MockGoRouter extends Mock implements GoRouter {
  
}

// === Inherited Widget to inject mocked GoRouter into widget tree ===
class InheritedGoRouter extends InheritedWidget {
  final GoRouter goRouter;

  const InheritedGoRouter({
    Key? key,
    required this.goRouter,
    required Widget child,
  }) : super(key: key, child: child);

  static InheritedGoRouter of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedGoRouter>()!;
  }

  @override
  bool updateShouldNotify(InheritedGoRouter oldWidget) => goRouter != oldWidget.goRouter;
}

// === Wrapper for MaterialApp with mocked GoRouter ===
class MockGoRouterProvider extends StatelessWidget {
  final GoRouter router;
  final Widget child;

  const MockGoRouterProvider({
    Key? key,
    required this.router,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InheritedGoRouter(
      goRouter: router,
      child: MaterialApp(home: child),
    );
  }
}

void main() {
  late MockGoRouter mockGoRouter;

  setUp(() {
    mockGoRouter = MockGoRouter();

    when(() => mockGoRouter.go(any(), extra: any(named: 'extra')))
        .thenReturn(null);
when(() => mockGoRouter.push(any())).thenAnswer((_) async => null);
  });

  group('DashboardView Widget Tests', () {
    Future<void> pumpDashboard(WidgetTester tester) async {
      await tester.pumpWidget(
        MockGoRouterProvider(
          router: mockGoRouter,
          child: const dashboard_view(),
        ),
      );
    }

    testWidgets('pump dashboard_view', (WidgetTester tester) async {
      await pumpDashboard(tester);
      expect(find.byType(dashboard_view), findsOneWidget);
    });

    testWidgets('should display UI elements correctly',
        (WidgetTester tester) async {
      await pumpDashboard(tester);

      // Greeting and availability text
      expect(find.text('Hello User'), findsOneWidget);
      expect(find.text('15'), findsOneWidget);
      expect(find.text('/50'), findsOneWidget);
      expect(find.text('Slots available'), findsOneWidget);
      expect(find.text('Parkiran UC Makassar'), findsOneWidget);

      // Save your spot card
      expect(find.text('Save your spot!'), findsOneWidget);
      expect(find.text('Reserve your slot while it\'s still available.'),
          findsOneWidget);
      expect(find.text('Check Available Spot'), findsOneWidget);

      // Report cards
      expect(find.text('Make a Report'), findsOneWidget);
      expect(find.text('Report List'), findsOneWidget);
    });

    testWidgets('should display correct icons', (WidgetTester tester) async {
      await pumpDashboard(tester);

      // App bar icons
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);

      // Location and car icon
      expect(find.byIcon(Icons.location_on), findsOneWidget);
      expect(find.byIcon(Icons.directions_car), findsOneWidget);

      // Icons in report cards
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
      expect(find.byIcon(Icons.assignment_outlined), findsOneWidget);

      // Bottom navigation bar icons
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);
      expect(find.byIcon(Icons.history), findsOneWidget);
    });

    // testWidgets('should navigate to bookingparkir when "Check Available Spot" is tapped',
    //     (WidgetTester tester) async {
    //   await pumpDashboard(tester);

    //   await tester.tap(find.text('Check Available Spot'));
    //   await tester.pump();

    //   verify(() => mockGoRouter.go('/bookingparkir')).called(1);
    // });

    // testWidgets('should navigate to report_view when "Make a Report" is tapped',
    //     (WidgetTester tester) async {
    //   await pumpDashboard(tester);

    //   await tester.tap(find.text('Make a Report'));
    //   await tester.pump();

    //   verify(() => mockGoRouter.push('/report')).called(1);
    // });

    // testWidgets('should navigate to ReportListView when "Report List" is tapped',
    //     (WidgetTester tester) async {
    //   await pumpDashboard(tester);

    //   await tester.tap(find.text('Report List'));
    //   await tester.pump();

    //   verify(() => mockGoRouter.push('/reportlist')).called(1);
    // });
  });
}
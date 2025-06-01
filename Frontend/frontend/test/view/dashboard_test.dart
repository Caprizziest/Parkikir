import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/view/dashboard.dart';

void main() {
  group('Dashboard View Tests', () {
    // Helper function to create a testable widget with router
    Widget createTestableWidget() {
      return MaterialApp.router(
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const dashboard_view(),
            ),
            GoRoute(
              path: '/bookingparkir',
              builder: (context, state) => const Scaffold(
                body: Text('Booking Parkir Page'),
              ),
            ),
            GoRoute(
              path: '/report',
              builder: (context, state) => const Scaffold(
                body: Text('Report Page'),
              ),
            ),
            GoRoute(
              path: '/reportlist',
              builder: (context, state) => const Scaffold(
                body: Text('Report List Page'),
              ),
            ),
          ],
        ),
      );
    }

    testWidgets('should display all UI elements correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget());

      expect(find.text('Hello User'), findsOneWidget);
      expect(find.text('15'), findsOneWidget);
      expect(find.text('/50'), findsOneWidget);
      expect(find.text('Slots available'), findsOneWidget);
      expect(find.text('Parkiran UC Makassar'), findsOneWidget);
      expect(find.text('Save your spot!'), findsOneWidget);
      expect(find.text('Reserve your slot while it\'s still available.'), findsOneWidget);
      expect(find.text('Check Available Spot'), findsOneWidget);
      expect(find.text('Make a Report'), findsOneWidget);
      expect(find.text('Report List'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Scan'), findsOneWidget);
      expect(find.text('History'), findsOneWidget);
    });

    testWidgets('should display correct icons', (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget());

      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.location_on), findsOneWidget);
      expect(find.byIcon(Icons.directions_car), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
      expect(find.byIcon(Icons.assignment_outlined), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);
      expect(find.byIcon(Icons.history), findsOneWidget);
    });
  
    testWidgets('should navigate to booking page when Check Available Spot is tapped', 
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.tap(find.text('Check Available Spot'));
      await tester.pumpAndSettle();
      expect(find.text('Booking Parkir Page'), findsOneWidget);
    });

    testWidgets('should navigate to report page when Make a Report is tapped', 
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.tap(find.text('Make a Report'));
      await tester.pumpAndSettle();
      expect(find.text('Report Page'), findsOneWidget);
    });

    testWidgets('should navigate to report list page when Report List is tapped', 
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.tap(find.text('Report List'));
      await tester.pumpAndSettle();
      expect(find.text('Report List Page'), findsOneWidget);
    });

    testWidgets('should have proper widget hierarchy', (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget());

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.byType(Stack), findsOneWidget);
      expect(find.byType(Column), findsWidgets);

      final whiteContainers = find.byWidgetPredicate((widget) =>
          widget is Container &&
          widget.decoration is BoxDecoration &&
          (widget.decoration as BoxDecoration).color == Colors.white);
      
      expect(whiteContainers, findsAtLeastNWidgets(3));
    });

    testWidgets('should have proper accessibility', (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget());

      expect(find.byType(GestureDetector), findsAtLeastNWidgets(3));
      
      final textWidgets = tester.widgetList<Text>(find.byType(Text));
      for (final text in textWidgets) {
        expect(text.data, isNotNull);
      }
    });

    testWidgets('should handle tap gestures correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget());

      expect(find.ancestor(
        of: find.text('Check Available Spot'),
        matching: find.byType(GestureDetector),
      ), findsOneWidget);

      expect(find.ancestor(
        of: find.text('Make a Report'),
        matching: find.byType(GestureDetector),
      ), findsOneWidget);

      expect(find.ancestor(
        of: find.text('Report List'),
        matching: find.byType(GestureDetector),
      ), findsOneWidget);
    });

    testWidgets('should display logo image', (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget());

      final imageWidget = find.byWidgetPredicate((widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName == 'assets/logowhite.png');
      
      expect(imageWidget, findsOneWidget);
    });

    testWidgets('should have correct padding and spacing', (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget());

      expect(find.byType(Padding), findsAtLeastNWidgets(2));
      expect(find.byType(SizedBox), findsAtLeastNWidgets(5));
    });
  });
}
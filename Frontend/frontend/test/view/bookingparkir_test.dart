import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/view/bookingparkir_view.dart';
import 'package:go_router/go_router.dart';

void main() {
  late GoRouter router;

  setUp(() {
    router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const bookingparkir(),
        ),
        GoRoute(
          path: '/pembayaran',
          builder: (context, state) => const Scaffold(body: Text('Pembayaran Page')),
        ),
      ],
    );
  });

  group('bookingparkir Widget Tests', () {
    testWidgets('Displays AppBar title and legends', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: bookingparkir()));

      expect(find.text('Choose a Spot'), findsOneWidget);
      expect(find.text('Tersedia'), findsOneWidget);
      expect(find.text('Tidak Tersedia'), findsOneWidget);
      expect(find.text('Pilihanmu'), findsOneWidget);
    });

    testWidgets('Payment button is disabled when no spot selected', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: bookingparkir()));

      final paymentButton = find.widgetWithText(ElevatedButton, 'Payment');
      final buttonWidget = tester.widget<ElevatedButton>(paymentButton);
      expect(buttonWidget.onPressed, isNull);
    });

    testWidgets('Payment button becomes active after selecting spot', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: bookingparkir()));

      // Tap on the first available spot
      final gestureDetectors = tester.widgetList<GestureDetector>(find.byType(GestureDetector));
      for (final gesture in gestureDetectors) {
        await tester.tap(find.byWidget(gesture));
        await tester.pump();
        final paymentButton = find.widgetWithText(ElevatedButton, 'Payment');
        final buttonWidget = tester.widget<ElevatedButton>(paymentButton);
        if (buttonWidget.onPressed != null) {
          // Spot selected, button is now active
          return;
        }
      }
      fail('No available spot was tappable or did not activate button');
    });

    testWidgets('Navigates to Pembayaran page when button pressed', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      // Tap a spot
      final gestureDetectors = tester.widgetList<GestureDetector>(find.byType(GestureDetector));
      for (final gesture in gestureDetectors) {
        await tester.tap(find.byWidget(gesture));
        await tester.pump();
        final paymentButton = find.widgetWithText(ElevatedButton, 'Payment');
        final buttonWidget = tester.widget<ElevatedButton>(paymentButton);
        if (buttonWidget.onPressed != null) {
          await tester.tap(paymentButton);
          await tester.pumpAndSettle();
          break;
        }
      }

      expect(find.text('Pembayaran Page'), findsOneWidget);
    });
  });

  group('InteractiveParkingMap Tests', () {
    testWidgets('Renders multiple parking spots', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: InteractiveParkingMap(
          selectedSpot: null,
          onSpotSelected: (_) {},
        ),
      ));

      final spotFinder = find.byType(GestureDetector);
      expect(spotFinder, findsWidgets);
    });

    testWidgets('Calls onSpotSelected when a spot is tapped', (WidgetTester tester) async {
      String? tappedSpot;

      await tester.pumpWidget(MaterialApp(
        home: InteractiveParkingMap(
          selectedSpot: null,
          onSpotSelected: (spotId) {
            tappedSpot = spotId;
          },
        ),
      ));

      final gestureDetectors = tester.widgetList<GestureDetector>(find.byType(GestureDetector));
      for (final gesture in gestureDetectors) {
        await tester.tap(find.byWidget(gesture));
        await tester.pump();
        if (tappedSpot != null) break;
      }

      expect(tappedSpot, isNotNull);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/view/pembayaran_view.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';


void main() {
  testWidgets('PaymentMethodScreen displays booking data and handles selection',
      (WidgetTester tester) async {
    // Sample booking data
    final Map<String, dynamic> bookingData = {
      'selectedSpot': 'A1',
      'price': 15000,
    };

    // Wrap with MaterialApp and GoRouterProvider if needed
    await tester.pumpWidget(
      MaterialApp(
        home: PaymentMethodScreen(bookingData: bookingData),
      ),
    );

    // Wait for widget tree to build
    await tester.pumpAndSettle();

    // Check Booking Spot and Price
    expect(find.text('Booking Spot'), findsOneWidget);
    expect(find.text('A1'), findsOneWidget);
    expect(find.text('Rp 15.000'), findsOneWidget);

    final Finder continueButton = find.text('CONTINUE');
    ElevatedButton buttonWidget = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(buttonWidget.onPressed, isNull);

    // Tap on 'GOPAY' option
    await tester.tap(find.text('GOPAY'));
    await tester.pumpAndSettle();

    // CONTINUE button should now be enabled
    buttonWidget = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(buttonWidget.onPressed, isNotNull);

    // Tap CONTINUE and expect a SnackBar
    await tester.tap(continueButton);
    await tester.pump(); // Start SnackBar animation
    await tester.pump(const Duration(seconds: 1)); // Allow time to show

    expect(find.text('Payment confirmed for A1 with GOPAY'), findsOneWidget);
  });

  testWidgets('Back button navigates to /bookingparkir', (WidgetTester tester) async {
    // Mock navigation
    final mockRouter = MockGoRouter();
    
    // Sample booking data
    final Map<String, dynamic> bookingData = {
      'selectedSpot': 'A1',
      'price': 15000,
    };

    // Setup mock behavior
    when(() => mockRouter.go('/bookingparkir')).thenReturn(null);

    await tester.pumpWidget(
      MaterialApp(
        home: MockGoRouterProvider(
          router: mockRouter,
          child: PaymentMethodScreen(bookingData: bookingData),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Find and tap the back button
    final backButton = find.byIcon(Icons.arrow_back_ios);
    expect(backButton, findsOneWidget);
    
    await tester.tap(backButton);
    await tester.pumpAndSettle();

    // Verify that go was called with '/bookingparkir'
    verify(() => mockRouter.go('/bookingparkir')).called(1);
  });
}

// Mock GoRouter for testing navigation
class MockGoRouter extends Mock implements GoRouter {}

// Wrapper to provide GoRouter to widgets
class MockGoRouterProvider extends StatelessWidget {
  const MockGoRouterProvider({
    required this.router,
    required this.child,
    super.key,
  });

  final GoRouter router;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InheritedGoRouter(
      goRouter: router,
      child: child,
    );
  }
}
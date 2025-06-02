import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/view/bookingparkir_view.dart';

// Mocking GoRouter and its State
class MockGoRouter extends Mock implements GoRouter {
  @override
  String get location => '/bookingparkir'; // ✅ Direct override instead of using when()
}

class MockGoRouterState extends Mock implements GoRouterState {}

// Wrapper to inject mocked GoRouter into widget tree
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
      child: MaterialApp(home: child),
    );
  }
}

void main() {
  late MockGoRouter mockGoRouter;
  late MockGoRouterState mockGoRouterState;

  setUp(() {
    mockGoRouter = MockGoRouter();
    mockGoRouterState = MockGoRouterState();

    // Setup mock methods (no need to mock location here anymore)
    when(() => mockGoRouter.go(any(), extra: any(named: 'extra')))
        .thenReturn(null);
    when(() => mockGoRouter.push(any())).thenAnswer((_) async => null);
    when(() => mockGoRouter.state).thenReturn(mockGoRouterState);
  });

  testWidgets('Displays AppBar title and legends', (WidgetTester tester) async {
    await tester.pumpWidget(
      MockGoRouterProvider(
        router: mockGoRouter,
        child: const bookingparkir(),
      ),
    );

    expect(find.text('Choose a Spot'), findsOneWidget);
    expect(find.text('Parkiran Mobil UC'), findsOneWidget);
    expect(find.text('Tersedia'), findsOneWidget);
    expect(find.text('Tidak Tersedia'), findsOneWidget);
    expect(find.text('Pilihanmu'), findsOneWidget);
  });

  testWidgets('Payment button is disabled when no spot selected', (WidgetTester tester) async {
    await tester.pumpWidget(
      MockGoRouterProvider(
        router: mockGoRouter,
        child: const bookingparkir(),
      ),
    );

    final paymentButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(paymentButton.enabled, isFalse);
  });

  testWidgets('Payment button becomes active after selecting spot', (WidgetTester tester) async {
    await tester.pumpWidget(
      MockGoRouterProvider(
        router: mockGoRouter,
        child: const bookingparkir(),
      ),
    );

    await tester.tap(find.text('A1'));
    await tester.pump();

    final paymentButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(paymentButton.enabled, isTrue);
  });

testWidgets('Cannot select unavailable spot (status = 1)', (WidgetTester tester) async {
  await tester.pumpWidget(
    MockGoRouterProvider(
      router: mockGoRouter,
      child: const bookingparkir(),
    ),
  );

  await tester.tap(find.text('A2'));
  await tester.pump();

  // Update expectation: Selected spot should still be null
  expect(find.text('Selected Spot :'), findsNothing); // Changed
  expect(find.text('A2'), findsOneWidget);
});

  testWidgets('Selected spot ID and price are displayed after selection', (WidgetTester tester) async {
    await tester.pumpWidget(
      MockGoRouterProvider(
        router: mockGoRouter,
        child: const bookingparkir(),
      ),
    );

    await tester.tap(find.text('A1'));
    await tester.pump();

    expect(find.text('A1'), findsNWidgets(2));
    expect(find.text('Rp. 10.000'), findsOneWidget);
  });

  testWidgets('InteractiveParkingMap can zoom and scroll', (WidgetTester tester) async {
    await tester.pumpWidget(
      MockGoRouterProvider(
        router: mockGoRouter,
        child: const bookingparkir(),
      ),
    );

    final interactiveViewer = tester.widget<InteractiveViewer>(find.byType(InteractiveViewer));
    expect(interactiveViewer.minScale, 0.5);
    expect(interactiveViewer.maxScale, 2.5);
    expect(interactiveViewer.constrained, false);
  });

  testWidgets('Navigates to Pembayaran page when button pressed with correct data', (WidgetTester tester) async {
    await tester.pumpWidget(
      MockGoRouterProvider(
        router: mockGoRouter,
        child: const bookingparkir(),
      ),
    );

    await tester.tap(find.text('A1'));
    await tester.pump();
    await tester.tap(find.text('Payment'));
    await tester.pumpAndSettle();

    verify(() => mockGoRouter.go('/pembayaran', extra: {
          'selectedSpot': 'A1',
          'price': 10000.0,
        }))
        .called(1);
  });

  testWidgets('Back button navigates to home', (WidgetTester tester) async {
    await tester.pumpWidget(
      MockGoRouterProvider(
        router: mockGoRouter,
        child: const bookingparkir(),
      ),
    );

    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();

    verify(() => mockGoRouter.go('/')).called(1);
  });
}
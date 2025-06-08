// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:frontend/view/bookingparkir_view.dart';
// import 'package:frontend/view/report_list_view.dart';
// import 'package:frontend/view/report_view.dart';
// import 'package:go_router/go_router.dart';
// import 'package:frontend/view/dashboard.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// void main() {
//   group('Dashboard View Tests', () {
//     // Helper function to create a testable widget with router
//     Widget createTestableWidget() {
//       return MaterialApp.router(
//         routerConfig: GoRouter(
//           routes: [
//             GoRoute(
//               path: '/',
//               builder: (context, state) => const dashboard_view(),
//             ),
//             GoRoute(
//               path: '/bookingparkir',
//               builder: (context, state) => const Scaffold(
//                 body: Text('Booking Parkir Page'),
//               ),
//             ),
//             GoRoute(
//               path: '/report',
//               builder: (context, state) => const Scaffold(
//                 body: Text('Report Page'),
//               ),
//             ),
//             GoRoute(
//               path: '/reportlist',
//               builder: (context, state) => const Scaffold(
//                 body: Text('Report List Page'),
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     testWidgets('should display all UI elements correctly', (WidgetTester tester) async {
//       await tester.pumpWidget(createTestableWidget());

//       expect(find.text('Hello User'), findsOneWidget);
//       expect(find.text('15'), findsOneWidget);
//       expect(find.text('/50'), findsOneWidget);
//       expect(find.text('Slots available'), findsOneWidget);
//       expect(find.text('Parkiran UC Makassar'), findsOneWidget);
//       expect(find.text('Save your spot!'), findsOneWidget);
//       expect(find.text('Reserve your slot while it\'s still available.'), findsOneWidget);
//       expect(find.text('Check Available Spot'), findsOneWidget);
//       expect(find.text('Make a Report'), findsOneWidget);
//       expect(find.text('Report List'), findsOneWidget);
//       expect(find.text('Home'), findsOneWidget);
//       expect(find.text('Scan'), findsOneWidget);
//       expect(find.text('History'), findsOneWidget);
//     });

//     testWidgets('should display correct icons', (WidgetTester tester) async {
//       await tester.pumpWidget(createTestableWidget());

//       expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
//       expect(find.byIcon(Icons.person_outline), findsOneWidget);
//       expect(find.byIcon(Icons.location_on), findsOneWidget);
//       expect(find.byIcon(Icons.directions_car), findsOneWidget);
//       expect(find.byIcon(Icons.search), findsOneWidget);
//       expect(find.byIcon(Icons.chevron_right), findsOneWidget);
//       expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
//       expect(find.byIcon(Icons.assignment_outlined), findsOneWidget);
//       expect(find.byIcon(Icons.home), findsOneWidget);
//       expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);
//       expect(find.byIcon(Icons.history), findsOneWidget);
//     });


//   testWidgets('should navigate to bookingparkir when Check Available Spot is tapped', (WidgetTester tester) async {
//   await tester.pumpWidget(createTestableWidget());

//   // Verify we start on the dashboard_view by checking a dashboard-specific text
//   expect(find.text('Hello User'), findsOneWidget);

//   // Tap the button that triggers navigation inside dashboard_view
//   await tester.tap(find.text('Check Available Spot'));
//   await tester.pumpAndSettle();

//   // Verify navigation: Booking Parkir Page is shown
//   expect(find.text('Booking Parkir Page'), findsOneWidget);
//     // expect(find.textContaining('Parkiran Mobil UC'), findsOneWidget);
// });






//     testWidgets('should navigate to report_view when Make a Report is tapped',
//     (WidgetTester tester) async {
//   // Setup: Wrap with MaterialApp and a home widget with the navigation logic
//   await tester.pumpWidget(
//     MaterialApp(
//       home: Scaffold(
//         body: Builder(
//           builder: (context) => Center(
//             child: ElevatedButton(
//               child: const Text('Check Available Spot'),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const bookingparkir()),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     ),
//   );

//   // Act: Tap the "Check Available Spot" button
//   await tester.tap(find.text('Check Available Spot'));
//   await tester.pumpAndSettle();

//   // Assert: Verify the Booking screen is shown by checking the AppBar title
//   expect(find.text('Choose a Spot'), findsOneWidget);

//   // Optional: check for unique body text to be sure
//   expect(find.textContaining('Parkiran Mobil UC'), findsOneWidget);
// });




//     testWidgets('should navigate to report_view when Make a Report is tapped',
//     (WidgetTester tester) async {
//   // Setup: Wrap with MaterialApp and a home widget with the navigation logic
//   await tester.pumpWidget(
//     MaterialApp(
//       home: Scaffold(
//         body: Builder(
//           builder: (context) => Center(
//             child: ElevatedButton(
//               child: const Text('Make a Report'),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const report_view()),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     ),
//   );

//   // Act: Tap the "Make a Report" button
//   await tester.tap(find.text('Make a Report'));
//   await tester.pumpAndSettle();

//   // Assert: Verify the report_view screen is shown by checking the AppBar title
//   expect(find.text('Make a Report'), findsOneWidget);

//   // Optional: check for unique body text to be sure
//   expect(find.textContaining('frustrating parking situation'), findsOneWidget);
// });


// testWidgets('should navigate to report_list_view when Report List is tapped',
//     (WidgetTester tester) async {
//   // Setup: Wrap with ProviderScope and MaterialApp
//   await tester.pumpWidget(
//     ProviderScope(
//       child: MaterialApp(
//         home: Scaffold(
//           body: Builder(
//             builder: (context) => Center(
//               child: ElevatedButton(
//                 child: const Text('Report List'),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => const ReportListView()),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ),
//       ),
//     ),
//   );

//   // Act: Tap the "Report List" button
//   await tester.tap(find.text('Report List'));
//   await tester.pumpAndSettle();

//   // Assert: Check for the AppBar title
//   expect(find.text('List Laporan'), findsOneWidget);
// });




    // testWidgets('should have proper accessibility', (WidgetTester tester) async {
    //   await tester.pumpWidget(createTestableWidget());

    //   expect(find.byType(GestureDetector), findsAtLeastNWidgets(3));
      
    //   final textWidgets = tester.widgetList<Text>(find.byType(Text));
    //   for (final text in textWidgets) {
    //     expect(text.data, isNotNull);
    //   }
    // });

    // testWidgets('should handle tap gestures correctly', (WidgetTester tester) async {
    //   await tester.pumpWidget(createTestableWidget());

    //   expect(find.ancestor(
    //     of: find.text('Check Available Spot'),
    //     matching: find.byType(GestureDetector),
    //   ), findsOneWidget);

    //   expect(find.ancestor(
    //     of: find.text('Make a Report'),
    //     matching: find.byType(GestureDetector),
    //   ), findsOneWidget);

    //   expect(find.ancestor(
    //     of: find.text('Report List'),
    //     matching: find.byType(GestureDetector),
    //   ), findsOneWidget);
    // });

    // testWidgets('should display logo image', (WidgetTester tester) async {
    //   await tester.pumpWidget(createTestableWidget());

    //   final imageWidget = find.byWidgetPredicate((widget) =>
    //       widget is Image &&
    //       widget.image is AssetImage &&
    //       (widget.image as AssetImage).assetName == 'assets/logowhite.png');
      
    //   expect(imageWidget, findsOneWidget);
    // });

    // testWidgets('should have correct padding and spacing', (WidgetTester tester) async {
    //   await tester.pumpWidget(createTestableWidget());

    //   expect(find.byType(Padding), findsAtLeastNWidgets(2));
    //   expect(find.byType(SizedBox), findsAtLeastNWidgets(5));
    // });
//   });
// }

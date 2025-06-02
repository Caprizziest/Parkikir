import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/view/report_view.dart';

void main() {


  testWidgets('Test dropdown, description, and submit button', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: report_view(),
        ),
      ),
    );

    // Verify initial widgets are present
    expect(find.text('Make a Report'), findsOneWidget);
    expect(find.text('Select Topic'), findsOneWidget);
    expect(find.text('Take or Select Image'), findsOneWidget);
    expect(find.text('Description (Optional)'), findsOneWidget);
    expect(find.text('Submit'), findsOneWidget);

    // ========== UPDATED DROPDOWN TEST SECTION ==========
    // Tap the dropdown via Key
    await tester.tap(find.byKey(const Key('topicDropdown')));
    await tester.pumpAndSettle();

    // Verify dropdown is open by checking for items
    expect(find.text('Parkir menghalangi akses/jalan'), findsOneWidget);
    expect(find.text('Parkir di zona terlarang'), findsOneWidget);
    expect(find.text('Parkir paralel'), findsOneWidget);
    expect(find.text('Penggunaan slot khusus tanpa izin'), findsOneWidget);
    expect(find.text('Penggunaan slot parkir lebih dari satu'), findsOneWidget);

    // Select a dropdown item
    await tester.tap(find.text('Parkir paralel').last);
    await tester.pumpAndSettle();

    // Verify selection
    expect(find.text('Parkir paralel'), findsOneWidget);
    // ========== END OF UPDATED SECTION ==========

    final descriptionField = find.byType(TextField);
    expect(descriptionField, findsOneWidget);

    const testText = 'This is a test description';
    await tester.enterText(descriptionField, testText);
    await tester.pump();

    final textField = tester.widget<TextField>(descriptionField);
    expect(textField.controller?.text, testText);
    expect(find.text('${testText.length}/50'), findsOneWidget);

    const longText = 'This is a very long description that exceeds the maximum character limit of 50';
    await tester.enterText(descriptionField, longText);
    await tester.pump();

    expect(textField.controller?.text.length, 50);
    expect(find.text('50/50'), findsOneWidget);

    final submitButton = find.text('Submit');
    expect(submitButton, findsOneWidget);
  });

  testWidgets('Test modal bottom sheet appears', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: report_view(),
        ),
      ),
    );

    final imageUploadArea = find.ancestor(
      of: find.text('Take or Select Image'),
      matching: find.byType(GestureDetector),
    );
    expect(imageUploadArea, findsOneWidget);
    
    await tester.tap(imageUploadArea);
    await tester.pumpAndSettle();

    expect(find.text('Take a photo'), findsOneWidget);
    expect(find.text('Choose from gallery'), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(2));

    await tester.tapAt(Offset.zero);
    await tester.pumpAndSettle();
    expect(find.text('Take a photo'), findsNothing);
  });
}
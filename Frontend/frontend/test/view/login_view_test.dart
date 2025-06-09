import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:frontend/view/login_view.dart';
import 'package:frontend/viewmodel/login_view_model.dart';

// Generate mocks
@GenerateMocks([LoginViewModel, GoRouter])
import 'login_view_test.mocks.dart';

void main() {
  group('Test Widget LoginView', () {
    late MockLoginViewModel mockViewModel;

    setUp(() {
      
      mockViewModel = MockLoginViewModel();

      // Setup default mock behaviors
      when(mockViewModel.usernameController)
          .thenReturn(TextEditingController());
      when(mockViewModel.passwordController)
          .thenReturn(TextEditingController());
      when(mockViewModel.obscureText).thenReturn(true);
      when(mockViewModel.isFormValid).thenReturn(false);
      when(mockViewModel.isLoading).thenReturn(false);
      when(mockViewModel.errorMessage).thenReturn(null);
    });

    tearDown(() {
      mockViewModel.usernameController.dispose();
      mockViewModel.passwordController.dispose();
    });

    // Helper function to create widget under test
    Widget createWidgetUnderTest({LoginViewModel? viewModel}) {
      return ProviderScope(
        overrides: [
          loginViewModelProvider
              .overrideWith((ref) => viewModel ?? mockViewModel),
        ],
        child: MaterialApp.router(
          routerConfig: GoRouter(
            routes: [
              GoRoute(
                path: '/login',
                builder: (context, state) => const LoginView(),
              ),
              GoRoute(
                path: '/register',
                builder: (context, state) => const Scaffold(
                  body: Center(child: Text('Register Page')),
                ),
              ),
              GoRoute(
                path: '/',
                builder: (context, state) => const Scaffold(
                  body: Center(child: Text('Home Page')),
                ),
              ),
            ],
            initialLocation: '/login',
          ),
        ),
      );
    }

    group('Test Verifikasi Komponen UI', () {
      testWidgets('harus menampilkan semua komponen UI yang diperlukan',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        // Verify logo is displayed
        expect(find.byType(Image), findsOneWidget);

        // Verify "Log In" title and underline
        expect(find.text('Log In'), findsOneWidget);
        expect(find.byType(Container),
            findsWidgets); // Contains the underline container

        // Verify username field and label
        expect(find.text('Username'), findsOneWidget);
        expect(find.widgetWithText(TextField, ''),
            findsNWidgets(2)); // Username and password fields

        // Verify password field and label
        expect(find.text('Password'), findsOneWidget);

        // Verify forgot password button
        expect(find.text('Forgot Password?'), findsOneWidget);
        expect(find.widgetWithText(TextButton, 'Forgot Password?'),
            findsOneWidget);

        // Verify login button
        expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);

        // Verify create account text and button
        expect(find.text('Don\'t have account? '), findsOneWidget);
        expect(find.text('Create Here!'), findsOneWidget);
        expect(find.widgetWithText(TextButton, 'Create Here!'), findsOneWidget);

        // Verify password visibility toggle icon
        expect(find.byIcon(PhosphorIcons.eyeClosed(PhosphorIconsStyle.bold)),
            findsOneWidget);
      });

      testWidgets('harus menampilkan pesan error ketika ada',
          (WidgetTester tester) async {
        when(mockViewModel.errorMessage).thenReturn('Invalid credentials');

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.text('Invalid credentials'), findsOneWidget);
        expect(
            find.byWidgetPredicate((widget) =>
                widget is Text &&
                widget.data == 'Invalid credentials' &&
                widget.style?.color == Colors.red),
            findsOneWidget);
      });

      testWidgets('tidak boleh menampilkan pesan error ketika null',
          (WidgetTester tester) async {
        when(mockViewModel.errorMessage).thenReturn(null);

        await tester.pumpWidget(createWidgetUnderTest());

        expect(
            find.byWidgetPredicate((widget) =>
                widget is Text && widget.style?.color == Colors.red),
            findsNothing);
      });
    });

    group('Test Interaksi Tombol', () {
      testWidgets('harus toggle visibilitas password ketika icon mata ditekan',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        // Find and tap the password visibility toggle
        final eyeIconButton = find.byWidgetPredicate(
            (widget) => widget is IconButton && widget.icon is Icon);

        expect(eyeIconButton, findsOneWidget);
        await tester.tap(eyeIconButton);

        // Verify togglePasswordVisibility was called
        verify(mockViewModel.togglePasswordVisibility()).called(1);
      });

      testWidgets(
          'harus menampilkan icon mata yang berbeda ketika obscureText false',
          (WidgetTester tester) async {
        when(mockViewModel.obscureText).thenReturn(false);

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.byIcon(PhosphorIcons.eye(PhosphorIconsStyle.bold)),
            findsOneWidget);
        expect(find.byIcon(PhosphorIcons.eyeClosed(PhosphorIconsStyle.bold)),
            findsNothing);
      });

      testWidgets(
          'harus mengaktifkan tombol login ketika form valid dan tidak loading',
          (WidgetTester tester) async {
        when(mockViewModel.isFormValid).thenReturn(true);
        when(mockViewModel.isLoading).thenReturn(false);

        await tester.pumpWidget(createWidgetUnderTest());

        final loginButton = find.widgetWithText(ElevatedButton, 'Login');
        final elevatedButton = tester.widget<ElevatedButton>(loginButton);

        expect(elevatedButton.onPressed, isNotNull);
      });

      testWidgets('harus menonaktifkan tombol login ketika form tidak valid',
          (WidgetTester tester) async {
        when(mockViewModel.isFormValid).thenReturn(false);
        when(mockViewModel.isLoading).thenReturn(false);

        await tester.pumpWidget(createWidgetUnderTest());

        final loginButton = find.widgetWithText(ElevatedButton, 'Login');
        final elevatedButton = tester.widget<ElevatedButton>(loginButton);

        expect(elevatedButton.onPressed, isNull);
      });

      testWidgets('harus menampilkan loading indicator ketika isLoading true',
          (WidgetTester tester) async {
        when(mockViewModel.isLoading).thenReturn(true);

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Login'), findsNothing);
      });

      testWidgets('harus memanggil method login ketika tombol login ditekan',
          (WidgetTester tester) async {
        when(mockViewModel.isFormValid).thenReturn(true);
        when(mockViewModel.isLoading).thenReturn(false);
        when(mockViewModel.login()).thenAnswer((_) async => true);

        await tester.pumpWidget(createWidgetUnderTest());

        final loginButton = find.widgetWithText(ElevatedButton, 'Login');
        await tester.tap(loginButton);
        await tester.pump();

        verify(mockViewModel.login()).called(1);
      });
    });

    group('Test Navigasi', () {
      testWidgets(
          'harus navigasi ke halaman register ketika Create Here ditekan',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        final createAccountButton =
            find.widgetWithText(TextButton, 'Create Here!');
        await tester.tap(createAccountButton);
        await tester.pumpAndSettle();

        // Verify navigation to register page
        expect(find.text('Register Page'), findsOneWidget);
      });

      testWidgets('harus navigasi ke halaman home setelah login berhasil',
          (WidgetTester tester) async {
        when(mockViewModel.isFormValid).thenReturn(true);
        when(mockViewModel.isLoading).thenReturn(false);
        when(mockViewModel.login()).thenAnswer((_) async => true);

        await tester.pumpWidget(createWidgetUnderTest());

        final loginButton = find.widgetWithText(ElevatedButton, 'Login');
        await tester.tap(loginButton);
        await tester.pumpAndSettle();

        // Verify navigation to home page
        expect(find.text('Home Page'), findsOneWidget);
      });

      testWidgets('harus menampilkan snackbar sukses setelah login berhasil',
          (WidgetTester tester) async {
        when(mockViewModel.isFormValid).thenReturn(true);
        when(mockViewModel.isLoading).thenReturn(false);
        when(mockViewModel.login()).thenAnswer((_) async => true);

        await tester.pumpWidget(createWidgetUnderTest());

        final loginButton = find.widgetWithText(ElevatedButton, 'Login');
        await tester.tap(loginButton);
        await tester.pump(); // Process the tap
        await tester.pump(
            const Duration(milliseconds: 100)); // Allow snackbar to appear

        expect(find.byType(SnackBar), findsAtLeastNWidgets(1));
      });

      testWidgets('tidak boleh navigasi ketika login gagal',
          (WidgetTester tester) async {
        when(mockViewModel.isFormValid).thenReturn(true);
        when(mockViewModel.isLoading).thenReturn(false);
        when(mockViewModel.login()).thenAnswer((_) async => false);

        await tester.pumpWidget(createWidgetUnderTest());

        final loginButton = find.widgetWithText(ElevatedButton, 'Login');
        await tester.tap(loginButton);
        await tester.pumpAndSettle();

        // Should still be on login page
        expect(find.text('Log In'), findsOneWidget);
        expect(find.text('Home Page'), findsNothing);
      });
    });

    group('Test Input Teks', () {
      testWidgets('harus mengupdate field username ketika teks dimasukkan',
          (WidgetTester tester) async {
        final usernameController = TextEditingController();
        when(mockViewModel.usernameController).thenReturn(usernameController);

        await tester.pumpWidget(createWidgetUnderTest());

        final usernameField = find.byWidgetPredicate((widget) =>
            widget is TextField && widget.controller == usernameController);

        await tester.enterText(usernameField, 'testuser');
        expect(usernameController.text, equals('testuser'));
      });

      testWidgets('harus mengupdate field password ketika teks dimasukkan',
          (WidgetTester tester) async {
        final passwordController = TextEditingController();
        when(mockViewModel.passwordController).thenReturn(passwordController);

        await tester.pumpWidget(createWidgetUnderTest());

        final passwordField = find.byWidgetPredicate((widget) =>
            widget is TextField && widget.controller == passwordController);

        await tester.enterText(passwordField, 'password123');
        expect(passwordController.text, equals('password123'));
      });

      testWidgets('harus menyembunyikan password field ketika obscureText true',
          (WidgetTester tester) async {
        when(mockViewModel.obscureText).thenReturn(true);

        await tester.pumpWidget(createWidgetUnderTest());

        final passwordField = find.byWidgetPredicate(
            (widget) => widget is TextField && widget.obscureText == true);

        expect(passwordField, findsOneWidget);
      });
    });

    group('Test Scrolling dan Gesture', () {
      testWidgets('harus menangani gesture tap pada tombol-tombol',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        // Test multiple tap gestures
        final forgotPasswordButton =
            find.widgetWithText(TextButton, 'Forgot Password?');
        final createAccountButton =
            find.widgetWithText(TextButton, 'Create Here!');

        // Tap forgot password (should not throw error)
        await tester.tap(forgotPasswordButton);
        await tester.pump();

        // Tap create account
        await tester.tap(createAccountButton);
        await tester.pumpAndSettle();

        expect(find.text('Register Page'), findsOneWidget);
      });

      testWidgets('harus menangani gesture long press',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        // Test long press on text fields (should show text selection menu)
        final usernameField = find.byWidgetPredicate((widget) =>
            widget is TextField &&
            widget.controller == mockViewModel.usernameController);

        await tester.enterText(usernameField, 'testuser');
        await tester.longPress(usernameField);
        await tester.pump();

        // Should not throw any errors
        expect(tester.takeException(), isNull);
      });
    });

    group('Test State Widget', () {
      testWidgets('harus mempertahankan hierarki widget yang benar',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        // Verify main structure
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(SafeArea), findsOneWidget);
        expect(find.byType(Padding), findsWidgets);
        expect(find.byType(Column), findsWidgets);

        // Verify input decorations are applied
        final textFields = find.byType(TextField);
        expect(textFields, findsNWidgets(2));

        for (int i = 0; i < 2; i++) {
          final textField = tester.widget<TextField>(textFields.at(i));
          expect(textField.decoration, isNotNull);
          expect(textField.decoration!.filled, isTrue);
          expect(textField.decoration!.fillColor, equals(Colors.white));
        }
      });

      testWidgets('harus menerapkan styling yang benar pada tombol-tombol',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        // Check login button styling
        final loginButton = find.widgetWithText(ElevatedButton, 'Login');
        final elevatedButton = tester.widget<ElevatedButton>(loginButton);

        expect(elevatedButton.style?.backgroundColor?.resolve({}),
            equals(const Color(0xFF4B4BEE)));
        expect(elevatedButton.style?.foregroundColor?.resolve({}),
            equals(Colors.white));

        // Check text button styling
        final forgotPasswordButton =
            find.widgetWithText(TextButton, 'Forgot Password?');
        final textButton = tester.widget<TextButton>(forgotPasswordButton);

        expect(textButton.style?.foregroundColor?.resolve({}),
            equals(const Color(0xFF4B4BEE)));
      });
    });
  });
}

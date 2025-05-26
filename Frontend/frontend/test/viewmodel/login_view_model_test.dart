// File: test/login_view_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/repository/login_repository.dart';
import 'package:frontend/viewmodel/login_view_model.dart';
import 'package:frontend/services/token_service.dart';

@GenerateMocks([LoginRepository, TokenService])
import 'login_view_model_test.mocks.dart';

void main() {
  late LoginViewModel viewModel;
  late MockLoginRepository mockRepository;
  late MockTokenService mockTokenService;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockLoginRepository();
    mockTokenService = MockTokenService();
    viewModel = LoginViewModel(
      repository: mockRepository,
      tokenService: mockTokenService,
    );
    container = ProviderContainer(
      overrides: [
        loginViewModelProvider.overrideWith(
          (ref) => LoginViewModel(
            repository: mockRepository,
            tokenService: mockTokenService,
          ),
        ),
      ],
    );
    reset(mockRepository);
    reset(mockTokenService);
  });

  tearDown(() {
    container.dispose();
  });
  group('Run All Test', () {
    group('LoginViewModel Basic Functionality', () {
      test('initial state should have obscureText true and isLoading false',
          () {
        expect(viewModel.obscureText, true);
        expect(viewModel.isLoading, false);
        expect(viewModel.errorMessage, null);
      });

      test('togglePasswordVisibility should flip obscureText', () {
        // Initial state
        expect(viewModel.obscureText, true);

        // First toggle
        viewModel.togglePasswordVisibility();
        expect(viewModel.obscureText, false);

        // Second toggle
        viewModel.togglePasswordVisibility();
        expect(viewModel.obscureText, true);
      });

      test('isFormValid should reflect text field states', () {
        // Empty fields
        expect(viewModel.isFormValid, false);

        // Fill username only
        viewModel.usernameController.text = 'user';
        viewModel.passwordController.text = '';
        expect(viewModel.isFormValid, false);

        // Fill password only
        viewModel.usernameController.text = '';
        viewModel.passwordController.text = 'pass';
        expect(viewModel.isFormValid, false);

        // Both filled
        viewModel.usernameController.text = 'user';
        viewModel.passwordController.text = 'pass';
        expect(viewModel.isFormValid, true);
      });
    });

    group('Login Functionality', () {
      test('successful login should save tokens and return true', () async {
        // Arrange
        final mockResponse = {
          'success': true,
          'access_token': 'access123',
          'refresh_token': 'refresh456'
        };

        when(mockRepository.login(any)).thenAnswer((_) async => mockResponse);
        when(mockTokenService.saveAccessToken('access123'))
            .thenAnswer((_) async => true);
        when(mockTokenService.saveRefreshToken('refresh456'))
            .thenAnswer((_) async => true);
        // Act
        viewModel.usernameController.text = 'validUser';
        viewModel.passwordController.text = 'validPass';
        final result = await viewModel.login();

        // Assert
        expect(result, true);
        verifyInOrder([
          mockRepository.login(any),
          mockTokenService.saveAccessToken('access123'),
          mockTokenService.saveRefreshToken('refresh456'),
        ]);
      });

      test('failed login should set error message', () async {
        // Arrange
        final mockResponse = {
          'success': false,
          'detail': 'Invalid credentials'
        };
        when(mockRepository.login(any)).thenAnswer((_) async => mockResponse);

        // Act
        viewModel.usernameController.text = 'invalidUser';
        viewModel.passwordController.text = 'wrongPass';
        final result = await viewModel.login();

        // Assert
        expect(result, false);
        expect(viewModel.errorMessage, 'Invalid username or password');
      });

      test('network error should set generic error message', () async {
        // Arrange
        when(mockRepository.login(any)).thenThrow(Exception('Network error'));

        // Act
        viewModel.usernameController.text = 'user';
        viewModel.passwordController.text = 'pass';
        final result = await viewModel.login();

        // Assert
        expect(result, false);
        expect(viewModel.errorMessage, 'System error occurred');
      });

      test('should handle loading state correctly', () async {
        // Arrange
        when(mockRepository.login(any)).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return {'success': true};
        });

        // Act
        viewModel.usernameController.text = 'validUser';
        viewModel.passwordController.text = 'validPass';
        final future = viewModel.login();

        expect(viewModel.isLoading, true);
        await future;
        expect(viewModel.isLoading, false);
      });
    });

    group('dispose', () {
      test('should dispose text controllers', () {
        // Arrange
        viewModel = LoginViewModel();

        // Act
        viewModel.dispose();

        // Assert - Controllers should be disposed (no direct way to test, but method should complete)
        expect(() => viewModel.dispose(), returnsNormally);
      });
    });
  });
}

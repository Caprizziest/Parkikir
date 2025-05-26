import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:frontend/repository/login_repository.dart';
import 'package:frontend/services/login_service.dart';
import 'package:frontend/model/login_model.dart';

// Generate mock dengan perintah: flutter packages pub run build_runner build
@GenerateMocks([LoginService])
import 'login_repository_test.mocks.dart';

void main() {
  late LoginRepository repository;
  late MockLoginService mockService;
  final loginModel = LoginModel(
    username: 'testuser',
    password: 'testpass',
  );

  setUp(() {
    mockService = MockLoginService();
    repository = LoginRepository(service: mockService);
  });

  group('LoginRepository', () {
    test('should return service response when login is successful', () async {
      // Arrange
      final expectedResponse = {
        'success': true,
        'access_token': 'token123',
        'refresh_token': 'refresh456'
      };

      when(mockService.login(loginModel))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final result = await repository.login(loginModel);

      // Assert
      expect(result, expectedResponse);
      verify(mockService.login(loginModel)).called(1);
      verifyNoMoreInteractions(mockService);
    });

    test('should return error response when service login fails', () async {
      final expectedResponse = {
        'success': false,
        'message': 'Invalid credentials',
      };

      when(mockService.login(loginModel))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final result = await repository.login(loginModel);

      // Assert
      expect(result, expectedResponse);
      expect(result['success'], false);
      expect(result['message'], 'Invalid credentials');
      expect(result.containsKey('access_token'), false);
      expect(result.containsKey('refresh_token'), false);

      verify(mockService.login(loginModel)).called(1);
    });

    test('should return connection error when service throws exception', () async {
      // Arrange
      final loginModel = LoginModel(
        username: 'testuser',
        password: 'testpassword',
      );

      when(mockService.login(loginModel))
          .thenThrow(Exception('Network connection failed'));

      // Act
      final call = repository.login(loginModel);

      // Assert
      expect(() async => await call, throwsA(isA<Exception>()));

      verify(mockService.login(loginModel)).called(1);
    });
  });
}

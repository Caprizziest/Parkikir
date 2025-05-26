import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:frontend/services/login_service.dart';
import 'package:frontend/model/login_model.dart';

// Generate mock dengan perintah: flutter packages pub run build_runner build
@GenerateMocks([http.Client])
import 'login_service_test.mocks.dart';


void main() {
  late LoginService loginService;
  late MockClient mockClient;
  const baseUrl = 'http://127.0.0.1:8000/api';
  final loginModel = LoginModel(
    username: 'testuser',
    password: 'testpass',
  );

  setUp(() {
    mockClient = MockClient();
    loginService = LoginService(baseUrl: baseUrl, client: mockClient);
  });

  group('LoginService', () {
    test(
        'should return access and refresh tokens when login is successful (200)',
        () async {
      // Arrange
      final mockResponse = http.Response(
        jsonEncode({
          'access': 'access_token_123',
          'refresh': 'refresh_token_456'
        }),
        200,
      );

      when(mockClient.post(
        Uri.parse('$baseUrl/login/'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => mockResponse);

      // Act
      final result = await loginService.login(loginModel);

      // Assert
      expect(result['success'], true);
      expect(result['access_token'], 'access_token_123');
      expect(result['refresh_token'], 'refresh_token_456');
      
      verify(mockClient.post(
        Uri.parse('$baseUrl/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(loginModel.toJson()),
      )).called(1);
    });

    test('should handle invalid credentials (401)', () async {
      // Arrange
      final mockResponse = http.Response(
        jsonEncode({'detail': 'Invalid credentials'}),
        401,
      );

      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => mockResponse);

      // Act
      final result = await loginService.login(loginModel);

      // Assert
      expect(result['success'], false);
      expect(result['message'], 'Invalid credentials');
    });

    test('should handle server error (500)', () async {
      // Arrange
      final mockResponse = http.Response(
        jsonEncode({'error': 'Internal Server Error'}),
        500,
      );

      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => mockResponse);

      // Act
      final result = await loginService.login(loginModel);

      // Assert
      expect(result['success'], false);
      expect(result['message'], 'Login failed');
    });

    test('should handle network exceptions', () async {
      // Arrange
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenThrow(Exception('Connection failed'));

      // Act
      final result = await loginService.login(loginModel);

      // Assert
      expect(result['success'], false);
      expect(result['message'], 'Connection error');
    });
  });
}
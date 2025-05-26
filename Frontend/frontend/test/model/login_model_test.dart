// File: test/model/login_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/model/login_model.dart';

void main() {
  group('LoginModel', () {
    // Test Case 1: Valid creation of model
    test('should create model with correct credentials', () {
      // Arrange
      const username = 'tesuser';
      const password = 'tespassword';

      // Act
      final model = LoginModel(
        username: username,
        password: password,
      );

      // Assert
      expect(model.username, username);
      expect(model.password, password);
    });

    // Test Case 2: toJson conversion
    test('should convert to JSON correctly', () {
      // Arrange
      const username = 'tesuser';
      const password = 'tespassword';
      final model = LoginModel(
        username: username,
        password: password,
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json, isA<Map<String, dynamic>>());
      expect(json['username'], username);
      expect(json['password'], password);
    });
  });
}
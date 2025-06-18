// lib/services/widget_service.dart
import 'package:flutter/services.dart';
import 'dart:io';

class WidgetService {
  static const MethodChannel _channel = MethodChannel('parking_widget');
  
  /// Update the home screen widget with new parking data
  static Future<void> updateWidget({
    required int availableSlots,
    required int totalSlots,
  }) async {
    if (!Platform.isAndroid) return;
    
    try {
      await _channel.invokeMethod('updateWidget', {
        'availableSlots': availableSlots,
        'totalSlots': totalSlots,
      });
    } on PlatformException catch (e) {
      print('Failed to update widget: ${e.message}');
    }
  }
  
  /// Check if widgets are added to home screen
  static Future<bool> hasActiveWidgets() async {
    if (!Platform.isAndroid) return false;
    
    try {
      final result = await _channel.invokeMethod('hasActiveWidgets');
      return result as bool? ?? false;
    } on PlatformException catch (e) {
      print('Failed to check active widgets: ${e.message}');
      return false;
    }
  }
}
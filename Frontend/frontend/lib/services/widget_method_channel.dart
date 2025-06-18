// lib/services/widget_method_channel.dart
import 'package:flutter/services.dart';

class WidgetMethodChannel {
  static const MethodChannel _channel = MethodChannel('parking_widget');
  
  static void setupMethodChannel() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }
  
  static Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'openApp':
        // Handle opening specific screen in app if needed
        return 'App opened';
      default:
        throw MissingPluginException('No implementation found for method ${call.method}');
    }
  }
}
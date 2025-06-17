class ApiConfig {
  // Base URL
  static const String baseUrl = 'http://10.1.49.143:8000/api';
  static const String wsBaseUrl = 'ws://10.1.49.143:8000/ws';

  // API Endpoints - centralized
  static const String loginEndpoint = '/login/';
  static const String registerEndpoint = '/register/';
  static const String refreshTokenEndpoint = '/token/refresh/';
  static const String logoutEndpoint = '/logout/';
  static const String paymentCreateEndpoint = '/payment/create/';

  // WebSocket Endpoints
  static const String parkingWebSocketEndpoint = '/parkiran/';

  // Full URLs
  static String get loginUrl => '$baseUrl$loginEndpoint';
  static String get registerUrl => '$baseUrl$registerEndpoint';
  static String get refreshTokenUrl => '$baseUrl$refreshTokenEndpoint';
  static String get logoutUrl => '$baseUrl$logoutEndpoint';
  static String get paymentCreateUrl => '$baseUrl$paymentCreateEndpoint';

  // WebSocket URLs
  static String get parkingWebSocketUrl =>
      '$wsBaseUrl$parkingWebSocketEndpoint';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

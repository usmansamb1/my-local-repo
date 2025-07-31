class Constants {
  static const String appName = 'FuelApp';
  
  // Routes
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String forgotPasswordRoute = '/forgot-password';
  static const String mainRoute = '/main';
  static const String stationsMapRoute = '/stations-map';
  static const String scanCodeRoute = '/scan-code';
  static const String fuelAppQuickRoute = '/fuelapp-quick';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String languageKey = 'language';
  
  // Validation
  static const String phonePattern = r'^5\d{8}$';
  static const String phonePrefix = '+966';
  
  // Assets
  static const String logoAsset = 'assets/images/logo.png';
  
  // API Mock Delays
  static const Duration mockDelay = Duration(seconds: 2);
}
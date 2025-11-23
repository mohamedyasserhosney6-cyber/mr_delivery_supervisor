class AppConstants {
  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'current_user';

  // API endpoints
  static const String loginEndpoint = '/auth/login';
  static const String supervisorMeEndpoint = '/supervisor/me';
  static const String ridersEndpoint = '/supervisor/riders';
  static String riderDetailsEndpoint(int riderId) => '/supervisor/riders/$riderId';
}


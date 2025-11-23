import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  // TODO: Update this to your actual API server URL
  // For local development on emulator: 'http://10.0.2.2:8000'
  // For real device on same network: 'http://YOUR_COMPUTER_IP:8000'
  // For production: 'https://api.yourdomain.com'
  // Backend URL - localhost لتشغيل محلي
  // غير ده لو Backend شغال على جهاز تاني
  static const String baseUrl = 'http://localhost:8000';
  static const String tokenKey = 'auth_token';

  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(_AuthInterceptor());
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  Dio get dio => _dio;
}

class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(ApiClient.tokenKey);

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Clear token on 401
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(ApiClient.tokenKey);
      
      // You can emit an event here to notify the app to logout
      // For now, we'll let the repository handle it
    }
    handler.next(err);
  }
}


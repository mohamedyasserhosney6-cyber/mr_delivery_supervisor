import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/models/user.dart';

class AuthApi {
  final ApiClient _apiClient;

  AuthApi(this._apiClient);

  Future<User> login(String phone, String password) async {
    try {
      final response = await _apiClient.dio.post(
        AppConstants.loginEndpoint,
        data: {
          'phone': phone,
          'password': password,
        },
      );

      final responseData = response.data as Map<String, dynamic>;
      
      // Backend API returns: { "user": {...}, "token": {...} }
      // Extract user and token from response
      final userData = responseData['user'] as Map<String, dynamic>;
      final tokenData = responseData['token'] as Map<String, dynamic>;
      
      // Merge user data with token
      final userWithToken = {
        ...userData,
        'token': tokenData['access_token'] as String,
      };
      
      return User.fromJson(userWithToken);
    } on DioException catch (e) {
      if (e.response != null) {
        final errorDetail = e.response?.data['detail'] ?? e.response?.data['message'];
        throw Exception('فشل تسجيل الدخول: ${errorDetail ?? 'خطأ غير معروف'}');
      } else {
        throw Exception('فشل الاتصال بالخادم');
      }
    }
  }

  Future<User> getCurrentUser() async {
    try {
      final response = await _apiClient.dio.get(
        AppConstants.supervisorMeEndpoint,
      );

      return User.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('انتهت صلاحية الجلسة');
      }
      throw Exception('فشل تحميل بيانات المستخدم');
    }
  }
}


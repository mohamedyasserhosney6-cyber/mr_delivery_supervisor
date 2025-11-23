import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../../core/constants/app_constants.dart';
import '../../domain/models/user.dart';
import '../api/auth_api.dart';
import '../../../../core/network/api_client.dart';

class AuthRepository {
  final AuthApi _authApi;
  final SharedPreferences _prefs;

  AuthRepository(this._authApi, this._prefs);

  Future<User> login(String phone, String password) async {
    final user = await _authApi.login(phone, password);
    
    // Save token
    if (user.token != null) {
      await _prefs.setString(AppConstants.tokenKey, user.token!);
    }
    
    // Save user data
    await _prefs.setString(AppConstants.userKey, jsonEncode(user.toJson()));
    
    return user;
  }

  Future<void> logout() async {
    await _prefs.remove(AppConstants.tokenKey);
    await _prefs.remove(AppConstants.userKey);
  }

  Future<User?> getCurrentUser() async {
    try {
      // Try to get from API first
      final user = await _authApi.getCurrentUser();
      
      // Update stored user
      await _prefs.setString(AppConstants.userKey, jsonEncode(user.toJson()));
      
      return user;
    } catch (e) {
      // Fallback to stored user
      final userJson = _prefs.getString(AppConstants.userKey);
      if (userJson != null) {
        return User.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
      }
      return null;
    }
  }

  bool hasToken() {
    return _prefs.getString(AppConstants.tokenKey) != null;
  }

  String? getToken() {
    return _prefs.getString(AppConstants.tokenKey);
  }
}


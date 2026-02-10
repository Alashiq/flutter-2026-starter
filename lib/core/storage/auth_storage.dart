import 'package:get_storage/get_storage.dart';

class AuthStorage {
  static const String _tokenKey = 'auth_token';
  static const String _userDataKey = 'user_data';

  final GetStorage _storage = GetStorage();

  // ==================== Token Management ====================

  /// Save authentication token to storage
  Future<void> saveToken(String token) async {
    await _storage.write(_tokenKey, token);
  }

  /// Read authentication token from storage
  String? readToken() {
    return _storage.read<String>(_tokenKey);
  }

  /// Clear authentication token from storage
  Future<void> clearToken() async {
    await _storage.remove(_tokenKey);
  }

  // ==================== Complete Auth Clear ====================

  /// Clear all authentication data (token + user data)
  Future<void> clearAll() async {
    await clearToken();
  }

  // ==================== Check Auth Status ====================

  /// Check if user is authenticated (has valid token)
  bool get isAuthenticated => readToken() != null;
}

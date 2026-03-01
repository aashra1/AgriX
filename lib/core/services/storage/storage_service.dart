import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  StorageService({required SharedPreferences prefs}) : _prefs = prefs;

  // ============ SharedPreferences Methods ============

  // String
  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  String? getString(String key) => _prefs.getString(key);

  // Int
  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);
  int? getInt(String key) => _prefs.getInt(key);

  // Double
  Future<bool> setDouble(String key, double value) =>
      _prefs.setDouble(key, value);
  double? getDouble(String key) => _prefs.getDouble(key);

  // Bool
  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);
  bool? getBool(String key) => _prefs.getBool(key);

  // StringList
  Future<bool> setStringList(String key, List<String> value) =>
      _prefs.setStringList(key, value);
  List<String>? getStringList(String key) => _prefs.getStringList(key);

  // Remove & Clear
  Future<bool> remove(String key) => _prefs.remove(key);
  Future<bool> clear() => _prefs.clear();

  // Check if key exists
  bool containsKey(String key) => _prefs.containsKey(key);

  // ============ Secure Storage Methods for Tokens ============

  // Regular auth token
  Future<void> setAuthToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  Future<String?> getAuthToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  Future<void> removeAuthToken() async {
    await _secureStorage.delete(key: 'auth_token');
  }

  // Temp token for document upload
  Future<void> setTempToken(String tempToken) async {
    await _secureStorage.write(key: 'temp_token', value: tempToken);
  }

  Future<String?> getTempToken() async {
    return await _secureStorage.read(key: 'temp_token');
  }

  Future<void> removeTempToken() async {
    await _secureStorage.delete(key: 'temp_token');
  }

  // Get token (tries temp token first, then auth token)
  Future<String?> getToken() async {
    // Try temp token first for document upload scenarios
    final tempToken = await getTempToken();
    if (tempToken != null) {
      return tempToken;
    }

    // Fall back to regular auth token
    return await getAuthToken();
  }

  // Clear all tokens (logout)
  Future<void> clearAllTokens() async {
    await removeAuthToken();
    await removeTempToken();
  }
}

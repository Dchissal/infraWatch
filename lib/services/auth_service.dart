import 'package:shared_preferences/shared_preferences.dart';
import 'package:infrawatch/models/user.dart';
import 'dart:convert';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  User? _currentUser;
  AuthToken? _currentToken;

  User? get currentUser => _currentUser;
  AuthToken? get currentToken => _currentToken;
  bool get isAuthenticated => _currentUser != null && _currentToken != null && !_currentToken!.isExpired;

  Future<bool> login(String email, String password) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock authentication - in real app, this would call your API
      if (email == 'admin@infrawatch.com' && password == 'admin123') {
        _currentUser = User(
          id: '1',
          email: email,
          name: 'System Administrator',
          role: UserRole.admin,
          lastLogin: DateTime.now(),
        );

        _currentToken = AuthToken(
          token: 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
          refreshToken: 'mock_refresh_token',
          expiresAt: DateTime.now().add(const Duration(hours: 24)),
        );

        await _saveUserData();
        return true;
      } else if (email == 'tech@infrawatch.com' && password == 'tech123') {
        _currentUser = User(
          id: '2',
          email: email,
          name: 'IT Technician',
          role: UserRole.technician,
          lastLogin: DateTime.now(),
        );

        _currentToken = AuthToken(
          token: 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
          refreshToken: 'mock_refresh_token',
          expiresAt: DateTime.now().add(const Duration(hours: 24)),
        );

        await _saveUserData();
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    _currentToken = null;
    await _clearUserData();
  }

  Future<void> loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final tokenJson = prefs.getString(_tokenKey);
      final userJson = prefs.getString(_userKey);

      if (tokenJson != null && userJson != null) {
        _currentToken = AuthToken.fromJson(jsonDecode(tokenJson));
        _currentUser = User.fromJson(jsonDecode(userJson));

        // Check if token is expired
        if (_currentToken!.isExpired) {
          await logout();
        }
      }
    } catch (e) {
      await logout();
    }
  }

  Future<void> _saveUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (_currentToken != null) {
        await prefs.setString(_tokenKey, jsonEncode(_currentToken!.toJson()));
      }
      
      if (_currentUser != null) {
        await prefs.setString(_userKey, jsonEncode(_currentUser!.toJson()));
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userKey);
    } catch (e) {
      // Handle error
    }
  }
}
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../utils/constants.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  bool _isLoggedIn = false;
  User? _currentUser;

  bool get isLoggedIn => _isLoggedIn;
  User? get currentUser => _currentUser;

  Future<bool> login(String phoneNumber, String password) async {
    await Future.delayed(Constants.mockDelay);
    
    if (phoneNumber.isNotEmpty && password.isNotEmpty) {
      _currentUser = User(
        id: '1',
        phoneNumber: phoneNumber,
        fullName: 'User Name',
      );
      _isLoggedIn = true;
      return true;
    }
    return false;
  }

  Future<bool> register({
    required String fullName,
    required String phoneNumber,
    required String password,
    required String invitationCode,
  }) async {
    await Future.delayed(Constants.mockDelay);
    
    if (fullName.isNotEmpty && 
        phoneNumber.isNotEmpty && 
        password.isNotEmpty && 
        invitationCode.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<bool> forgotPassword(String phoneNumber) async {
    await Future.delayed(Constants.mockDelay);
    
    if (phoneNumber.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _currentUser = null;
  }

  Future<bool> authenticateWithBiometrics() async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
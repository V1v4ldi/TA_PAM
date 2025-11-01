import 'package:flutter/material.dart';

class LoginViewModels extends ChangeNotifier {
  String _email = "";
  String _pass = "";
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  static const String _validEmail = 'user@arsenal.com';
  static const String _validPassword = 'gooners';

  void setEmail(String email) {
    _email = email.trim();
    _errorMessage = null;
    notifyListeners();
  }

  void setPass(String pass) {
    _pass = pass.trim();
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> login() async {
    if (_email.isEmpty || _pass.isEmpty) {
      _errorMessage = "email atau password harus diisi";
      notifyListeners();
      return false;
    }

    _setLoading(true);

    await Future.delayed(const Duration(seconds: 2));

    bool success = (_email == _validEmail && _pass == _validPassword);

    if (!success) {
      _errorMessage = "Kredensial tidak valid";
    } else {
      _errorMessage = null;
    }

    _setLoading(false);
    return success;
  }

  void _setLoading(bool value) {
    _isLoading = value;
  }
}

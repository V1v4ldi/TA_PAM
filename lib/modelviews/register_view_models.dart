import 'package:flutter/material.dart';

class RegisterViewModel extends ChangeNotifier {
  String _name = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setName(String val) => _name = val;
  void setEmail(String val) => _email = val;
  void setPass(String val) => _password = val;
  void setConfirmPass(String val) => _confirmPassword = val;

  Future<bool> register() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Simulasi delay network
    await Future.delayed(const Duration(seconds: 2));

    // Validasi sederhana
    if (_name.isEmpty || _email.isEmpty || _password.isEmpty) {
      _errorMessage = "Semua kolom wajib diisi";
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (_password != _confirmPassword) {
      _errorMessage = "Konfirmasi password tidak cocok";
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Jika sukses
    _isLoading = false;
    notifyListeners();
    return true;
  }
}
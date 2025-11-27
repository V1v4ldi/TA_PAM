import 'package:flutter/material.dart';
import 'package:tugas_akhir/data/repositories/auth_repositories.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthRepositories _authRepositories;
  RegisterViewModel(this._authRepositories);

  String _username = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setName(String val) => _username = val;
  void setEmail(String val) => _email = val;
  void setPass(String val) => _password = val;
  void setConfirmPass(String val) => _confirmPassword = val;

  Future<bool> register() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (_username.isEmpty || _email.isEmpty || _password.isEmpty) {
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

    try {
      final regis = await _authRepositories.register(
        _email,
        _password,
        _username,
      );
      if (regis == null) {
        _errorMessage = 'Gagal Membuat Akun';
        return false;
      }
      return true;
    } catch (e) {
      _errorMessage = "Gagal Melakukan Registrasi: ${e.toString()}";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

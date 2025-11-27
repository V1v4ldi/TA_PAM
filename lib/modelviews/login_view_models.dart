import 'package:flutter/material.dart';
import 'package:tugas_akhir/data/repositories/auth_repositories.dart';

class LoginViewModels extends ChangeNotifier {
  final AuthRepositories _repo;
  LoginViewModels(this._repo);

  bool isLoading = false;
  String _email = "";
  String _password = "";
  String? errorMessage;

  void setEmail(String email) {
    _email = email;
  }

  void setPass(String pass) {
    _password = pass;
  }

  Future<bool> login() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      if (_email.isEmpty || _password.isEmpty) {
        errorMessage = "Email dan password wajib diisi";
        return false;
      }

      final user = await _repo.login(_email, _password);

      if (user == null) {
        errorMessage = "Email atau password salah";
        return false;
      }
      return true;
    } catch (e) {
      errorMessage = "Terjadi kesalahan: $e";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    isLoading = true;
    notifyListeners();
    await _repo.logout();
    isLoading = false;
    notifyListeners();
  }
}
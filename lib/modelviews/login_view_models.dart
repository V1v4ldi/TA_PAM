import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tugas_akhir/core/biometrics.dart';
import 'package:tugas_akhir/data/repositories/auth_repositories.dart';

class LoginViewModels extends ChangeNotifier {
  final AuthRepositories _repo;
  final Biometrics _biometrics;
  LoginViewModels(this._repo, this._biometrics);

  final _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  final String _emailStored = dotenv.env["SS_EMAIL"] ?? "";
  final String _passStored = dotenv.env["SS_PASS"] ?? "";

  bool isLoading = false;
  String _email = "";
  String _password = "";
  String? errorMessage;

  bool _canBioLogin = false;
  bool get canBioLogin => _canBioLogin;

  void setEmail(String email) {
    _email = email;
  }

  void setPass(String pass) {
    _password = pass;
  }

  void resetState() {
    _canBioLogin = false;
    errorMessage = null;
    isLoading = false;

    _email = "";
    _password = "";
    notifyListeners();
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

      if (user != null) {
        await _storage.write(key: _emailStored, value: _email);
        await _storage.write(key: _passStored, value: _password);
        return true;
      } else {
        errorMessage = "Email atau password salah";
        return false;
      }
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

  Future<void> checkBiometrics() async {
    try {
      final bool isSupported = await _biometrics.hasBiometric();
      final String? storedEmail = await _storage.read(key: _emailStored);
      final String? storedPass = await _storage.read(key: _emailStored);
      final bool hasCreds = storedEmail != null && storedPass != null;

      _canBioLogin = isSupported && hasCreds;
    } catch (e) {
      _canBioLogin = false;
    }
    notifyListeners();
  }

  Future<bool> loginWFingerprint() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final storedEmail = await _storage.read(key: _emailStored);
      final storedPass = await _storage.read(key: _passStored);

      if (storedEmail == null || storedPass == null) {
        errorMessage = "Kredensial Tidak Ditemukan. Silakan login manual dulu.";
        return false;
      }
      final bool isAuthenticated = await _biometrics.authWBiometric();
      if (!isAuthenticated) {
        isLoading = false;
        notifyListeners();
        return false;
      }
      final user = await _repo.login(storedEmail, storedPass);
      if (user != null) {
        return true;
      } else {
        errorMessage = "Gagal login otomatis (Password mungkin berubah)";
        await _storage.delete(key: _emailStored);
        await _storage.delete(key: _passStored);
        return false;
      }
    } catch (e) {
      errorMessage = "Session Telah Berakhir. Silahkan Login Manual";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
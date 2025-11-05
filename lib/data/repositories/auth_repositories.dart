import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tugas_akhir/data/services/db_service.dart';

class AuthRepositories {
  final AuthService _authService;
  final supabase = Supabase.instance.client;

  AuthRepositories(this._authService);

  Future<User?> login(String email, String password) async {
    try {
      final response = await _authService.login(email, password);
      if (response.user == null) {
        throw Exception("Login Gagal");
      }
      return response.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> register(String email, String password, String username) async {
    final response = await _authService.register(email, password);

    final uid = response.user!.id;

    await supabase.from('users').insert({'id': uid, 'username': username});

    return response.user;
  }

  Future<void> logout() async {
    await _authService.logout();
  }
}

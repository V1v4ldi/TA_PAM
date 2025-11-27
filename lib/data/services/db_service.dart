import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _supabase = Supabase.instance.client;

  Future<AuthResponse> login(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> register(String email, String password, String username) async {
    return await _supabase.auth.signUp(email: email, password: password, data: {'username': username});
  }

  Future<void> logout() => _supabase.auth.signOut();

  User? currentUser() => _supabase.auth.currentUser;

  Future<bool> sessionCheck() async {
    if (_supabase.auth.currentSession == null) {
      return false;
    }
    return true;
  }

  // <-- BOOKMARK (FAV TEAM) -->

  Future<bool> getBookmark(int teamId, String userId) async {
    final response = await _supabase
        .from('fav_team')
        .select()
        .eq('user_id', userId)
        .eq('api_team_id', teamId)
        .maybeSingle();

    return response != null;
  }

  Future<void> addBookmark(int teamId, String userId) async {
    await _supabase.from('fav_team').insert({
      'user_id': userId,
      'api_team_id': teamId,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> removeBookmark(int teamId, String userId) async {
    await _supabase
        .from('fav_team')
        .delete()
        .eq('user_id', userId)
        .eq('api_team_id', teamId);
  }
}

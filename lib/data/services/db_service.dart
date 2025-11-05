import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _supabase = Supabase.instance.client;

  Future<AuthResponse> login(String email, String password) async {
    return await _supabase.auth.signInWithPassword(email: email, password: password,);
  }

  Future<AuthResponse> register(String email,String password,) async {
    return await _supabase.auth.signUp(email: email, password: password);
  }

  Future<void> logout() => _supabase.auth.signOut();

  User? currentUser() => _supabase.auth.currentUser;

  // <-- BOOKMARK (FAV TEAM) -->

  Future<void> removeBookmark() async {
    
  }
}

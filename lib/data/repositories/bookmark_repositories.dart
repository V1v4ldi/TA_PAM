import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tugas_akhir/data/models/db_model.dart';
import 'package:tugas_akhir/data/services/db_service.dart';

class BookmarkRepositories {
  final AuthService _authService;
  final supabase = Supabase.instance.client;

  BookmarkRepositories(this._authService);

  Future<bool> getBookmark(int teamId, String userId) async {
    try {
      return await _authService.getBookmark(teamId, userId);
    } catch (e) {
      throw Exception("Gagal Mendapatkan Bookmark: $e");
    }
  }

  Future<void> addBookmark(int teamId, String userId) async {
    try {
      await _authService.addBookmark(teamId, userId);
    } catch (e) {
      throw Exception("Gagal Add Bookmark: $e");
    }
  }

  Future<void> removeBookmark(int teamId, String userId) async {
    try {
      await _authService.removeBookmark(teamId, userId);
    } catch (e) {
      throw Exception("Gagal Remove Bookmark: $e");
    }
  }
}

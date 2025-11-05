import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tugas_akhir/data/models/db_model.dart';
import 'package:tugas_akhir/data/services/db_service.dart';

class BookmarkRepositories {
  final AuthService _authService;
  final supabase = Supabase.instance.client;

  BookmarkRepositories(this._authService);

  Future<List<FavTeamModel>> getBookmark() async {
    final uid = _authService.currentUser()!.id;
    final response = await supabase
        .from('fav_team')
        .select()
        .eq('user_id', uid);
    return response.map((e) => FavTeamModel.fromJson(e)).toList();
  }

  addBookmark() async {}
  
  removeaddBookmark() async {}
}

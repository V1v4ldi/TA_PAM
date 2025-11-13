import 'package:flutter/material.dart';
import 'package:tugas_akhir/data/models/teams_model.dart';
import 'package:tugas_akhir/data/repositories/bookmark_repositories.dart';
import 'package:tugas_akhir/data/repositories/team_repositories.dart';
import 'package:tugas_akhir/core/notif.dart';

class TeamDetailViewModel extends ChangeNotifier {
  final TeamRepositories _teamRepo;
  final BookmarkRepositories _bookmarkRepo;

  late String userId;
  late int teamId;

  TeamDetailViewModel(this._teamRepo, this._bookmarkRepo);

  TeamModel? team;
  bool isBookmarked = false;
  bool isLoading = false;

  Future<void> getTeam(int teamId) async {
    isLoading = true;
    notifyListeners();

    try {
      team = await _teamRepo.getTeam(teamId);
    } catch (e) {
      throw Exception("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> init({required int teamId, required String userId}) async {
    // Cek status bookmark dari Supabase
    this.teamId = teamId;
    this.userId = userId;

    isBookmarked = await _bookmarkRepo.getBookmark(teamId, userId);
    await getTeam(teamId);
    notifyListeners();
  }

  Future<void> toggleBookmark() async {
    if (isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      if (isBookmarked) {
        await _bookmarkRepo.removeBookmark(teamId, userId);
        isBookmarked = false;
      } else {
        await _bookmarkRepo.addBookmark(teamId, userId);
        isBookmarked = true;
        await showNotif(
          'Tim ditambahkan',
          'Tim berhasil ditambahkan ke favorit',
        );
      }
    } catch (e) {
      throw Exception("Function Gagal Dijalankan: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

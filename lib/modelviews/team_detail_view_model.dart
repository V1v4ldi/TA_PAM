import 'package:flutter/material.dart';
import 'package:tugas_akhir/data/models/teams_model.dart';
import 'package:tugas_akhir/data/repositories/team_repositories.dart';



class TeamDetailViewModel extends ChangeNotifier {
  final TeamRepositories _teamRepo;

  TeamDetailViewModel(this._teamRepo);

  TeamModel? team;
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
}
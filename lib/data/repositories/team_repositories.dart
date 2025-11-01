import 'dart:convert';

import 'package:tugas_akhir/data/models/teams_model.dart';
import 'package:tugas_akhir/data/services/teams_service.dart';

class TeamRepositories {
  final TeamsService _teamService;

  TeamRepositories(this._teamService);

  Future<TeamModel> getTeam(int teamId) async {
    final response = await _teamService.fetchTeam(teamId);

    if (response.statusCode != 200) {
      throw Exception("Gagal Fetch/Get Data API");
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final teamData = data['response'] as List<dynamic>;

    if (teamData.isEmpty) {
      throw Exception("Tidak ada data team ditemukan");
    }

    return TeamModel.fromJson(teamData.first);
  }

  Future<List<TeamModel>> searchTeam(String query) async {
    final response = await _teamService.searchTeam(query);

    if (response.statusCode != 200) {
      throw Exception("Gagal Fetch/Get Data API");
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final teamData = data['response'] as List<dynamic>;

    if (teamData.isEmpty) {
      throw Exception("Tidak ada data team ditemukan");
    }

    return teamData
      .map((e) => TeamModel.fromJson(e))
      .toList();
  }
}

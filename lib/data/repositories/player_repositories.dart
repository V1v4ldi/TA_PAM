import 'dart:convert';

import 'package:tugas_akhir/data/models/players_model.dart';
import 'package:tugas_akhir/data/services/players_service.dart';

class PlayerRepositories {
  final PlayerService _playerService;

  PlayerRepositories(this._playerService);

  Future<List<PlayerModel>> searchPlayer(String query) async {
    final response = await _playerService.searchPlayer(query);

    if (response.statusCode != 200) {
      throw Exception("Gagal Fetch/Get Data API");
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final playerData = data['response'] as List<dynamic>;

    if (playerData.isEmpty) {
      throw Exception("Tidak ada data player ditemukan");
    }

    return playerData.map((e) => PlayerModel.fromJson(e)).toList();
  }

  Future<PlayerModel> getPlayer(int playerId) async {
    final response = await _playerService.fetchPlayer(playerId);

    if (response.statusCode != 200) {
      throw Exception("Gagal Fetch/Get Data API");
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final playerData = data['response'] as List<dynamic>;

    if (playerData.isEmpty) {
      throw Exception("Tidak ada data player ditemukan");
    }

    return PlayerModel.fromJson(playerData.first);
  }
}

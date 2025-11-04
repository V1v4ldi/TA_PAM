import 'dart:convert';
import 'package:tugas_akhir/data/models/game_detail_model.dart';
import 'package:tugas_akhir/data/models/games_model.dart';
import 'package:tugas_akhir/data/services/games_service.dart';

class GameRepository {
  final GameService _service;

  GameRepository(this._service);

  Future<List<GameModel>> getGames() async {
    final response = await _service.fetchMatch();

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch games: ${response.statusCode}");
    }

    final body = jsonDecode(response.body);

    if (body["response"] == null) {
      throw Exception("Invalid response format");
    }

    final List<dynamic> data = body["response"];

    return data.map((json) => GameModel.fromJson(json)).toList();
  }

  Future<List<GameDetailModel>> getDetailGame(int query) async {
    final response = await _service.fetchDetailMatch(query);

    if (response.statusCode != 200) {
      throw Exception("Error: ${response.statusCode}");
    }

    final body = jsonDecode(response.body);
    final data = body["response"] as List;
    return data
      .map((e) => GameDetailModel.fromJson(e))
      .toList();
  }
}
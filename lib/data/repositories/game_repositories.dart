import 'dart:convert';
import 'package:tugas_akhir/data/models/games_model.dart';
import 'package:tugas_akhir/data/services/games_service.dart';

class GameRepository {
  final GameService _service;

  GameRepository(this._service);

  Future<List<GameModel>> getGames() async {
    try {
      final response = await _service.fetchMatch();

      if (response.statusCode != 200) {
        throw Exception("Failed to fetch games: ${response.statusCode}");
      }

      final body = jsonDecode(response.body);

      if (body["response"] == null) {
        throw Exception("Invalid response format");
      }

      final List<dynamic> rawList = body["response"];

      return rawList.map((json) => GameModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception("Error parsing games: $e");
    }
  }
}

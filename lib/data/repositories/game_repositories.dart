import 'dart:convert';
import 'package:timezone/timezone.dart' as tz;
import 'package:tugas_akhir/data/models/game_detail_model.dart';
import 'package:tugas_akhir/data/models/games_model.dart';
import 'package:tugas_akhir/data/services/cache_service.dart';
import 'package:tugas_akhir/data/services/games_service.dart';

class GameRepository {
  final GameService _gameService;
  final CacheService _cacheService;

  GameRepository(this._gameService, this._cacheService);

  Future<List<GameModel>> getGames() async {
    final response = await _gameService.fetchMatch();

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
    final response = await _gameService.fetchDetailMatch(query);

    if (response.statusCode != 200) {
      throw Exception("Error: ${response.statusCode}");
    }

    final body = jsonDecode(response.body);
    final data = body["response"] as List;
    return data.map((e) => GameDetailModel.fromJson(e)).toList();
  }

  Future<List<GameModel>> convertedDate(List<GameModel> games) async {
    final appSettings = await _cacheService.loadSettings();
    final userTime = appSettings.timezone;

    final location = tz.getLocation(userTime);

    return games.map((game) {
    final convertedDate = tz.TZDateTime.from(game.date, location);
    return GameModel(
      id: game.id,
      stage: game.stage,
      week: game.week,
      date: convertedDate,
      venueName: game.venueName,
      venueCity: game.venueCity,
      status: game.status,
      home: game.home,
      away: game.away,
    );
  }).toList();
  }
}

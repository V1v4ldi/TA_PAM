import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tugas_akhir/data/models/games_model.dart';
import 'package:tugas_akhir/data/models/standings_model.dart';
import 'package:tugas_akhir/data/repositories/game_repositories.dart';
import 'package:tugas_akhir/data/services/games_service.dart';
import 'package:tugas_akhir/data/services/standings_service.dart';
import '../data/repositories/standing_repositories.dart';

class StandingsViewModel extends ChangeNotifier {
  final StandingRepositories _matchRepo = StandingRepositories(
    StandingsService(),
  );

  List<MatchModel> _allMatches = [];
  bool fetchingData = false;
  List<MatchModel> get matches => _allMatches;

  // GROUP 1: League -> List<MatchModel>
  Map<String, List<MatchModel>> get groupedByLeague {
    final Map<String, List<MatchModel>> map = {};
    for (var m in _allMatches) {
      final key = m.leagueName.isNotEmpty ? m.leagueName : 'Unknown League';
      map.putIfAbsent(key, () => []);
      map[key]!.add(m);
    }
    // optional: sort each list by position
    for (var list in map.values) {
      list.sort((a, b) => a.position.compareTo(b.position));
    }
    return map;
  }

  // GROUP 2: Conference -> List<MatchModel>
  Map<String, List<MatchModel>> get groupedByConference {
    final Map<String, List<MatchModel>> map = {};
    for (var m in _allMatches) {
      final key = m.conference.isNotEmpty ? m.conference : 'Unknown Conference';
      map.putIfAbsent(key, () => []);
      map[key]!.add(m);
    }
    for (var list in map.values) {
      list.sort((a, b) => a.position.compareTo(b.position));
    }
    return map;
  }

  // GROUP 3: Division -> List<MatchModel>
  Map<String, List<MatchModel>> get groupedByDivision {
    final Map<String, List<MatchModel>> map = {};
    for (var m in _allMatches) {
      final key = m.division.isNotEmpty ? m.division : 'Unknown Division';
      map.putIfAbsent(key, () => []);
      map[key]!.add(m);
    }
    for (var list in map.values) {
      list.sort((a, b) => a.position.compareTo(b.position));
    }
    return map;
  }

  Future<void> fetchStandings() async {
    if (_allMatches.isNotEmpty) return;

    fetchingData = true;
    notifyListeners();

    try {
      _allMatches = await _matchRepo.getStandings();
    } catch (e) {
      throw Exception("Gagal Load Pertandingan: $e");
    } finally {
      fetchingData = false;
      notifyListeners();
    }
  }
}

class GamesViewModel extends ChangeNotifier {
  final GameRepository _gameRepository = GameRepository(GameService());

  List<GameModel> games = [];
  bool isLoading = false;
  String? error;

  Future<void> loadGames() async {
    isLoading = true;
    notifyListeners();

    try {
      games = await _gameRepository.getGames();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

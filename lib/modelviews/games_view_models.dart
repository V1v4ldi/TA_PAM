import 'package:flutter/material.dart';
import 'package:tugas_akhir/data/models/games_model.dart';
import 'package:tugas_akhir/data/repositories/game_repositories.dart';

class GamesViewModels extends ChangeNotifier {
  final GameRepository _repo;

  GamesViewModels(this._repo);

  bool isLoading = false;

  List<GameModel> allGames = [];
  List<GameModel> preSeason = [];
  List<GameModel> regularSeason = [];
  List<GameModel> postSeason = [];

  String selectedSeason = "Regular Season";
  String selectedWeek = "";

  List<String> weeks = [];

  final RegExp _weekNumRe = RegExp(r'Week\s*(\d+)', caseSensitive: false);

  int _extractWeekNumber(String w) {
    final m = _weekNumRe.firstMatch(w);
    if (m != null) {
      return int.tryParse(m.group(1) ?? '') ?? -1;
    }
    return -1;
  }

  final Map<String, int> _specialOrder = {
    'Hall of Fame Weekend': 0,
    'Preseason': 0,
    'Wild Card': 1000,
    'Divisional Round': 1001,
    'Conference Championships': 1002,
    'Pro Bowl': 1003,
    'Super Bowl': 1004,
  };

  int _weekPriority(String w) {
    final num = _extractWeekNumber(w);
    if (num >= 0) return num;

    final key = _specialOrder.keys.firstWhere(
      (k) => k.toLowerCase() == w.toLowerCase(),
      orElse: () => '',
    );

    if (key.isNotEmpty) return _specialOrder[key]!;

    return 2000 + w.toLowerCase().hashCode % 1000;
  }

  int _compareWeeks(String a, String b) {
    final pa = _weekPriority(a);
    final pb = _weekPriority(b);
    if (pa != pb) return pa.compareTo(pb);
    return a.compareTo(b);
  }

  Map<String, List<GameModel>> get regularSeasonByWeek {
    final Map<String, List<GameModel>> data = {};

    for (var g in regularSeason) {
      final week = g.week.isEmpty ? "Unknown Week" : g.week;

      data.putIfAbsent(week, () => []);
      data[week]!.add(g);
    }

    return data;
  }

  List<GameModel> get filteredGames {
    if (selectedSeason == "Pre Season") return preSeason;
    if (selectedSeason == "Post Season") return postSeason;

    return regularSeasonByWeek[selectedWeek] ?? [];
  }

  void setSeason(String season) {
    selectedSeason = season;

    if (season == "Regular Season" &&
        weeks.isNotEmpty &&
        !weeks.contains(selectedWeek)) {
      selectedWeek = weeks.first;
    }
    notifyListeners();
  }

  void setWeek(String week) {
    selectedWeek = week;
    notifyListeners();
  }

  Future<void> loadGames() async {
    isLoading = true;
    notifyListeners();

    final games = await _repo.getGames();
    allGames = games;

    preSeason = games.where((g) => g.stage == "Pre Season").toList();
    regularSeason = games.where((g) => g.stage == "Regular Season").toList();
    postSeason = games.where((g) => g.stage == "Post Season").toList();

    weeks =
        regularSeason
            .map((g) => g.week)
            .where((w) => w.isNotEmpty)
            .toSet()
            .toList()
          ..sort(_compareWeeks);

    if (weeks.isNotEmpty) {
      selectedWeek = weeks.first;
    }

    isLoading = false;
    notifyListeners();
  }
}
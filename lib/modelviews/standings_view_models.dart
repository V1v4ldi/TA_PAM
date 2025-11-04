import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tugas_akhir/data/models/standings_model.dart';
import '../data/repositories/standing_repositories.dart';

class StandingsViewModels extends ChangeNotifier {
  final StandingRepositories _matchRepo;

  StandingsViewModels(this._matchRepo);

  List<MatchModel> _allMatches = [];
  bool fetchingData = false;
  List<MatchModel> get matches => _allMatches;
  List<MatchModel> get leagueSorted {
    final list = [..._allMatches];
    list.sort(_sortTeam);
    return list;
  }

  int _sortTeam(MatchModel a, MatchModel b) {
    if (a.won != b.won) return b.won.compareTo(a.won);

    final diffA = a.pointsFor - a.pointsAgainst;
    final diffB = b.pointsFor - b.pointsAgainst;
    if (diffA != diffB) return diffB.compareTo(diffA);

    if (a.pointsFor != b.pointsFor) return b.pointsFor.compareTo(a.pointsFor);

    if (a.lost != b.lost) return a.lost.compareTo(b.lost);

    return a.teamName.compareTo(b.teamName);
  }

  // GROUP BY LEAGUE
  Map<String, List<MatchModel>> get groupedByLeague {
    final Map<String, List<MatchModel>> map = {};

    for (var m in _allMatches) {
      final key = m.leagueName.isNotEmpty ? m.leagueName : 'Unknown League';
      map.putIfAbsent(key, () => []);
      map[key]!.add(m);
    }

    for (var list in map.values) {
      list.sort(_sortTeam);
    }

    return map;
  }

  Map<String, List<MatchModel>> get groupedByConference {
    final map = <String, List<MatchModel>>{};
    for (var m in _allMatches) {
      map.putIfAbsent(m.conference, () => []);
      map[m.conference]!.add(m);
    }
    map.values.forEach((list) => list.sort(_sortTeam));
    return map;
  }

  Map<String, List<MatchModel>> get groupedByDivision {
    final map = <String, List<MatchModel>>{};
    for (var m in _allMatches) {
      map.putIfAbsent(m.division, () => []);
      map[m.division]!.add(m);
    }
    map.values.forEach((list) => list.sort(_sortTeam));
    return map;
  }

  Future<void> fetchStandings() async {
    if (_allMatches.isNotEmpty) return;

    fetchingData = true;
    notifyListeners();

    try {
      _allMatches = await _matchRepo.getStandings();

      _allMatches.sort((a, b) => a.position.compareTo(b.position));
    } catch (e) {
      throw Exception("Gagal Load Pertandingan: $e");
    } finally {
      fetchingData = false;
      notifyListeners();
    }
  }
}

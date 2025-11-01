import 'package:flutter/material.dart';
import 'package:tugas_akhir/data/models/players_model.dart';
import 'package:tugas_akhir/data/models/teams_model.dart';
import 'package:tugas_akhir/data/repositories/player_repositories.dart';
import 'package:tugas_akhir/data/repositories/team_repositories.dart';

class SearchViewModels extends ChangeNotifier {
  final PlayerRepositories _playerRepo;
  final TeamRepositories _teamRepo;

  SearchViewModels(this._playerRepo, this._teamRepo);

  bool _isLoading = false;
  String _query = '';
  String? _errorMessage;
  List<PlayerModel> players = [];
  List<TeamModel> teams = [];

  bool get isLoading => _isLoading;
  String get query => _query;
  String? get errorMessage => _errorMessage;

  Future<void> search(String text) async {
    _query = text.trim();
    if (_query.isEmpty) return;
    if (_query.length < 3) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      players = await _playerRepo.searchPlayer(_query);
      teams = await _teamRepo.searchTeam(_query);
    } catch (e) {
      players = [];
      teams = [];
      _errorMessage = "Gagal mencari data: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _query = '';
    players = [];
    teams = [];
    _errorMessage = null;
    notifyListeners();
  }
}

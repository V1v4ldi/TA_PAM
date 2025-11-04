import 'package:flutter/material.dart';
import 'package:tugas_akhir/data/models/game_detail_model.dart';
import 'package:tugas_akhir/data/repositories/game_repositories.dart';

class GameDetailViewModels extends ChangeNotifier {
  final GameRepository _gameRepo;
  GameDetailViewModels(this._gameRepo);

  GameDetailModel? homeTeam;
  GameDetailModel? awayTeam;
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadDetailGame(int query) async {
    isLoading = true;
    notifyListeners();

    try {
      final List<GameDetailModel> teams = await _gameRepo.getDetailGame(query);

      if (teams.length == 2) {
        homeTeam = teams[0];
        awayTeam = teams[1];
      } else {
        errorMessage = "Response not valid — expected 2 teams";
      }
    } catch (e) {
      throw Exception("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

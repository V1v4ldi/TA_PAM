import 'package:flutter/material.dart';
import 'package:tugas_akhir/data/models/players_model.dart';
import 'package:tugas_akhir/data/repositories/player_repositories.dart';

class PlayerDetailViewModels extends ChangeNotifier {
  final PlayerRepositories _playerRepo;

  PlayerDetailViewModels(this._playerRepo);

  PlayerModel? player;
  bool isLoading = false;

  Future<void> getPlayer(int playerId) async {
    isLoading = true;
    notifyListeners();

    try {
      player = await _playerRepo.getPlayer(playerId);
    } catch (e) {
      throw Exception("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

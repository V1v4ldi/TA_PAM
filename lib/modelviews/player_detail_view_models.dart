import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/data/models/players_model.dart';
import 'package:tugas_akhir/data/repositories/player_repositories.dart';
import 'package:tugas_akhir/data/repositories/user_repositories.dart';

class PlayerDetailViewModels extends ChangeNotifier {
  final PlayerRepositories _playerRepo;
  final UserRepositories _userRepositories;

  PlayerDetailViewModels(this._playerRepo, this._userRepositories);

  Map<String, double>? rates;
  PlayerModel? player;
  bool isLoading = false;
  Map<String, double>? currency;

  double parseSalary(String? playerSalary) {
    if (playerSalary == null || playerSalary.isEmpty) return 0;


    String clean = playerSalary.replaceAll(RegExp(r'[\$,()]'), '');
    return double.tryParse(clean) ?? 0;
  }

  double convertSalary(
    double playerSalary,
    String currency,
    Map<String, double> rates,
  ) {
    final rate = rates[currency];

    if (rate == null) throw Exception('Rate for $currency not found');
    return playerSalary * rate;
  }

  // ------------------------------------------------------------------------------------------------ //

  Future<void> getPlayer(int playerId) async {
    isLoading = true;
    notifyListeners();

    try {
      player = await _playerRepo.getPlayer(playerId);
      final appSettings = await _userRepositories.loadSettings();
      final userCurrency = appSettings.currency;

      rates ??= await _playerRepo.getCurrency();

      double? cleanSalary = parseSalary(player!.salary);

      if (player!.salary == null || player!.salary!.isEmpty) return;

      if (userCurrency == 'USD') return;
      final convertedSalary = convertSalary(cleanSalary, userCurrency, rates!);

      String formatSalary(double value, String currency) {
        String sign = r'$';
        if (currency == "EUR") {
          sign = '€';
        }
        if (currency == 'IDR') {
          sign = 'Rp.';
        }
        final formatted = NumberFormat.decimalPattern().format(value);
        return "$sign $formatted";
      }

      player!.salary = formatSalary(convertedSalary, userCurrency);
    } catch (e) {
      throw Exception("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

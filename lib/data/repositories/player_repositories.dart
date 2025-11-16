import 'dart:convert';

import 'package:tugas_akhir/data/models/players_model.dart';
import 'package:tugas_akhir/data/services/currency_service.dart';
import 'package:tugas_akhir/data/services/players_service.dart';

class PlayerRepositories {
  final PlayerService _playerService;
  final CurrencyService _currencyService;

  PlayerRepositories(this._playerService, this._currencyService);

  Future<List<PlayerModel>> searchPlayer(String query) async {
    final response = await _playerService.searchPlayer(query);

    if (response.statusCode != 200) {
      throw Exception("Gagal Fetch/Get Data API");
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final playerData = data['response'] as List<dynamic>;

    return playerData.map((e) => PlayerModel.fromJson(e)).toList();
  }

  Future<PlayerModel> getPlayer(int playerId) async {
    final response = await _playerService.fetchPlayer(playerId);

    if (response.statusCode != 200) {
      throw Exception("Gagal Fetch/Get Data API");
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final playerData = data['response'] as List<dynamic>;

    if (playerData.isEmpty) {
      throw Exception("Tidak ada data player ditemukan");
    }

    return PlayerModel.fromJson(playerData.first);
  }

  Future<Map<String, double>> getCurrency() async {
    final response = await _currencyService.fetchRates();

    if (response.statusCode != 200) {
      throw Exception("Gagal Fetch Currency Rates");
    }

    final Map<String, dynamic> json = jsonDecode(response.body);
    final Map<String, dynamic> ratesJson = Map<String, dynamic>.from(json['rates']);

    final Map<String, double> rates = ratesJson.map(
      (key, value) => MapEntry(key, (value as num).toDouble()),
    );

    return rates;
  }

  double parseSalary(String? playerSalary) {
    if (playerSalary == null || playerSalary.isEmpty) return 0;

    String clean = playerSalary.replaceAll(RegExp(r'[\$,]'), '');

    return double.tryParse(clean) ?? 0;
  }

  double convertSalary(double playerSalary,String currency,Map<String, double> rates) {
    final rate = rates[currency];

    if (rate == null) throw Exception('Rate for $currency not found');
    return playerSalary * rate;
  }
}

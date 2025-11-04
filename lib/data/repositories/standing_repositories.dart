import 'dart:core';
import 'dart:convert';
import 'package:tugas_akhir/data/models/standings_model.dart';
import 'package:tugas_akhir/data/services/standings_service.dart';

class StandingRepositories {
  final StandingsService _standingService;

  StandingRepositories(this._standingService);

  Future<List<StandingsModel>> getStandings() async {
    final response = await _standingService.fetchStandings();

    if (response.statusCode != 200) {
      throw Exception("Gagal Fetch/Get Data API");
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic> matchesData = data['response'] ?? [];

    if (matchesData.isEmpty) {
      throw Exception("Tidak ada data standings ditemukan");
    }

    return matchesData.map((match) => StandingsModel.fromJson(match)).toList();
  }
}
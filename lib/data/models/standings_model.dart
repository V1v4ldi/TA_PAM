import 'dart:core';

class StandingsModel {
  final String leagueName;
  final String conference;
  final String division;
  final int position;
  final int teamId;
  final String teamName;
  final String teamLogo;
  final int won;
  final int lost;
  final int ties;
  final int pointsFor;
  final int pointsAgainst;
  final int pointsDifference;

  StandingsModel({
    required this.leagueName,
    required this.conference,
    required this.division,
    required this.position,
    required this.teamId,
    required this.teamName,
    required this.teamLogo,
    required this.won,
    required this.lost,
    required this.ties,
    required this.pointsFor,
    required this.pointsAgainst,
    required this.pointsDifference,
  });

  factory StandingsModel.fromJson(Map<String, dynamic> json) {
    return StandingsModel(
      leagueName: json['league']?['name'] ?? '',
      conference: json['conference'] ?? '',
      division: json['division'] ?? '',
      position: json['position'] ?? 0,
      teamId: json['team']?['id'] ?? '',
      teamName: json['team']?['name'] ?? '',
      teamLogo: json['team']?['logo'] ?? '',
      won: json['won'] ?? 0,
      lost: json['lost'] ?? 0,
      ties: json['ties'] ?? 0,
      pointsFor: json['points']?['for'] ?? 0,
      pointsAgainst: json['points']?['against'] ?? 0,
      pointsDifference: json['points']?['difference'] ?? 0,
    );
  }
}
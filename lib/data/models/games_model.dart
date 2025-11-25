class GameModel {
  final int id;
  final String stage;
  final String week;
  final DateTime date;
  final String venueName;
  final String venueCity;
  final String status;
  
  final TeamGame home;
  final TeamGame away;

  GameModel({
    required this.id,
    required this.stage,
    required this.week,
    required this.date,
    required this.venueName,
    required this.venueCity,
    required this.status,
    required this.home,
    required this.away,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
  final scores = json["scores"];

  return GameModel(
    id: json["game"]["id"],
    stage: json["game"]["stage"] ?? "",
    week: json["game"]["week"] ?? "",
    date: DateTime.fromMillisecondsSinceEpoch(json["game"]["date"]["timestamp"] * 1000),
    venueName: json["game"]["venue"]["name"] ?? "",
    venueCity: json["game"]["venue"]["city"] ?? "",
    status: json["game"]["status"]["short"] ?? "",
    home: TeamGame.fromJson(json["teams"]["home"])
      ..score = scores?["home"]?["total"],
    away: TeamGame.fromJson(json["teams"]["away"])
      ..score = scores?["away"]?["total"],
  );
  }

}

class TeamGame {
  final int id;
  final String name;
  final String logo;
  int? score;

  TeamGame({
    required this.id,
    required this.name,
    required this.logo,
    this.score,
  });

  factory TeamGame.fromJson(Map<String, dynamic> json) {
  return TeamGame(
    id: json["id"],
    name: json["name"],
    logo: json["logo"],
    score: json["scores"]?["total"],
  );
  }
}
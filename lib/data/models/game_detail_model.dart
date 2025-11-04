class GameDetailModel {
  final TeamInfo team;
  final TeamStatistics statistics;

  GameDetailModel({
    required this.team,
    required this.statistics,
  });

  factory GameDetailModel.fromJson(Map<String, dynamic> json) {
    return GameDetailModel(
      team: TeamInfo.fromJson(json['team']),
      statistics: TeamStatistics.fromJson(json['statistics']),
    );
  }
}

class TeamInfo {
  final int id;
  final String name;
  final String logo;

  TeamInfo({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory TeamInfo.fromJson(Map<String, dynamic> json) {
    return TeamInfo(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
    );
  }
}

class TeamStatistics {
  final FirstDowns firstDowns;
  final int plays;
  final int yards;
  final String yardsPerPlay;
  final String drives;
  final PassingStats passing;
  final RushingStats rushing;
  final String redZone;
  final String penalties;
  final int turnovers;
  final int fumblesLost;
  final int interceptions;
  final String possession;
  final int sacks;
  final int safeties;
  final int pointsAgainst;

  TeamStatistics({
    required this.firstDowns,
    required this.plays,
    required this.yards,
    required this.yardsPerPlay,
    required this.drives,
    required this.passing,
    required this.rushing,
    required this.redZone,
    required this.penalties,
    required this.turnovers,
    required this.fumblesLost,
    required this.interceptions,
    required this.possession,
    required this.sacks,
    required this.safeties,
    required this.pointsAgainst,
  });

  factory TeamStatistics.fromJson(Map<String, dynamic> json) {
    return TeamStatistics(
      firstDowns: FirstDowns.fromJson(json['first_downs']),
      plays: json['plays']?['total'] ?? 0,
      yards: json['yards']?['total'] ?? 0,
      yardsPerPlay: json['yards']?['yards_per_play'] ?? "-",
      drives: json['yards']?['total_drives'] ?? "-",
      passing: PassingStats.fromJson(json['passing']),
      rushing: RushingStats.fromJson(json['rushings']),
      redZone: json['red_zone']?['made_att'] ?? "-",
      penalties: json['penalties']?['total'] ?? "-",
      turnovers: json['turnovers']?['total'] ?? 0,
      fumblesLost: json['turnovers']?['lost_fumbles'] ?? 0,
      interceptions: json['turnovers']?['interceptions'] ?? 0,
      possession: json['posession']?['total'] ?? "0:00",
      sacks: json['sacks']?['total'] ?? 0,
      safeties: json['safeties']?['total'] ?? 0,
      pointsAgainst: json['points_against']?['total'] ?? 0,
    );
  }
}

class FirstDowns {
  final int total;
  final int passing;
  final int rushing;
  final int penalties;
  final String thirdDownEfficiency;
  final String fourthDownEfficiency;

  FirstDowns({
    required this.total,
    required this.passing,
    required this.rushing,
    required this.penalties,
    required this.thirdDownEfficiency,
    required this.fourthDownEfficiency,
  });

  factory FirstDowns.fromJson(Map<String, dynamic> json) {
    return FirstDowns(
      total: json['total'],
      passing: json['passing'],
      rushing: json['rushing'],
      penalties: json['from_penalties'],
      thirdDownEfficiency: json['third_down_efficiency'],
      fourthDownEfficiency: json['fourth_down_efficiency'],
    );
  }
}

class PassingStats {
  final int total;
  final String compAtt;
  final String yardsPerPass;
  final int interceptionsThrown;
  final String sacksYardsLost;

  PassingStats({
    required this.total,
    required this.compAtt,
    required this.yardsPerPass,
    required this.interceptionsThrown,
    required this.sacksYardsLost,
  });

  factory PassingStats.fromJson(Map<String, dynamic> json) {
    return PassingStats(
      total: json['total'],
      compAtt: json['comp_att'],
      yardsPerPass: json['yards_per_pass'],
      interceptionsThrown: json['interceptions_thrown'],
      sacksYardsLost: json['sacks_yards_lost'],
    );
  }
}

class RushingStats {
  final int total;
  final int attempts;
  final String yardsPerRush;

  RushingStats({
    required this.total,
    required this.attempts,
    required this.yardsPerRush,
  });

  factory RushingStats.fromJson(Map<String, dynamic> json) {
    return RushingStats(
      total: json['total'],
      attempts: json['attempts'],
      yardsPerRush: json['yards_per_rush'],
    );
  }
}
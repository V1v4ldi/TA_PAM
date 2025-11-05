class UserModel {
  final String id;
  final String username;
  final String? pfp;

  UserModel({required this.id, required this.username, required this.pfp});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      pfp: json['pfp'],
    );
  }
}

class FavTeamModel {
  final int id;
  final String userId;
  final int apiTeamId;

  FavTeamModel({
    required this.id,
    required this.userId,
    required this.apiTeamId,
  });

  factory FavTeamModel.fromJson(Map<String, dynamic> json) {
    return FavTeamModel(
      id: json['id'],
      userId: json['userId'],
      apiTeamId: json['apiTeamId'],
    );
  }
}

class PlayerResponse {
  final String get;
  final Map<String, dynamic> parameters;
  final List<dynamic> errors;
  final int results;
  final List<PlayerModel> response;

  PlayerResponse({
    required this.get,
    required this.parameters,
    required this.errors,
    required this.results,
    required this.response,
  });

  factory PlayerResponse.fromJson(Map<String, dynamic> json) {
    return PlayerResponse(
      get: json['get'] ?? '',
      parameters: json['parameters'] ?? {},
      errors: json['errors'] ?? [],
      results: json['results'] ?? 0,
      response: (json['response'] as List<dynamic>)
          .map((e) => PlayerModel.fromJson(e))
          .toList(),
    );
  }
}

class PlayerModel {
  final int id;
  final String name;
  final int? age;
  final String? height;
  final String? weight;
  final String? college;
  final String? group;
  final String? position;
  final int? number;
  final String? salary;
  final int? experience;
  final String? image;

  PlayerModel({
    required this.id,
    required this.name,
    this.age,
    this.height,
    this.weight,
    this.college,
    this.group,
    this.position,
    this.number,
    this.salary,
    this.experience,
    this.image,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      age: json['age'],
      height: json['height'],
      weight: json['weight'],
      college: json['college'],
      group: json['group'],
      position: json['position'],
      number: json['number'],
      salary: json['salary'],
      experience: json['experience'],
      image: json['image'],
    );
  }
}
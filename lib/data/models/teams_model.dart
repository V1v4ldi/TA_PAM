class TeamResponse {
  final String get;
  final Map<String, dynamic> parameters;
  final List<dynamic> errors;
  final int results;
  final List<TeamModel> response;

  TeamResponse({
    required this.get,
    required this.parameters,
    required this.errors,
    required this.results,
    required this.response,
  });

  factory TeamResponse.fromJson(Map<String, dynamic> json) {
    return TeamResponse(
      get: json['get'] ?? '',
      parameters: json['parameters'] ?? {},
      errors: json['errors'] ?? [],
      results: json['results'] ?? 0,
      response: (json['response'] as List<dynamic>)
          .map((e) => TeamModel.fromJson(e))
          .toList(),
    );
  }
}

class TeamModel {
  final int id;
  final String name;
  final String? code;
  final String? city;
  final String? coach;
  final String? owner;
  final String? stadium;
  final int? established;
  final String? logo;
  final Country? country;

  TeamModel({
    required this.id,
    required this.name,
    this.code,
    this.city,
    this.coach,
    this.owner,
    this.stadium,
    this.established,
    this.logo,
    this.country,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'],
      city: json['city'],
      coach: json['coach'],
      owner: json['owner'],
      stadium: json['stadium'],
      established: json['established'],
      logo: json['logo'],
      country:
          json['country'] != null ? Country.fromJson(json['country']) : null,
    );
  }
}

class Country {
  final String? name;
  final String? code;
  final String? flag;

  Country({
    this.name,
    this.code,
    this.flag,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'],
      code: json['code'],
      flag: json['flag'],
    );
  }
}
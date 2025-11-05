import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

final String _apiKey = dotenv.env['NFLAPIKEY'] ?? "";
final String _apiHost = dotenv.env['NFLAPIHOST'] ?? "";
final String _baseUrl = dotenv.env['BASENFLURL'] ?? "";

class TeamsService {
  Future<http.Response> fetchTeam(int teamId) async {
    final url = Uri.parse("$_baseUrl/teams?id=$teamId");
    return await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'x-rapidapi-host': _apiHost,
        'x-rapidapi-key': _apiKey,
      },
    );
  }

  Future<http.Response> searchTeam(String query) async {
    final url = Uri.parse("$_baseUrl/teams?league=1&season=2023&search=$query");
    return await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'x-rapidapi-host': _apiHost,
        'x-rapidapi-key': _apiKey,
      },
    );
  }

  Future<http.Response> fetchSquad(String query) async {
    final url = Uri.parse("$_baseUrl/players?season=2023&team=$query");
    return await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'x-rapidapi-host': _apiHost,
        'x-rapidapi-key': _apiKey,
      },
    );
  }
}
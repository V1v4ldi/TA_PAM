import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

final String _apiKey = dotenv.env['NFLAPIKEY'] ?? "";
final String _apiHost = dotenv.env['NFLAPIHOST'] ?? "";
final String _baseUrl = dotenv.env['BASENFLURL'] ?? "";

class GameService {
  Future<http.Response> fetchMatch() async {
    final url = Uri.parse('$_baseUrl/games?league=1&season=2023');
    return await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'x-rapidapi-host': _apiHost,
        'x-rapidapi-key': _apiKey,
      },
    );
  }

  Future<http.Response> fetchDetailMatch(int query) async {
    final url = Uri.parse('$_baseUrl/games/statistics/teams?id=$query');
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

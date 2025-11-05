import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

final String _apiKey = dotenv.env['NFLAPIKEY'] ?? "";
final String _apiHost = dotenv.env['NFLAPIHOST'] ?? "";
final String _baseUrl = dotenv.env['BASENFLURL'] ?? "";

class PlayerService {

  Future<http.Response> fetchPlayer(int playerId) async {
    final url = Uri.parse("$_baseUrl/players?id=$playerId");
    return await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'x-rapidapi-host': _apiHost,
        'x-rapidapi-key': _apiKey,
      },
    );
  }

  Future<http.Response> searchPlayer(String query) async {
    final url = Uri.parse("$_baseUrl/players?search=$query");
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

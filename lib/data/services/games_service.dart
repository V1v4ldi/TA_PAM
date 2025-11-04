import 'package:http/http.dart' as http;

const String _APIKEY = "244aa37f2c3fec3607d510a62f1ce7d9";
const String _APIHOST = "v1.american-football.api-sports.io";
const String _BaseUrl = "https://v1.american-football.api-sports.io";

class GameService {
  Future<http.Response> fetchMatch() async {
    final url = Uri.parse('$_BaseUrl/games?league=1&season=2023');
    return await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'x-rapidapi-host': _APIHOST,
        'x-rapidapi-key': _APIKEY,
      },
    );
  }

  Future<http.Response> fetchDetailMatch(int query) async {
    final url = Uri.parse('$_BaseUrl/games/statistics/teams?id=$query');
    return await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'x-rapidapi-host': _APIHOST,
        'x-rapidapi-key': _APIKEY,
      },
    );
  }
}

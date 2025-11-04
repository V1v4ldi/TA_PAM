import 'package:http/http.dart' as http;

const String _APIKEY = "244aa37f2c3fec3607d510a62f1ce7d9";
const String _APIHOST = "v1.american-football.api-sports.io";
final baseurl = 'https://v1.american-football.api-sports.io/';

class PlayerService {

  Future<http.Response> fetchPlayer(int playerId) async {
    final url = Uri.parse("$baseurl/players?id=$playerId");
    return await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'x-rapidapi-host': _APIHOST,
        'x-rapidapi-key': _APIKEY,
      },
    );
  }

  Future<http.Response> searchPlayer(String query) async {
    final url = Uri.parse("$baseurl/players?search=$query");
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

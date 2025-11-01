import 'package:http/http.dart' as http;

const String _APIKEY = "244aa37f2c3fec3607d510a62f1ce7d9";
const String _APIHOST = "v1.american-football.api-sports.io";

class GameService {
  final url = Uri.parse(
    'https://v1.american-football.api-sports.io/games?league=1&season=2023',
  );

  Future<http.Response> fetchMatch() async {
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
import 'package:http/http.dart' as http;

const String APIKEY = "244aa37f2c3fec3607d510a62f1ce7d9";
const String APIHOST = "v1.american-football.api-sports.io";

class StandingsService {
  final url = Uri.parse(
    'https://v1.american-football.api-sports.io/standings?league=1&season=2023',
  );

  Future<http.Response> fetchStandings() async {
    return await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'x-rapidapi-host': APIHOST,
        'x-rapidapi-key': APIKEY,
      },
    );
  }
}



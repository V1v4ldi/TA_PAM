import 'package:http/http.dart' as http;

const String APIKEY = "244aa37f2c3fec3607d510a62f1ce7d9";
const String APIHOST = "v1.american-football.api-sports.io";
final String baseurl = "https://v1.american-football.api-sports.io/";

class TeamsService {
  Future<http.Response> fetchTeam(int teamId) async {
    final url = Uri.parse("$baseurl/teams?id=$teamId");
    return await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'x-rapidapi-host': APIHOST,
        'x-rapidapi-key': APIKEY,
      },
    );
  }

  Future<http.Response> searchTeam(String query) async {
    final url = Uri.parse("$baseurl/teams?league=1&season=2023&search=$query");
    return await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'x-rapidapi-host': APIHOST,
        'x-rapidapi-key': APIKEY,
      },
    );
  }

  Future<http.Response> fetchSquad(String query) async {
    final url = Uri.parse("$baseurl/players?season=2023&team=$query");
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

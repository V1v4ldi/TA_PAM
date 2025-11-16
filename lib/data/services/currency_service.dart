import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CurrencyService {
  final _apiKey = dotenv.env['OPENXCHANGE_API'];
  String base = 'USD';

  Future<http.Response> fetchRates() async {
    final url = Uri.parse('https://openexchangerates.org/api/latest.json?app_id=$_apiKey');
    return await http.get(url);
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String translateAPI = "https://api.mymemory.translated.net/";
  final String cryptoAPI = "https://api.coingecko.com/api/v3";

  Future<String> translate(
      String text, String sourceLang, String targetLang) async {
    final url = Uri.parse(
        "${translateAPI}get?q=$text&langpair=$sourceLang|$targetLang");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('responseData') &&
            data['responseData']['translatedText'] != null) {
          return data['responseData']['translatedText'];
        } else {
          throw Exception("Translation not found in response.");
        }
      } else {
        throw Exception(
            "Failed to fetch translation: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Error occurred during translation: $e");
    }
  }

  Future<Map<String, dynamic>> fetchCryptoPrices(
      {required String ids, required String vsCurrencies}) async {
    final url = Uri.parse(
        "$cryptoAPI/simple/price?ids=$ids&vs_currencies=$vsCurrencies");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(
            "Failed to fetch crypto prices: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Error occurred: $e");
    }
  }
}

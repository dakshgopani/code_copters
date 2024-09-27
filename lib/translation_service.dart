import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  final String baseUrl =
      'https://microsoft-translator-text.p.rapidapi.com/translate'; // Microsoft Translator API endpoint

  // API headers, including your RapidAPI key
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'X-RapidAPI-Key':
        'b61c5492f9msh9c2716fd66c708bp1ded87jsn99b46404bfa6', // Add your RapidAPI key here
    'X-RapidAPI-Host': 'microsoft-translator-text.p.rapidapi.com',
  };

  Future<String> translateText(
      String text, String sourceLang, String targetLang) async {
    final uri = Uri.parse(
      '$baseUrl?api-version=3.0&from=$sourceLang&to=$targetLang',
    );

    final List<Map<String, String>> body = [
      {'Text': text}
    ];

    final response = await http.post(
      uri,
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty && data[0]['translations'].isNotEmpty) {
        return data[0]['translations'][0]['text'];
      } else {
        return 'Translation error: empty response';
      }
    } else {
      throw Exception('Failed to translate text: ${response.statusCode}');
    }
  }
}

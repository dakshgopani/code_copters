// translation_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  final String baseUrl =
      'http://localhost:5000/translate'; // Replace with your server IP if needed

  Future<String> translateText(
      String text, String sourceLang, String targetLang) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'q': text,
        'source': sourceLang,
        'target': targetLang,
        'format': 'text',
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['translatedText'];
    } else {
      throw Exception('Failed to translate text: ${response.statusCode}');
    }
  }
}

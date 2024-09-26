import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Future<String> translate(String text, String targetLanguage) async {
    final Uri uri = Uri.parse('https://api.mymemory.translated.net/get');

    try {
      final response = await http.get(
        uri.replace(queryParameters: {
          'q': text, // The text you want to translate
          'langpair': '${locale.languageCode}|$targetLanguage', // Language pair
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data); // Debugging line to see the full API response
        return data['responseData']['translatedText'] ?? 'Translation failed';
      } else {
        throw Exception('Failed to load translation: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e'); // Log the error for debugging
      return 'Error: ${e.toString()}';
    }
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

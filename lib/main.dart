// main.dart
import 'package:flutter/material.dart';
import 'translation_service.dart'; // Import the translation service

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Translation App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TranslationService _translationService = TranslationService();
  String _translatedText = "Hello, how are you?";
  String _selectedLanguage = 'es'; // Default to Spanish

  void _translateText() async {
    try {
      String translated = await _translationService.translateText(
        _translatedText,
        'en', // Source language
        _selectedLanguage, // Target language
      );
      setState(() {
        _translatedText = translated;
      });
    } catch (e) {
      print('Translation error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Translation App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_translatedText), // Display the translated text
            DropdownButton<String>(
              value: _selectedLanguage,
              items: [
                DropdownMenuItem(value: 'es', child: Text('Spanish')),
                DropdownMenuItem(value: 'fr', child: Text('French')),
                // Add more languages as needed
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLanguage = newValue!;
                });
              },
            ),
            ElevatedButton(
              onPressed: _translateText,
              child: Text('Translate'),
            ),
          ],
        ),
      ),
    );
  }
}

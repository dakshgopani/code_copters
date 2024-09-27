import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'translation_service.dart';

class NextScreen extends StatefulWidget {
  final String selectedLanguage;

  NextScreen({required this.selectedLanguage});

  @override
  _NextScreenState createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  late Map<String, String> _uiTranslations =
      {}; // Initialize the translation map
  final TranslationService _translationService = TranslationService();
  bool _isLoading = true;
  String? _errorMessage;

  // This will load translations for the app UI
  Future<void> _loadUiTranslations() async {
    try {
      // Fetch translations for each UI element
      final Map<String, String> translations = {
        'welcomeMessage': await _translationService.translateText(
            'Welcome to the App!', 'en', widget.selectedLanguage),
        'description': await _translationService.translateText(
            'This is a dynamically translated app.',
            'en',
            widget.selectedLanguage),
        'proceedButton': await _translationService.translateText(
            'Proceed', 'en', widget.selectedLanguage),
      };

      setState(() {
        _uiTranslations = translations;
        _isLoading = false;
        _errorMessage = null; // Clear any previous errors
      });
    } catch (e) {
      // Catch and handle any errors (e.g., network issues or API failures)
      print("Failed to load UI translations: $e");
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error loading translations: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUiTranslations(); // Load the translations when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Loading...'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text(
            _errorMessage ?? 'Unknown error',
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // When translations are loaded successfully
    return Scaffold(
      appBar: AppBar(
        title: Text(_uiTranslations['welcomeMessage'] ?? 'Welcome'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _uiTranslations['description'] ?? 'Description',
              style: GoogleFonts.notoSans(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle any action
              },
              child: Text(_uiTranslations['proceedButton'] ?? 'Proceed'),
            ),
          ],
        ),
      ),
    );
  }
}

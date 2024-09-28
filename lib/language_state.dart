// language_state.dart
import 'package:flutter/foundation.dart';

class LanguageState extends ChangeNotifier {
  String _selectedLanguage = 'en'; // Default language

  String get selectedLanguage => _selectedLanguage;

  void setSelectedLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners(); // Notify listeners of changes
  }
}

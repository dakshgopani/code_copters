import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'next_screen.dart'; // Import the next screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Translation App',
      theme: ThemeData(
        textTheme: GoogleFonts.notoSansTextTheme(),
      ),
      home:
          LanguageSelectionScreen(), // Start with the language selection screen
    );
  }
}

class LanguageSelectionScreen extends StatefulWidget {
  @override
  _LanguageSelectionScreenState createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? _selectedLanguage; // Track the selected language

  // List of languages available for selection
  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'hi', 'name': 'हिंदी'},
    {'code': 'fr', 'name': 'Français'},
    {'code': 'mr', 'name': 'मराठी'},
    {'code': 'es', 'name': 'Español'},
    {'code': 'de', 'name': 'Deutsch'},
    {'code': 'ar', 'name': 'عربي'},
    {'code': 'ru', 'name': 'Русский'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Choose Your Language')),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _languages.length,
              itemBuilder: (context, index) {
                final language = _languages[index];
                final isSelected = _selectedLanguage == language['code'];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedLanguage = language['code'];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: isSelected ? Colors.lightBlueAccent : Colors.white,
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            language['name']!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _selectedLanguage != null
                ? () {
                    // Proceed to the next screen with the selected language
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NextScreen(
                          selectedLanguage: _selectedLanguage!,
                        ),
                      ),
                    );
                  }
                : null,
            child: Text('Proceed'),
          ),
        ],
      ),
    );
  }
}

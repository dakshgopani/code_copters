import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'custom_navigation_bar.dart';
import 'language_state.dart'; // Import LanguageState

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
              // Set the selected language in LanguageState using Provider
              Provider.of<LanguageState>(context, listen: false)
                  .setSelectedLanguage(_selectedLanguage!);

              // Navigate to the next screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomNavigationBar(),
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

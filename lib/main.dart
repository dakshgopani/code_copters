import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // Import provider
import 'language_state.dart'; // Import LanguageState
import 'lang_selection_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LanguageState(), // Provide LanguageState globally
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager App',
      theme: ThemeData(
        textTheme: GoogleFonts.notoSansTextTheme(),
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home:
          LanguageSelectionScreen(), // Start with the language selection screen
    );
  }
}

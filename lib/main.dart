import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // If you're using Provider
import 'auth_screen.dart'; // Import your AuthScreen
import 'language_state.dart'; // Import your LanguageState or other providers

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => LanguageState()), // Example provider
        // Add other providers if necessary
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eventify',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      debugShowCheckedModeBanner: false,
      home: AuthScreen(), // Start with the AuthScreen
    );
  }
}

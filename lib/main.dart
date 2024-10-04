import 'package:event_planner/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // If you're using Provider
import 'auth_screen.dart'; // Import your AuthScreen
import 'language_state.dart'; // Import your LanguageState or other providers
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if the user is logged in before showing AuthScreen
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? isLoggedIn = prefs.getBool('isLoggedIn');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => LanguageState()), // Example provider
        // Add other providers if necessary
      ],
      child: MyApp(isLoggedIn: isLoggedIn ?? false),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eventify',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      debugShowCheckedModeBanner: false,
      home: isLoggedIn
          ? CustomNavigationBar()
          : AuthScreen(), // Show HomeScreen if logged in, otherwise AuthScreen
    );
  }
}

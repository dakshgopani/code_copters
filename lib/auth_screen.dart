import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'custom_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLogin = true; // Toggle for login/signup
  String? _errorMessage; // Variable to hold error message

  Future<void> _authenticate() async {
    final url = isLogin
        ? 'https://66fc384bd9202c937bdb0639--clever-taiyaki-0781e4.netlify.app/.netlify/functions/login'
        : 'https://66fc384bd9202c937bdb0639--clever-taiyaki-0781e4.netlify.app/.netlify/functions/signup';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Authentication successful, save login state
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      // Navigate to the HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CustomNavigationBar(),
        ),
      );
    } else {
      // Handle errors
      final errorData = json.decode(response.body);
      setState(() {
        _errorMessage = errorData['message']; // Save error message to state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isLogin ? 'Login' : 'Sign Up'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email input field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor:
                    Colors.orangeAccent.withOpacity(0.2), // Lighten fill color
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            // Password input field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                filled: true,
                fillColor:
                    Colors.orangeAccent.withOpacity(0.2), // Lighten fill color
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            // Error message display
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            // Authentication button
            ElevatedButton(
              onPressed: _authenticate,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: Text(isLogin ? 'Login' : 'Sign Up'),
            ),
            // Toggle between login and signup
            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin; // Toggle between login and signup
                  _errorMessage = null; // Clear error message on toggle
                });
              },
              child: Text(
                  isLogin ? 'Create an Account' : 'Already have an Account?'),
            ),
          ],
        ),
      ),
    );
  }
}

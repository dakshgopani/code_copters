import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'custom_navigation_bar.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLogin = true;
  String? _errorMessage;
  bool _passwordVisible = false;

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
      await prefs.setString('userEmail', _emailController.text); // Save email


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
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blueGrey.withOpacity(0.6),
                  Colors.purple.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Top Vector Image
                    SvgPicture.asset(
                      isLogin ? 'assets/images/undraw_fingerprint_login_re_t71l.svg' : 'assets/images/undraw_my_app_re_gxtj.svg',
                      height: 150,
                    ),
                    SizedBox(height: 30),

                    // Form Card
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            // Title
                            Text(
                              isLogin ? 'Welcome Back!' : 'Create an Account',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 20),

                            // Email TextField with Icon
                            _buildTextField(
                              controller: _emailController,
                              label: 'Email',
                              icon: Icons.email,
                              placeholder: 'Enter your email',
                            ),
                            SizedBox(height: 16),

                            // Password TextField with visibility toggle
                            _buildTextField(
                              controller: _passwordController,
                              label: 'Password',
                              icon: Icons.lock,
                              obscureText: !_passwordVisible,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                              placeholder: 'Enter your password',
                            ),
                            SizedBox(height: 20),

                            // Error message display
                            if (_errorMessage != null)
                              Text(
                                _errorMessage!,
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            SizedBox(height: 20),

                            // Authentication Button
                            ElevatedButton(
                              onPressed: _authenticate,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 16.0),
                                child: Text(
                                  isLogin ? 'Login' : 'Sign Up',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Social Media Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Facebook login button
                        _buildSocialIconButton(Icons.facebook),
                        SizedBox(width: 16),
                        // Google login button
                        _buildSocialIconButton(Icons.mail),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Toggle between login and signup
                    TextButton(

                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                          _errorMessage = null;
                        });
                      },
                      child: Text(
                        isLogin
                            ? 'Don\'t have an account? Sign Up'
                            : 'Already have an account? Login',
                        style: TextStyle(color: Colors.orangeAccent,fontSize: 17),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    String? placeholder,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(right: 16.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orangeAccent.withOpacity(0.2),
            ),
            child: Icon(icon, color: Colors.black),
          ),
          labelText: label,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          suffixIcon: suffixIcon,
          floatingLabelBehavior: FloatingLabelBehavior.never, // Adjust this
        ),
      ),
    );
  }


  Widget _buildSocialIconButton(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.deepPurpleAccent.withOpacity(0.2),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black),
        iconSize: 40,
        onPressed: () {
          // Handle social login
        },
      ),
    );
  }
}

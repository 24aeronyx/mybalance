// login_screen.dart
import 'package:flutter/material.dart';
import '../widgets/custom_button.dart'; // Import the custom button
import 'main_screen.dart'; // Import MainScreen
import 'register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    if (_formKey.currentState!.validate()) {
      // Handle login logic here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logged in as ${_emailController.text}')),
      );

      // Navigate to MainScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 74, 173, 1),
        title: const Text('Login', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), // Set back button color to white
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // MyBalance Logo with Text
            Column(
              children: [
                Image.asset('assets/img/MyBe.png', height: 100), // Display logo
                const Text(
                  'MyBalance',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromRGBO(0, 74, 173, 1)), // Bold text
                ),
              ],
            ),
            const SizedBox(height: 40), // Reduced space between logo and text
            // Welcome message
            const Text(
              'Welcome back! Please log in to continue.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Email TextField
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  // Password TextField
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Login',
                      onPressed: _login,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  // Navigate to Register
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterScreen()), // Use RegisterScreen directly
                      );
                    },
                    child: const Text('Don\'t have an account? Register here'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

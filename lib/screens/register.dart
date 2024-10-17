// register_screen.dart
import 'package:flutter/material.dart';
import '../widgets/custom_button.dart'; // Import the custom button
import 'login.dart'; // Make sure this matches your actual login screen file

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _register() {
    if (_formKey.currentState!.validate()) {
      // Handle registration logic here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registered as ${_emailController.text}')),
      );

      // Navigate to LoginScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 74, 173, 1),
        title: const Text('Register', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color:Color.fromRGBO(0, 74, 173, 1) ), // Bold text
                ),
              ],
            ),
            const SizedBox(height: 40), // Reduced space between logo and text
            // Welcome message
            const Text(
              'Create an account to get started with MyBalance!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Username TextField
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    controller: _usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
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
                  // Register Button
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Register',
                      onPressed: _register,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  // Navigate to Login
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Go back to Login screen
                    },
                    child: const Text('Already have an account? Login here'),
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

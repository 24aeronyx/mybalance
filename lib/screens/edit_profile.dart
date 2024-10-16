// edit_profile_screen.dart
import 'package:flutter/material.dart';
import '../widgets/custom_button.dart'; // Import the custom button

class EditProfileScreen extends StatelessWidget {
  final String username = "Ariel Zakly Pratama";
  final String email = "arielpratama9182@gmail.com";
  final String phoneNumber = "085389899996";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 74, 173, 1),
        title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: username),
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: email),
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: phoneNumber),
            ),
            const SizedBox(height: 20.0),
            Container(
              width: double.infinity, // Optional: Make the button take up the full width
              child: CustomButton(
                text: 'Save Changes', // Customizable text
                onPressed: () {
                  // Add your save logic here
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

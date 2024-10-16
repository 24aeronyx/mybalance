import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 74, 173, 1),
        title: const Text('About App', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: const Padding(
        padding:  EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              'About This App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
             SizedBox(height: 16.0),
             Text(
              'This app is designed to help users with legal consultations, providing information and resources related to criminal law. Our goal is to make legal assistance accessible and straightforward.',
              style: TextStyle(fontSize: 16),
            ),
             SizedBox(height: 20.0),
             Text(
              'Features:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
             SizedBox(height: 8.0),
             Text(
              '- Chatbot for legal consultation\n'
              '- User-friendly interface\n'
              '- Access to legal resources\n'
              '- Profile management\n',
              style: TextStyle(fontSize: 16),
            ),
             SizedBox(height: 20.0),
             Text(
              'Contact Us:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
             SizedBox(height: 8.0),
             Text(
              'Email: support@yourapp.com\n'
              'Phone: +123456789\n',
              style: TextStyle(fontSize: 16),
            ),
             SizedBox(height: 20.0),
             Text(
              'Version: 1.0.0',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../screens/main_screen.dart';
// import 'package:mybalance/screens/reports.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'DM Sans'
      ),
      home: const MainScreen(), 
    );
  }
}

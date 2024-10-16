import 'package:flutter/material.dart';
import 'home.dart'; // Pastikan sudah mengimpor HomeScreen
import 'history.dart'; // Pastikan sudah mengimpor HistoryScreen
import 'reports.dart'; // Pastikan sudah mengimpor ReportsPage
import 'profile.dart';
import 'edit_profile.dart';
import '../widgets/navbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of pages to navigate between
  final List<Widget> _pages = [
    HomeScreen(),
    ReportsPage(),
    HistoryScreen(),
    ProfileScreen(),
    EditProfileScreen()
  ];

  // Function to handle bottom navigation item taps
  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // This displays the currently selected screen from the _pages list
      body: _pages[_selectedIndex],

      // Custom bottom navigation bar
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onNavBarTapped,
      ),
    );
  }
}

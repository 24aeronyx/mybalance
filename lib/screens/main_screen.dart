import 'package:flutter/material.dart';
import 'home.dart'; // Ensure HomeScreen is imported
import 'history.dart'; // Ensure HistoryScreen is imported
import 'reports.dart'; // Ensure ReportsPage is imported
import 'profile.dart';
import 'edit_profile.dart';
import '../widgets/navbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  
  late List<Widget> _pages; // Declare the pages list

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(navigateToHistory: _navigateToHistory), // Pass the navigation callback
      ReportsPage(),
      const HistoryScreen(),
      ProfileScreen(),
      EditProfileScreen(),
    ];
  }

  // Function to navigate to the HistoryScreen
  void _navigateToHistory() {
    setState(() {
      _selectedIndex = 2; // Set the index to the HistoryScreen
    });
  }

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

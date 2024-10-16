// profile_screen.dart
import 'package:flutter/material.dart';
import '../widgets/summary_card.dart';
import '../widgets/menu_option.dart';
import '../screens/main_screen.dart';
import '../screens/edit_profile.dart'; // Import for navigation to EditProfileScreen
import '../screens/forgot_password.dart';
import '../screens/about.dart'; // Import for About App screen
import '../screens/login.dart'; // Import for LoginScreen

class ProfileScreen extends StatelessWidget {
  final String username = "Ariel Zakly Pratama";
  final String email = "arielpratama9182@gmail.com";
  final String phoneNumber = "085389899996";
  final double totalIncome = 5440000.00; // Example total income
  final double totalExpense = 2209000.00;

  const ProfileScreen({super.key}); // Example total expense

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 74, 173, 1),
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Navigate to MainScreen when back button is pressed
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            color: const Color.fromRGBO(0, 74, 173, 1),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      AssetImage('assets/img/MyBe-White.png'),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ariel Zakly Pratama',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  phoneNumber,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8),
            child: Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Income',
                    amount: totalIncome,
                    color: Colors.green,
                    isIncome: true,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: SummaryCard(
                    title: 'Expense',
                    amount: totalExpense,
                    color: Colors.red,
                    isIncome: false,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                MenuOption(
                  title: 'Edit Profile',
                  icon: Icons.edit,
                  iconColor: const Color.fromRGBO(0, 74, 173, 1),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfileScreen()),
                    );
                  },
                ),
                MenuOption(
                  title: 'Forgot Password',
                  icon: Icons.lock,
                  iconColor: const Color.fromRGBO(0, 74, 173, 1),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen()),
                    );
                  },
                ),
                MenuOption(
                  title: 'About App',
                  icon: Icons.info,
                  iconColor: const Color.fromRGBO(0, 74, 173, 1),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AboutAppScreen()),
                    );
                  },
                ),
                MenuOption(
                  title: 'Logout',
                  icon: Icons.logout,
                  iconColor: const Color.fromRGBO(0, 74, 173, 1),
                  onTap: () {
                    // Add logout logic here (if any)
                    // Navigate to LoginScreen when Logout is clicked
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

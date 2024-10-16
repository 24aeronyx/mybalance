import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: _buildNavItem(Icons.home, 0),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: _buildNavItem(Icons.insert_chart, 1),
          label: 'Reports',
        ),
        BottomNavigationBarItem(
          icon: _buildNavItem(Icons.history, 2),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: _buildNavItem(Icons.person, 3),
          label: 'Profile',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: const Color.fromRGBO(0, 74, 173, 1),
      unselectedItemColor: Colors.grey,
      onTap: onItemTapped,
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = selectedIndex == index;

    return Icon(
      icon,
      color: isSelected ? const Color.fromRGBO(0, 74, 173, 1) : Colors.grey,
      size: isSelected ? 28 : 24,
    );
  }
}

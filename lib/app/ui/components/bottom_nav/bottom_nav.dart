import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mybalance/app/ui/components/bottom_nav/bottom_nav_controller.dart';
import 'package:mybalance/app/utils/color.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavController bottomNavController = Get.find();
    return Obx(
      () => BottomNavigationBar(
        currentIndex: bottomNavController.selectedIndex.value,
        onTap: (index) => bottomNavController.changeTabIndex(index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long, size: 30),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history, size: 30),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30),
            label: 'Profile',
          ),
        ],
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

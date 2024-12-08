import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mybalance/app/ui/components/bottom_nav/bottom_nav_controller.dart';
import 'package:mybalance/app/utils/color.dart';
import 'package:icons_plus/icons_plus.dart';

class BottomNavBar extends GetView<BottomNavController> {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomNavigationBar(
        currentIndex: controller.selectedIndex.value,
        onTap: (index) => controller.changeTabIndex(index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(BoxIcons.bxs_home, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(BoxIcons.bxs_bar_chart_alt_2, size: 30),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(BoxIcons.bx_history, size: 30),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(BoxIcons.bxs_user, size: 30),
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

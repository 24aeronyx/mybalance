import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mybalance/app/ui/components/bottom_nav/bottom_nav.dart';
import 'package:mybalance/app/ui/pages/home/home_page.dart';
import 'package:mybalance/app/ui/pages/reports/reports_page.dart';
import 'package:mybalance/app/ui/pages/history/history_page.dart';
import 'package:mybalance/app/ui/pages/profile/profile_page.dart';
import 'package:mybalance/app/ui/components/bottom_nav/bottom_nav_controller.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final List<Widget> pages = [
    HomePage(),
    ReportsPage(),
    HistoryPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final BottomNavController bottomNavController = Get.find();

    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: bottomNavController.selectedIndex.value,
          children: pages,
        ),
        bottomNavigationBar: const BottomNavBar(), // Tambahan widget navigasi bawah
      ),
    );
  }
}
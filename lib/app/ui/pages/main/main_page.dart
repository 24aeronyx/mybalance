import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mybalance/app/ui/components/bottom_nav/bottom_nav.dart';
import 'package:mybalance/app/ui/components/bottom_nav/bottom_nav_controller.dart';
import 'package:mybalance/app/ui/pages/home/home_page.dart';
import 'package:mybalance/app/ui/pages/reports/reports_page.dart';
import 'package:mybalance/app/ui/pages/history/history_page.dart';
import 'package:mybalance/app/ui/pages/profile/profile_page.dart';

class MainPage extends GetView<BottomNavController> {
  MainPage({super.key});

  final List<Widget> pages = [
    const HomePage(),
    const ReportsPage(),
    const HistoryPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {

    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: pages,
        ),
        bottomNavigationBar: const BottomNavBar(), // Tambahan widget navigasi bawah
      ),
    );
  }
}

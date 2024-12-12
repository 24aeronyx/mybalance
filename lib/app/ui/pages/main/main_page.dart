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

  final List<Widget Function()> pageBuilders = [
    () => const HomePage(),
    () => const ReportsPage(),
    () => const HistoryPage(),
    () => const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: pageBuilders[controller.selectedIndex.value](), 
        bottomNavigationBar: BottomNavBar(
          onTap: (index) {
            controller.selectedIndex.value = index;
          },
        ),
      ),
    );
  }
}

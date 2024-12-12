import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mybalance/app/utils/color.dart';

final List<Map<String, dynamic>> menuItems = [
  {
    'icon': Icons.lock_reset,
    'iconColor': Colors.blue,
    'title': 'Forgot Password',
    'subtitle': 'Reset your account password',
    'route': '/forgot-password',
  },
  {
    'icon': BoxIcons.bxs_log_out_circle,
    'iconColor': Colors.red,
    'title': 'Logout',
    'subtitle': 'Sign out from your account',
    'route': '/login',
  },
  {
    'icon': BoxIcons.bxs_info_circle,
    'iconColor': Colors.amber,
    'title': 'About App',
    'subtitle': 'Details about MyBalance',
    'route': '/about',
  },
];
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            backgroundColor: AppColors.secondary,
            flexibleSpace: const SafeArea(
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Profile',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  )),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.blue,
                              width: 1,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/icons/Mybe.png',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              textAlign: TextAlign.start,
                              'Ariel Zakly Pratama',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                            Text(
                              textAlign: TextAlign.start,
                              'arielpratama9182@gmail.com',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ]),
                      const Icon(
                        BoxIcons.bxs_pencil,
                        color: Colors.white,
                      )
                    ],
                  )),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: menuItems.map((item) {
                    return ListTile(
                      leading: Icon(item['icon'],
                          color: item['iconColor'], size: 30),
                      title: Text(
                        item['title'],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        item['subtitle'],
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                      onTap: () {
                        Get.toNamed(item['route']);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ));
  }
}

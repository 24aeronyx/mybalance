import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mybalance/app/utils/color.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: AppBar(
            backgroundColor: Colors.white,
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
          padding: const EdgeInsets.all(20),
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
                        Clarity.pencil_line,
                        color: Colors.white,
                      )
                    ],
                  )),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.lock_reset, color: Colors.blue),
                title: const Text(
                  'Forgot Password',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Reset your account password',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                ),
                onTap: () {
                  // Aksi ketika item di-tap
                  Get.toNamed('/forgot-password'); // Contoh navigasi
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Sign out from your account',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                ),
                onTap: () {
                  // Aksi ketika item di-tap
                  Get.toNamed('/login');
                },
              ),
            ],
          ),
        ));
  }
}
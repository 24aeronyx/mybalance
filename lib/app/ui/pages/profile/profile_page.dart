import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mybalance/app/ui/pages/profile/profile_controller.dart';
import 'package:mybalance/app/utils/color.dart';
import 'package:mybalance/app/utils/text.dart';

final List<Map<String, dynamic>> menuItems = [
  {
    'icon': BoxIcons.bxs_log_out_circle,
    'iconColor': Colors.red,
    'title': 'Logout',
    'subtitle': 'Sign out from your account',
    'route': '/login',
    'onTap': (ProfileController controller) {
      controller.logout();
    },
  },
  {
    'icon': BoxIcons.bxs_info_circle,
    'iconColor': Colors.amber,
    'title': 'About App',
    'subtitle': 'Details about MyBalance',
    'route': '/about',
  },
];

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchProfile();
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
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary),
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
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() => Text(
                                  controller.fullName.value,
                                  style: const TextStyle(
                                    fontSize: FontSize.extraLarge,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                )),
                            const SizedBox(height: 4),
                            Obx(() => Text(
                                  controller.dateOfBirth.value,
                                  style: const TextStyle(
                                    fontSize: FontSize.large,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Get.toNamed(
                            '/edit-profile'); // Navigate to the edit profile page
                      },
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
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
                        if (item.containsKey('onTap')) {
                          item['onTap'](controller);
                        } else if (item.containsKey('route')) {
                          Get.toNamed(item['route']);
                        }
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

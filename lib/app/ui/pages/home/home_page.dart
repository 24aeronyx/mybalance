import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mybalance/app/ui/components/transaction/transaction_page.dart';
import 'package:mybalance/app/ui/pages/home/home_controller.dart';
import 'package:mybalance/app/utils/color.dart';
import 'package:mybalance/app/utils/text.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.reset();
    controller.fetchData();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: AppColors.secondary,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/icons/Mybe.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'MyBalance',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: FontSize.extraLarge, color: AppColors.primary),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          // Tampilkan indikator loading
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (controller.dataNotFound.value) {
          // Tampilkan pesan error jika data tidak ditemukan
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Data not found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Get.offAllNamed('/login'); // Direct ke halaman login
                  },
                  child: const Text('Go to Login'),
                ),
              ],
            ),
          );
        } else {
          // Tampilkan konten utama jika data berhasil dimuat
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              // Use ListView for scrolling content
              children: [
                // Header
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return Text(
                            'Hello ${controller.fullName.value.isNotEmpty ? controller.fullName.value : 'User'},',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          );
                        }),
                        const Text(
                          'Your available balance',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Color.fromRGBO(0, 0, 0, 0.5)),
                        ),
                      ],
                    ),
                    Obx(() {
                      return Text(
                        controller.balance.value.isNotEmpty
                            ? controller.balance.value
                            : '-',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      );
                    }),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/income'); // Navigate to /income route
                          },
                          child: const Column(
                            children: [
                              Icon(
                                FontAwesome.sack_dollar_solid,
                                color: Colors.white,
                                size: 40,
                              ),
                              SizedBox(height: 10),
                              Text('Add Income',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: FontSize.large)),
                            ],
                          ),
                        ),
                        Container(
                          height: 60,
                          width: 1,
                          color: AppColors.secondary,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/outcome'); // Navigate to /outcome route
                          },
                          child: const Column(
                            children: [
                              Icon(
                                FontAwesome.sack_xmark_solid,
                                color: Colors.white,
                                size: 40,
                              ),
                              SizedBox(height: 10),
                              Text('Add Outcome',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: FontSize.large)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Latest Transaction Section
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Latest Transaction',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 10),
                Obx(() {
                  return TransactionList(
                    // ignore: invalid_use_of_protected_member
                    transactions: controller.latestTransactionList.value,
                  );
                }),
              ],
            ),
          );
        }
      }),
    );
  }
}

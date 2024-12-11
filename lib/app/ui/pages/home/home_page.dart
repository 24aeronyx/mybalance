import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mybalance/app/ui/components/transaction/transaction_page.dart';
import 'package:mybalance/app/ui/pages/home/home_controller.dart';
import 'package:mybalance/app/utils/color.dart';

class HomePage extends GetView<HomeController> {

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchProfile();
    controller.fetchLatestTransactions();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: AppBar(
          backgroundColor: AppColors.secondary, // Pasti
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/icons/Mybe.png',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: const Color.fromRGBO(0, 0, 0, 0.3)),
                    ),
                    child: const Icon(BoxIcons.bx_cog,
                        size: 30, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Flex(
            direction: Axis.vertical,
            children: [
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gunakan Obx di sini
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
                      'Rp. ${controller.balance.value.isNotEmpty ? controller.balance.value : '-'}',
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
                      const Column(
                        children: [
                          Icon(
                            FontAwesome.sack_dollar_solid,
                            color: Colors.white,
                            size: 40,
                          ),
                          SizedBox(height: 10),
                          Text('Add Income',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      Container(
                        height: 60,
                        width: 1,
                        color: AppColors.secondary,
                      ),
                      const Column(
                        children: [
                          Icon(
                            FontAwesome.sack_xmark_solid,
                            color: Colors.white,
                            size: 40,
                          ),
                          SizedBox(height: 10),
                          Text('Add Outcome',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Latest Transaction',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 10),
                    Obx(() {
                      return TransactionList(
                        transactions: controller.latestTransactionList.value,
                      );
                    })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

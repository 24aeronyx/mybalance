import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mybalance/app/ui/components/transaction/transaction_page.dart';
import 'package:mybalance/app/ui/pages/history/history_controller.dart';
import 'package:mybalance/app/utils/color.dart';

class HistoryPage extends GetView<HistoryController> {
  const HistoryPage({super.key});

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
                  'History',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ),
        body: Center(
          child: Row(
            children: [
              Obx(() {
                return TransactionList(
                  transactions: controller.latestTransactionList.value,
                );
              })
            ],
          ),
        ));
  }
}

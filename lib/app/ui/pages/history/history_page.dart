import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mybalance/app/models/transaction_model.dart';
import 'package:mybalance/app/ui/components/transaction/transaction_page.dart';
import 'package:mybalance/app/ui/pages/history/history_controller.dart';
import 'package:mybalance/app/utils/color.dart';
import 'package:intl/intl.dart'; // Import the intl package

class HistoryPage extends GetView<HistoryController> {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.reset();
    controller.fetchLatestTransactions();
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
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          // Show loading indicator while data is being fetched
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.dataNotFound.value) {
          // Show message when no data is found
          return const Center(
            child: Text(
              'No transactions found.',
              style: TextStyle(fontSize: 16, color: AppColors.primary),
            ),
          );
        }

        // Content when data is available
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Filter by date
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Search by Title',
                            border: InputBorder.none, // Remove default border
                          ),
                          onChanged: (value) {
                            controller.searchTitle.value = value;
                            controller.groupTransactionsByDate();
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(BoxIcons.bx_calendar,
                            size: 30, color: AppColors.primary),
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            controller.selectedDate.value = pickedDate;
                            controller.groupTransactionsByDate();
                          }
                        },
                      ),
                      // Show Clear button only if a filter is active
                      Obx(() {
                        bool isFilterActive =
                            controller.searchTitle.value.isNotEmpty ||
                                controller.selectedDate.value != null;
                        return isFilterActive
                            ? IconButton(
                                icon: const Icon(Icons.refresh,
                                    size: 30, color: AppColors.primary),
                                onPressed: () {
                                  // Clear both search and selected date filters
                                  controller.searchTitle.value = '';
                                  controller.selectedDate.value = null;
                                  controller.groupTransactionsByDate();
                                },
                              )
                            : const SizedBox
                                .shrink(); // Hide button when no filter is applied
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Display transactions
                Obx(() {
                  // ignore: invalid_use_of_protected_member
                  var groupedTransactions = controller.groupedTransactions.value;

                  if (groupedTransactions.isEmpty) {
                    return const Center(child: Text('No transactions found.'));
                  }

                  return Column(
                    children: groupedTransactions.keys.map((date) {
                      List<Transaction> transactions =
                          groupedTransactions[date] ?? [];

                      // Skip empty date groups
                      if (transactions.isEmpty) {
                        return const SizedBox(); // Skip empty date groups
                      }

                      DateTime parsedDate = DateTime.parse(date);
                      String formattedDate =
                          DateFormat('EEEE, dd MMM yyyy').format(parsedDate);

                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom: 10), // Add space between date sections
                        child: SizedBox(
                          width: double
                              .infinity, // Ensure full width within the padding
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  children: [
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary),
                                    ),
                                    const SizedBox(
                                        width:
                                            8), // Space between text and line
                                    Expanded(
                                      child: Container(
                                        height: 1,
                                        color: AppColors
                                            .primary, // Color of the separator line
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: TransactionList(
                                  transactions: transactions,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
          ),
        );
      }),
    );
  }
}

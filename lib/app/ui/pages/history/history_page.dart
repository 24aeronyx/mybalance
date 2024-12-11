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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        // Wrap the body with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Filter by date
            
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search by Title',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    controller.searchTitle.value = value;
                    controller.groupTransactionsByDate();
                  },
                ),
             

              // Spacer to push the filter button to the right
              const SizedBox(width: 10),

              // Filter by Date Button with logo on the right
              Row(children: [
                IconButton(
                  icon: const Icon(BoxIcons.bx_calendar, size: 24),
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
                // Optionally you can add an image logo or other widget here
              ]),

              // Display transactions
              Obx(() {
                var groupedTransactions =
                    // ignore: invalid_use_of_protected_member
                    controller.groupedTransactions.value;

                if (groupedTransactions.isEmpty) {
                  return const Center(child: Text('No transactions found.'));
                }

                return Column(
                  children: groupedTransactions.keys.map((date) {
                    // Ensure that the transactions list is never null
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
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                formattedDate,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            // Directly place TransactionList inside the Column
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
              })
            ],
          ),
        ),
      ),
    );
  }
}

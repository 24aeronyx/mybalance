import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mybalance/app/models/transaction_model.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mybalance/app/utils/color.dart';
import 'package:mybalance/app/utils/text.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionList({super.key, required this.transactions});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo/Icon and Text
                  Row(
                    children: [
                      // Transaction Icon
                      CircleAvatar(
                        backgroundColor: const Color.fromARGB(255, 214, 232, 255),
                        radius: 20,
                        child: Icon(
                          transaction.transactionType == 'Groceries'
                              ? FontAwesome.cart_shopping_solid
                              : FontAwesome.wallet_solid,
                          size: 20,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Title and Date
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('MMM d, yyyy • h:mm a').format(transaction.date),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Amount
                  Text(
                    '${transaction.category == 'Income' ? '+' : '-'} Rp. ${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: FontSize.large,
                      fontWeight: FontWeight.w600,
                      color: transaction.category == 'Income'
                          ? AppColors.income
                          : AppColors.outcome,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

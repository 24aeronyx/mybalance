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
    return Column(
      children: List.generate(transactions.length, (index) {
        final transaction = transactions[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
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
                    // Transaction Icon based on category (Income/Outcome)
                    CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 214, 232, 255),
                      radius: 20,
                      child: Icon(
                        _getTransactionIcon(transaction),
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
                            fontWeight: FontWeight.w400,
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
                // Amount with Indonesian currency format
                Text(
                  '${transaction.type == 'income' ? '+' : '-'} ${_formatCurrency(transaction.amount)}',
                  style: TextStyle(
                    fontSize: FontSize.large,
                    fontWeight: FontWeight.w400,
                    color: transaction.type == 'income'
                        ? AppColors.income
                        : AppColors.outcome,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // Function to get the appropriate icon for the transaction type and category
  IconData _getTransactionIcon(Transaction transaction) {
    if (transaction.type == 'income') {
      // Return income icon based on category
      switch (transaction.category) {
        case 'Salary':
          return FontAwesome.money_bill_1_solid;
        case 'Investment':
          return FontAwesome.chart_line_solid;
        case 'Gift':
          return FontAwesome.gift_solid;
        default:
          return FontAwesome.gift_solid;
      }
    } else {
      // Return outcome icon based on category
      switch (transaction.category) {
        case 'Food':
          return FontAwesome.bowl_rice_solid;
        case 'Transportation':
          return FontAwesome.car_solid;
        case 'Entertainment':
          return FontAwesome.film_solid;
        case 'Utilities':
          return FontAwesome.wrench_solid;
        default:
          return FontAwesome.wrench_solid; // Default outcome icon
      }
    }
  }

  // Format the amount in Indonesian currency format
  String _formatCurrency(double amount) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID', // Indonesian locale
      symbol: 'Rp', // Currency symbol
      decimalDigits: 2, // Number of decimal digits
    );
    return formatCurrency.format(amount);
  }
}

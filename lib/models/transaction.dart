import 'package:flutter/material.dart';

class Transaction {
  final String title;
  final double amount;
  final bool isExpense;
  final IconData icon;
  final DateTime date;

  Transaction({
    required this.title,
    required this.amount,
    required this.isExpense,
    required this.icon,
    required this.date,
  });
}

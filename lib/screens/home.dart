import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../widgets/balance_section.dart';
import '../widgets/shortcut_buttons.dart';
import '../widgets/latest_transactions_section.dart';
import '../widgets/transaction_list.dart';
import '../screens/add_expense.dart';
import '../screens/add_income.dart';

class HomeScreen extends StatefulWidget {
  final Function navigateToHistory; // Callback function for navigation

  HomeScreen({Key? key, required this.navigateToHistory}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Sample transactions
  final List<Transaction> transactions = [
    Transaction(
      title: 'Salary',
      amount: 1000000.0,
      isExpense: false,
      icon: Icons.monetization_on,
      date: DateTime.now(),
    ),
    Transaction(
      title: 'Groceries',
      amount: 200.0,
      isExpense: true,
      icon: Icons.shopping_cart,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Transaction(
      title: 'Utilities',
      amount: 150.0,
      isExpense: true,
      icon: Icons.bolt,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Transaction(
      title: 'Freelance Work',
      amount: 300.0,
      isExpense: false,
      icon: Icons.work,
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Transaction(
      title: 'Freelance Work',
      amount: 300.0,
      isExpense: false,
      icon: Icons.work,
      date: DateTime.now().subtract(const Duration(days: 4)),
    ),
  ];

  double get totalBalance {
    double totalIncome = transactions
        .where((transaction) => !transaction.isExpense)
        .fold(0, (sum, transaction) => sum + transaction.amount);
    double totalExpense = transactions
        .where((transaction) => transaction.isExpense)
        .fold(0, (sum, transaction) => sum + transaction.amount);
    return totalIncome - totalExpense;
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  void _addIncome() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddIncomeScreen(
          onAddIncome: (Transaction income) {
            setState(() {
              transactions.add(income); // Add new income to the list
            });
          },
        ),
      ),
    );
  }

  void _addExpense() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpenseScreen(
          onAddExpense: (Transaction expense) {
            setState(() {
              transactions.add(expense); // Add new expense to the list
            });
          },
        ),
      ),
    );
  }

  void _viewMoreTransactions() {
    widget.navigateToHistory(); // Call the callback function to navigate
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color of the screen
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 74, 173, 1),
        elevation: 0,
        title: Row(
          children: [
            Image.network(
              'https://i.imgur.com/Ddywgdr.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(width: 10),
            const Text(
              'MyBalance',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromRGBO(0, 74, 173, 1),
              ),
              child: const Text(
                'Ariel Zakly Pratama',
                style: TextStyle(
                  color: Color.fromRGBO(0, 74, 173, 1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Wrap the Column with SingleChildScrollView
        child: Column(
          children: [
            BalanceSection(
              totalBalance: totalBalance,
              formatCurrency: formatCurrency,
            ),
            ShortcutButtons(
              addIncome: _addIncome,
              addExpense: _addExpense,
            ),
            LatestTransactionsSection(
              viewMore: _viewMoreTransactions, // Pass the view more function
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TransactionList(
                transactions: transactions,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

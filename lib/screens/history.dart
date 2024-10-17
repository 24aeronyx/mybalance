import 'package:flutter/material.dart';
import '../widgets/transaction_list.dart';
import '../models/transaction.dart';
import '../screens/main_screen.dart'; // Make sure to import your HomeScreen

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTimeRange? _selectedDateRange;

  // Dummy data for testing (You can replace it with actual data)
  final List<Transaction> _transactions = [
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
    // Add more transactions as needed
  ];

  List<Transaction> get _filteredTransactions {
    if (_selectedDateRange == null) return _transactions;
    return _transactions.where((transaction) {
      return transaction.date.isAfter(_selectedDateRange!.start) &&
          transaction.date.isBefore(_selectedDateRange!.end);
    }).toList();
  }

  void _onDateFilterSelected(DateTimeRange? newRange) {
    setState(() {
      _selectedDateRange = newRange;
    });
  }

  // Function to show date filter dialog
  Future<void> _showDateFilterDialog() async {
    final today = DateTime.now();
    final lastWeek = today.subtract(const Duration(days: 7));
    final lastMonth = DateTime(today.year, today.month - 1, today.day);
    final lastYear = DateTime(today.year - 1, today.month, today.day);

    final selectedOption = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Filter Tanggal'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'today'),
              child: const Text('Hari Ini'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'week'),
              child: const Text('7 Hari Terakhir'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'month'),
              child: const Text('1 Bulan Terakhir'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'year'),
              child: const Text('1 Tahun Terakhir'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'custom'),
              child: const Text('Pilih Tanggal'),
            ),
          ],
        );
      },
    );

    if (selectedOption != null) {
      DateTimeRange? selectedRange;
      switch (selectedOption) {
        case 'today':
          selectedRange = DateTimeRange(start: today, end: today);
          break;
        case 'week':
          selectedRange = DateTimeRange(start: lastWeek, end: today);
          break;
        case 'month':
          selectedRange = DateTimeRange(start: lastMonth, end: today);
          break;
        case 'year':
          selectedRange = DateTimeRange(start: lastYear, end: today);
          break;
        case 'custom':
          selectedRange = await _selectCustomDate();
          break;
      }
      _onDateFilterSelected(selectedRange);
    }
  }

  // Function to select a custom date
  Future<DateTimeRange?> _selectCustomDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    // Return a DateTimeRange for the selected date
    if (pickedDate != null) {
      return DateTimeRange(start: pickedDate, end: pickedDate);
    }
    return null; // Return null if no date was picked
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'History',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(0, 74, 173, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Navigate to the HomeScreen when back is pressed
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt,
                color: Colors.white), // Changed icon
            onPressed: _showDateFilterDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _filteredTransactions.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons
                          .warning, // You can choose any icon that fits your style
                      color: Color.fromRGBO(0, 74, 173, 1),
                      size: 48,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Tidak ada transaksi ditemukan!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(0, 74, 173, 1),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Silakan coba filter dengan kriteria lain.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : TransactionList(transactions: _filteredTransactions),
      ),
    );
  }
}

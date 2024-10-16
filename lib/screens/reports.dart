import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/summary_card.dart';
import '../widgets/reports_chart.dart';
import '../screens/main_screen.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String selectedMonth = 'November';
  int selectedYear = DateTime.now().year;
  final List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  List<int> years = List.generate(5, (index) => DateTime.now().year - index);
  final ScrollController _scrollController = ScrollController();

  Map<String, List<double>> monthlyData = {
    'November': [3000000, 1500000, 1800000, 2200000],
    'December': [2500000, 2000000, 1500000, 2800000],
  };

  double totalIncome = 5440000.00;
  double totalExpense = 2209000.00;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedMonth();
    });
  }

  void _scrollToSelectedMonth() {
    int index = months.indexOf(selectedMonth);
    double position = index * 100.0;
    _scrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<double> weeklyData = monthlyData[selectedMonth] ?? [0, 0, 0, 0];

    DateTime startDate =
        DateTime(selectedYear, months.indexOf(selectedMonth) + 1, 1);
    DateTime endDate =
        DateTime(selectedYear, months.indexOf(selectedMonth) + 2, 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(0, 74, 173, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Income',
                    amount: totalIncome,
                    color: Colors.green,
                    isIncome: true,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: SummaryCard(
                    title: 'Expense',
                    amount: totalExpense,
                    color: Colors.red,
                    isIncome: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Year:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButton<int>(
              value: selectedYear,
              icon: const Icon(Icons.arrow_drop_down),
              isExpanded: true,
              items: years.map((int year) {
                return DropdownMenuItem<int>(
                  value: year,
                  child: Text(year.toString()),
                );
              }).toList(),
              onChanged: (int? newValue) {
                setState(() {
                  selectedYear = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Month:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              child: Row(
                children: months.map((String month) {
                  bool isSelected = month == selectedMonth;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedMonth = month;
                        _scrollToSelectedMonth();
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color.fromRGBO(0, 74, 173, 1) : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                        border: isSelected ? Border.all(color: Colors.blueAccent) : null,
                      ),
                      child: Text(
                        month,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Reports Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              'From ${DateFormat('MMM d, yyyy').format(startDate)} to ${DateFormat('MMM d, yyyy').format(endDate)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ReportsChart(weeklyData: weeklyData),
          ],
        ),
      ),
    );
  }
}

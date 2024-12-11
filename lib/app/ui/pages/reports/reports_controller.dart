import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mybalance/app/models/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportsController extends GetxController {
  var selectedMonth = DateTime.now().month.obs;
  var selectedYear = DateTime.now().year.obs;
  RxDouble totalIncome = 0.0.obs;
  RxDouble totalOutcome = 0.0.obs;
  RxList<double> weeklyIncomeData =
      List<double>.filled(4, 0.0, growable: false).obs;
  RxList<double> weeklyOutcomeData =
      List<double>.filled(4, 0.0, growable: false).obs;
  var monthlyGroupedData = <Map<String, dynamic>>[].obs;
  var groupedIncomeData = <Map<String, dynamic>>[].obs;
  var groupedOutcomeData = <Map<String, dynamic>>[].obs;
  var filteredTransactions = <Transaction>[].obs;
  RxList<Map<String, dynamic>> allTransactions = <Map<String, dynamic>>[].obs;
  var selectedType = 'income'.obs;
  RxString formattedIncome = ''.obs;
  RxString formattedOutcome = ''.obs;
  RxMap<String, List<double>> allTransactionsByTitle = RxMap({});

  final filters = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  final years = <int>[
    DateTime.now().year,
    DateTime.now().year - 1,
    DateTime.now().year - 2,
  ];

  @override
  void onInit() {
    super.onInit();
    fetchAllTransactions(selectedYear.value, selectedMonth.value);
  }

  void calculateTotals() {
    totalIncome.value = allTransactions
        .where((t) => t['type'] == 'income')
        .fold(0.0, (sum, t) => sum + t['amount']);

    totalOutcome.value = allTransactions
        .where((t) => t['type'] == 'outcome')
        .fold(0.0, (sum, t) => sum + t['amount']);
  }

  void groupDataByType() {
    groupedIncomeData.value = allTransactions
        .where((transaction) => transaction['type'] == 'income')
        .fold<Map<String, double>>({}, (map, transaction) {
          String title = transaction['title'];
          double amount = transaction['amount'];
          map[title] = (map[title] ?? 0) + amount;
          return map;
        })
        .entries
        .map((entry) => {'title': entry.key, 'amount': entry.value})
        .toList();

    groupedOutcomeData.value = allTransactions
        .where((transaction) => transaction['type'] == 'outcome')
        .fold<Map<String, double>>({}, (map, transaction) {
          String title = transaction['title'];
          double amount = transaction['amount'];
          map[title] = (map[title] ?? 0) + amount;
          return map;
        })
        .entries
        .map((entry) => {'title': entry.key, 'amount': entry.value})
        .toList();
  }

  void processWeeklyData() {
    // Reset data mingguan
    weeklyIncomeData.value = List<double>.filled(4, 0.0, growable: false);
    weeklyOutcomeData.value = List<double>.filled(4, 0.0, growable: false);

    for (var transaction in allTransactions) {
      // Parse tanggal transaksi untuk mendapatkan minggu
      DateTime date = DateTime.parse(transaction['transaction_date']);
      int weekIndex = (date.day - 1) ~/ 7; // Minggu ke-0, 1, 2, 3

      if (transaction['type'] == 'income') {
        weeklyIncomeData[weekIndex] += transaction['amount'];
      } else if (transaction['type'] == 'outcome') {
        weeklyOutcomeData[weekIndex] += transaction['amount'];
      }
    }
    // Update observables
    weeklyIncomeData.refresh();
    weeklyOutcomeData.refresh();
  }

  List<Color> generateBrightColors(int count) {
    return List<Color>.generate(count, (index) {
      double hue = (index * 360 / count) % 360; // Sebar warna dalam spektrum
      return HSVColor.fromAHSV(1, hue, 0.8, 0.9).toColor(); // Warna terang
    });
  }

  void groupMonthlyDataByTitle() {
    // Map untuk menyimpan hasil pengelompokan
    Map<String, double> groupedData = {};

    for (var transaction in allTransactions) {
      String title = transaction['title'];
      double amount = transaction['amount'];

      if (groupedData.containsKey(title)) {
        // Jika title sudah ada, tambahkan jumlahnya
        groupedData[title] = groupedData[title]! + amount;
      } else {
        // Jika belum, inisialisasi jumlahnya
        groupedData[title] = amount;
      }
    }

    // Ubah map menjadi list agar dapat digunakan di UI
    monthlyGroupedData.value = groupedData.entries
        .map((entry) => {'title': entry.key, 'amount': entry.value})
        .toList();
  }

  double getMaxY() {
    double maxIncome = weeklyIncomeData.isNotEmpty
        ? weeklyIncomeData.reduce((a, b) => a > b ? a : b)
        : 0.0;
    double maxOutcome = weeklyOutcomeData.isNotEmpty
        ? weeklyOutcomeData.reduce((a, b) => a > b ? a : b)
        : 0.0;
    double maxValue = maxIncome > maxOutcome ? maxIncome : maxOutcome;

    return maxValue + (maxValue * 0.1); // Tambahkan margin 10%
  }

  List<Map<String, dynamic>> filterTransactionsByType(String type) {
    return allTransactions.where((t) => t['type'] == type).toList();
  }

  void updateFormattedValues(String income, String outcome) {
    formattedIncome.value = income;
    formattedOutcome.value = outcome;
  }

  void updateMonth(String selectedFilter) {
    final monthNames = {
      'January': 1,
      'February': 2,
      'March': 3,
      'April': 4,
      'May': 5,
      'June': 6,
      'July': 7,
      'August': 8,
      'September': 9,
      'October': 10,
      'November': 11,
      'December': 12
    };

    selectedMonth.value = monthNames[selectedFilter] ?? DateTime.now().month;
    fetchFilteredData();
  }

  void updateYear(int selectedYearValue) {
    selectedYear.value = selectedYearValue;
    fetchFilteredData();
  }

  void toggleTransactionType(String type) {
    selectedType.value = type;
  }

  Future<void> fetchFilteredData() async {
    fetchAllTransactions(selectedYear.value, selectedMonth.value);
  }

  Future<void> fetchAllTransactions(int year, int month) async {
    final url = Uri.parse(
        'http://10.0.2.2:3005/transaction/monthly-report?year=$year&month=$month');

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        Get.snackbar('Error', 'Token tidak ditemukan. Silakan login kembali.');
        return;
      }

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final transactions = data['transactions'] as List;

        // Simpan semua transaksi dalam allTransactions
        allTransactions.value = transactions
            .map((t) => {
                  'title': t['title'],
                  'type': t['type'],
                  'amount':
                      t['amount'] is int ? t['amount'].toDouble() : t['amount'],
                  'transaction_date': t['transaction_date'],
                  'description': t['description'],
                  'category': t['category'],
                })
            .toList();

        calculateTotals();
        processWeeklyData();
        groupMonthlyDataByTitle();
        groupDataByType();
      } else {
        throw Exception('Failed to load monthly report');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan saat mengambil data: $e');
    }
  }
}

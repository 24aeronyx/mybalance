import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mybalance/app/models/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportsController extends GetxController {
  var selectedMonth = DateTime.now().month.obs;
  var selectedYear = DateTime.now().year.obs;
  var totalIncome = 0.0.obs;
  var totalOutcome = 0.0.obs;
  var weeklyIncomeData = <double>[].obs;
  var weeklyOutcomeData = <double>[].obs;
  var allIncomeData = <double>[].obs;
  var allOutcomeData = <double>[].obs;
  var filteredTransactions = <Transaction>[].obs;
  var allTransactions = <Transaction>[].obs;
  var selectedType = 'income'.obs;

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
    fetchFilteredDataByType();
  }

  void updateYear(int selectedYearValue) {
    selectedYear.value = selectedYearValue;
    fetchFilteredData();
    fetchFilteredDataByType();
  }

  void toggleTransactionType(String type) {
    selectedType.value = type;
    // Panggil fungsi untuk mengambil data berdasarkan tipe
    fetchFilteredDataByType();
  }

  Future <void> fetchFilteredDataByType()async{
    fetchTransactionsByType(selectedYear.value, selectedMonth.value,selectedType.value);
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
        final incomeTransactions =
            transactions.where((t) => t['type'] == 'income').toList();
        final outcomeTransactions =
            transactions.where((t) => t['type'] == 'outcome').toList();

        allIncomeData.value = incomeTransactions.map((t) {
          var amount = t['amount'];
          if (amount is int) {
            return amount.toDouble();
          } else if (amount is double) {
            return amount;
          } else {
            return 0.0;
          }
        }).toList();

        allOutcomeData.value = outcomeTransactions.map((t) {
          var amount = t['amount'];
          if (amount is int) {
            return amount.toDouble();
          } else if (amount is double) {
            return amount;
          } else {
            return 0.0;
          }
        }).toList();

        totalIncome.value = allIncomeData.fold(0.0, (sum, t) => sum + t);
        totalOutcome.value = allOutcomeData.fold(0.0, (sum, t) => sum + t);

        List<double> incomeWeekly = List.filled(4, 0.0);
        List<double> outcomeWeekly = List.filled(4, 0.0);

        for (var t in incomeTransactions) {
          final date = DateTime.parse(t['transaction_date']);
          final weekIndex = (date.day ~/ 7);
          incomeWeekly[weekIndex] += t['amount'].toDouble();
        }

        for (var t in outcomeTransactions) {
          final date = DateTime.parse(t['transaction_date']);
          final weekIndex = (date.day ~/ 7);
          outcomeWeekly[weekIndex] += t['amount'].toDouble();
        }

        weeklyIncomeData.value = incomeWeekly;
        weeklyOutcomeData.value = outcomeWeekly;
      } else {
        throw Exception('Failed to load monthly report');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan saat mengambil data: $e');
    }
  }

  Future<void> fetchTransactionsByType(int year, int month, String type) async {
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

        // Filter transactions based on the provided type
        final filteredTransactions =
            transactions.where((t) => t['type'] == type).toList();

        // Set the filtered data to respective variables
        if (type == 'income') {
          allIncomeData.value = filteredTransactions.map((t) {
            var amount = t['amount'];
            return amount is int
                ? amount.toDouble()
                : amount is double
                    ? amount
                    : 0.0;
          }).toList();
        } else if (type == 'outcome') {
          allOutcomeData.value = filteredTransactions.map((t) {
            var amount = t['amount'];
            return amount is int
                ? amount.toDouble()
                : amount is double
                    ? amount
                    : 0.0;
          }).toList();
        }

      } else {
        throw Exception('Failed to load monthly report');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan saat mengambil data: $e');
    }
  }
}

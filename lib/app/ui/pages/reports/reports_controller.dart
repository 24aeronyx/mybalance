import 'package:get/get.dart';

class ReportsController extends GetxController {
  final RxString selectedFilter = 'Weekly'.obs; // Pastikan ada nilai awal
  final List<String> filters = ['Weekly', 'Monthly', 'Yearly'];

  void updateFilter(String newFilter) {
    selectedFilter.value = newFilter;
  }
}
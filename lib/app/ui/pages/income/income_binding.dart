import 'package:get/get.dart';
import 'package:mybalance/app/ui/pages/income/income_controller.dart';

class IncomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IncomeController());
  }
}

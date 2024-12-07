import 'package:get/get.dart';
import 'package:mybalance/app/ui/pages/reports/reports_controller.dart';

class ReportsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReportsController());
  }
}

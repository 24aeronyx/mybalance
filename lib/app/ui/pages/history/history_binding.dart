import 'package:get/get.dart';
import 'package:mybalance/app/ui/pages/history/history_controller.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HistoryController());
  }
}

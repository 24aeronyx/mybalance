import 'package:get/get.dart';
import 'package:mybalance/app/ui/pages/outcome/outcome_controller.dart';

class OutcomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OutcomeController());
  }
}

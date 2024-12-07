import 'package:get/get.dart';
import 'package:mybalance/app/ui/components/bottom_nav/bottom_nav_controller.dart';

class BottomNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BottomNavController());
  }
}

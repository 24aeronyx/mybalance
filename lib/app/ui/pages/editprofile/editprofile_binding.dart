import 'package:get/get.dart';
import 'package:mybalance/app/ui/pages/editprofile/editprofile_controller.dart';

class EditprofileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditProfileController());
  }
}

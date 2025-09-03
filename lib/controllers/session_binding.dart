import 'package:get/get.dart';
import 'package:presence_app/controllers/session_controller.dart';

class SessionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SessionController>(() => SessionController());
  }
}

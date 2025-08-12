import 'package:get/get.dart';
import 'package:presence_app/controllers/scan_camera_controller.dart';

class ScanCameraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanCameraController>(() => ScanCameraController());
  }
}

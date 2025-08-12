import 'package:get/get.dart';
import 'package:presence_app/controllers/segment_controller.dart';

class SegmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SegmentController>(() => SegmentController());
  }
}

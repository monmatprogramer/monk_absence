import 'package:get/get.dart';
import 'package:logger/web.dart';

class SegmentController extends GetxController {
  var segmentIndex = 0.obs;
  var logger = Logger(printer: PrettyPrinter());
  void updateSegment(int index) {
    logger.d("index: $index");
    segmentIndex.value = index;
  }
}

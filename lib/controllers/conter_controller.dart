
import 'package:get/get.dart';

class CounterController {
  var count = 0.obs;
  void increment() {
    count++;
  }
}
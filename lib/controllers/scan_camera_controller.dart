import 'package:get/get.dart';

class ScanCameraController extends GetxController{
  var isScannedCompleted = false.obs;

  void updateIsScannedCompleted(bool value) => isScannedCompleted.value = value;
}
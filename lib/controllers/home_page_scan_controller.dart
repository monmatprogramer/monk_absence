import 'package:get/get.dart';

class HomePageScanController extends GetxController {
  var isPressedCam = false.obs;
  var isPressedGal = false.obs;
  var isPressedQR = false.obs;
  void updateCam() {
    isPressedCam.value = !isPressedCam.value;
    isPressedGal.value = false;
    isPressedQR.value = false;
  }

  void updateGal() {
    isPressedGal.value = !isPressedGal.value;
    isPressedCam.value = false;
    isPressedQR.value = false;
  }

  void updateQR(){
    isPressedQR.value = !isPressedQR.value;
    isPressedCam.value = false;
    isPressedGal.value = false;
  }
}

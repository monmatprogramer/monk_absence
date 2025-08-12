import 'package:get/get.dart';

class AbsenceListController extends GetxController {
  var index = 0.obs;
  var isSelected = false.obs;
  bool tempIsSelected = false;
  void updateIndex(int newIndex) {
    tempIsSelected = isSelected.value;
    index.value = newIndex;
    isSelected.value = !tempIsSelected;
  }

  void updateIsSelected(bool isNewSelected) => isSelected.value = isNewSelected;
}

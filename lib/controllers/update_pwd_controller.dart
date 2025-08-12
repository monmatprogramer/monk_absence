import 'package:get/get.dart';

class UpdatePwdController extends GetxController {
  var oldPwd = ''.obs;
  var newPwd = ''.obs;

  //update old password state
  void updateOldPwd(String oldPassword) => oldPwd.value = oldPassword;
  //update new password state
  void updateNewPwd(String newPassword) => newPwd.value = newPassword;
  // clear password after do updating

  void clearPassword() {
    oldPwd.value = '';
    newPwd.value = '';
  }
}

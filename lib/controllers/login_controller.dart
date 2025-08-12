import 'package:get/get.dart';

class LoginController extends GetxController{
  final username = ''.obs;
  final password = ''.obs;
  void updateUsername(String value) => username.value = value;
  void updatePassword(String value) => password.value = value;
}
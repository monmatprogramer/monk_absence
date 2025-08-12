import 'package:get/get.dart';

class AuthServiceGet extends GetxService {
  var isLoggedIn = false.obs;
  
  void login(){
    isLoggedIn.value = true;
  }

  void logout(){
    isLoggedIn.value = false;
  }
}

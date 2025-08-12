import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:presence_app/auth_service.dart';
import 'package:presence_app/db_config.dart';

class ProfileController extends GetxController {
  var isLoading = true.obs; //this observable variable
  var imagePath = 'images/profile.png'.obs;
  var name = "Guest".obs;
  var isProfileImageChanged = false.obs;
  final RxnString imageUrl = RxnString();
  final Rxn<File> image = Rxn<File>();
  final authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    _loadingProfile();
  }

  Future<void> _loadingProfile() async {
    await authService.getProfile();
    isLoading.value = false;
    if (authService.wholeData['profileImage'] != null) {
      imageUrl.value =
          '${DbConfig.apiUrl}${authService.wholeData['profileImage']}';
    }
  }

  void updateIsLoading(bool value) => isLoading.value = value;
  void updateImagePath(String value) => imagePath.value = value;
  Future<void> updateImageUrl(String newUrl) async {
    final oldUrl = imageUrl.value;
    if (oldUrl != null) {
      await DefaultCacheManager().removeFile(oldUrl);
    }
    imageUrl.value = newUrl;
    isProfileImageChanged.value = true;
  }

  void updateName(String newName) => name.value = newName;
  void updateImage(String imageUrl) => updateImageUrl(imageUrl);
  void handleSelectedImage(File value) => image.value = value;
}

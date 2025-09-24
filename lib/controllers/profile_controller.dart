import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:presence_app/pages/loading_states.dart';
import 'package:presence_app/services/auth_service.dart';
import 'package:presence_app/db_config.dart';

class ProfileController extends GetxController {
  final authService = Get.find<AuthService>();
  final Logger _logger = Logger(
    printer: PrettyPrinter(),
  );

  final profileResponse = Rx<ApiResponse<Map<String, dynamic>>>(
    ApiResponse.initial(),
  );

  var isLoading = true.obs; //this observable variable
  var imagePath = 'images/profile.png'.obs;

  var isProfileImageChanged = false.obs;
  final Rxn<File> image = Rxn<File>();

  String get name => profileResponse.value.data?['name'] ?? 'Guest';
  // final RxnString imageUrl = RxnString();
  String? get imageUrl {
    final profileImage = profileResponse.value.data?['profileImage'];
    if (profileImage != null) {
      return '${DbConfig.apiUrl}$profileImage';
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    _loadingProfile();
  }

  Future<void> _loadingProfile() async {
    profileResponse.value = ApiResponse.loading();// LoadingStates.loading
    try {
      final data = await authService.getProfile();
      profileResponse.value = ApiResponse.success(data);
    } catch (e) {
      profileResponse.value = ApiResponse.error(e.toString());
    }
  }

  Future<void> updateImageUrl(String newImagePath) async {
    final oldUrl = imageUrl;
    if (oldUrl != null) {
      await DefaultCacheManager().removeFile(oldUrl);
    }

    if (profileResponse.value.isSucess) {
      final currentData = profileResponse.value.data!;
      final updatedData = Map<String, dynamic>.from(currentData);
      updatedData['profileImage'] = newImagePath;
      profileResponse.value = ApiResponse.success(updatedData);
    }
    isProfileImageChanged.value = true;
  }

  void updatedName(String newName) {
    if (profileResponse.value.isSucess) {
      final currentData = profileResponse.value.data;
      final updatedData = Map<String, dynamic>.from(currentData!);
    }
  }

  void handleSeletedImage(File value) => image.value = value;
}

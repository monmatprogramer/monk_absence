import 'package:get/get.dart';
import 'package:presence_app/controllers/session_controller.dart';
import 'package:presence_app/repositories/session_repository.dart';
import 'package:presence_app/services/api_service.dart';

class SessionBinding extends Bindings {
  @override
  void dependencies() {
    // Register dependencies in order
    //1. Register API Service (lowest level)
    Get.lazyPut<ApiService>(() => ApiService());

    //2. Register Repository (depends on API Service)
    Get.lazyPut<SessionRepository>(() => SessionRepository());
    //3. Register Controller (depends on Repository)
    Get.lazyPut<SessionController>(() => SessionController());
  }
}

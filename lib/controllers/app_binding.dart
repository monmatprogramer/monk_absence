import 'package:get/get.dart';
import 'package:presence_app/conponent/asset_precache_service.dart';
import 'package:presence_app/controllers/absence_list_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AssetPrecacheService());
    Get.lazyPut(() => AbsenceListController());
  }
}

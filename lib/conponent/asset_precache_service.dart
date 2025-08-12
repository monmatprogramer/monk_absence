import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssetPrecacheService extends GetxService {
  final ready = false.obs;
  var _done = false;

  Future<void> warmUp(BuildContext? context) async {
    if (_done) return;
    _done = true;

    const assets = ['images/morning_cloud_sun.png'];

    for (final path in assets) {
      await precacheImage(AssetImage(path), context!);
    }

    ready.value = true;
  }
}

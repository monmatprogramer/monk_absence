import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ProfileAvartar extends StatelessWidget {
  final double size;
  final File? localImageFile;
  final String? networkImagUrl;
  final String dfaultAssetPath;
  ProfileAvartar({
    super.key,
    this.size = 80,
    this.localImageFile,
    this.networkImagUrl,
    this.dfaultAssetPath = 'images/monk_profile_mock.jpg',
  });
  var logger = Logger(printer: PrettyPrinter());

  @override
  Widget build(BuildContext context) {
    logger.d('''
      localImageFile: $localImageFile,
      networkImagUrl: $networkImagUrl,
      dfaultAssetPath: $dfaultAssetPath
    ''');
    if (localImageFile != null) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: FileImage(localImageFile!),
      );
    }
    if (networkImagUrl != null && networkImagUrl!.isNotEmpty) {
      logger.d("ProfileAvartar 👉 $networkImagUrl");
      return CircleAvatar(
        radius: size / 2,
        backgroundColor: Colors.grey.shade200,
        backgroundImage: CachedNetworkImageProvider(networkImagUrl!),
      );
    }
    return CircleAvatar(
      radius: size / 2,
      backgroundImage: AssetImage(dfaultAssetPath),
    );
  }
}

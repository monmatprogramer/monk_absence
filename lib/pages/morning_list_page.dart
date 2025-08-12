import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:presence_app/conponent/asset_precache_service.dart';
import 'package:presence_app/conponent/string_operation.dart';
import 'package:presence_app/controllers/absence_list_controller.dart';
import 'package:presence_app/pages/morning_absence_screen.dart';

class MorningListPage extends StatelessWidget {
  final String title;
  final String imageName;
  const MorningListPage({
    super.key,
    required this.title,
    required this.imageName,
  });

  @override
  Widget build(BuildContext context) {
    final svc = Get.find<AssetPrecacheService>();
    final controller = Get.find<AbsenceListController>();
    final double heightImage = 80.0;
    var logger = Logger(printer: PrettyPrinter());
    svc.warmUp(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5EDE4),
      body: SafeArea(
        child: Column(
          children: [
            //Header banner
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
                bottom: 0.0,
              ),
              child: Row(
                children: [
                  //Back button
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.arrow_back, size: 24),
                    tooltip: 'Back',
                    splashRadius: 24,
                    color: Theme.of(context).iconTheme.color,
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                  ),
                  //Space
                  const Spacer(),
                  Obx(
                    () => svc.ready.value
                        ? Image.asset(
                            'images/$imageName',
                            height: heightImage,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                            alignment: Alignment.center,
                            semanticLabel: 'Morning cloud sun',
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.broken_image,
                              size: heightImage,
                              color: Colors.grey,
                            ),
                            gaplessPlayback: true,
                            cacheHeight:
                                (40 *
                                MediaQuery.devicePixelRatioOf(context).round()),
                          )
                        : const CircularProgressIndicator(),
                  ),
                  const Spacer(),
                  Text(
                    '${capitalize(title)} absence',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            //Categoies
            Expanded(
              flex: 1,
              child: Obx(
                () => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  child: SegmentedButton<int>(
                    segments: const [
                      ButtonSegment(
                        value: 0,
                        label: Text('Presence'),
                        icon: Icon(Icons.airplane_ticket),
                      ),
                      ButtonSegment(
                        value: 1,
                        label: Text('Absence'),
                        icon: Icon(Icons.airplane_ticket),
                      ),
                    ],
                    selected: {controller.index.value},
                    onSelectionChanged: (newIndex) {
                      controller.updateIndex(newIndex.first);
                      logger.d(controller.isSelected.value.toString());
                    },
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 10,
              child: Obx(
                () => IndexedStack(
                  index: controller.index.value,
                  children: [
                    MorningAbsenceScreen(status: 'Presence'),
                    MorningAbsenceScreen(status: 'Absence'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

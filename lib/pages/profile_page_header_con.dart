import 'package:flutter/widgets.dart';
import 'package:presence_app/pages/profile_header_body.dart';
import 'package:presence_app/pages/profile_image_circle.dart';

class ProfilePageHeaderCon extends StatelessWidget {
  const ProfilePageHeaderCon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        // Expanded(child: SizedBox(width: 200, child: ProfileImageCircle())),
        ProfileImageCircle(),
        const SizedBox(height: 20),
        Flexible(
          child: SizedBox(
            width: double.infinity,
            height: 200,
            child: ProfileHeaderBody(),
          ),
        ),
      ],
    );
  }
}

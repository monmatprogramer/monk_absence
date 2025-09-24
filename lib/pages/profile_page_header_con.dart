import 'package:flutter/widgets.dart';
import 'package:presence_app/pages/profile_header_body.dart';
import 'package:presence_app/pages/profile_image_circle.dart';

class ProfilePageHeaderCon extends StatelessWidget {
  const ProfilePageHeaderCon({super.key});

  Widget myColum() {
    return Column(
      children: [
        const SizedBox(height: 20),
        ProfileImageCircle(),
        const SizedBox(height: 20),
        ProfileHeaderBody(),

      ],
    );
  }

  Widget _testWidget(){
    return Placeholder();
  }

  @override
  Widget build(BuildContext context) {
    return myColum();
  }
}

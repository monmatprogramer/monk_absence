import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/conponent/customer_divider.dart';
import 'package:presence_app/conponent/text_container.dart';

class ProfilePageBodyDetail extends StatefulWidget {
  const ProfilePageBodyDetail({super.key});

  @override
  State<ProfilePageBodyDetail> createState() => _ProfilePageBodyDetailState();
}

class _ProfilePageBodyDetailState extends State<ProfilePageBodyDetail> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.transparent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextContainer(title: "Edit Profile", icon: Icons.edit),
          CustomerDivider(),
          TextContainer(title: "Morning", icon: Icons.sunny),
          CustomerDivider(),
          TextContainer(title: "Afternoon", icon: Icons.night_shelter),
          CustomerDivider(),
          TextContainer(title: "Feedback", icon: Icons.feedback),
          CustomerDivider(),
          TextContainer(
            title: "Update password",
            icon: Icons.lock,
            onPressed: () => Get.toNamed("/update-password"),
          ),
        ],
      ),
    );
  }
}

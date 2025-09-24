import 'package:flutter/material.dart';
import 'package:presence_app/pages/profile_page_body_detail.dart';

class ProfilePageBodyCon extends StatelessWidget {
  const ProfilePageBodyCon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const ProfilePageBodyDetail(),
    );
  }
}

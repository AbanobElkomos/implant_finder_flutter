import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../core/constants/colors.dart';
import '../../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Profile'.text.make(),
        backgroundColor: MyAppColors.primaryColor,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.EDIT_PROFILE),
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return CircularProgressIndicator().centered();
        }

        if (controller.profile.value == null) {
          return "Could not load profile. Please try again.".text.makeCentered();
        }

        return VStack(
          [
            'Name: ${controller.profile.value!['name']}'.text.xl.make(),
            10.heightBox,
            'Phone: ${controller.profile.value!['phone']}'.text.xl.make(),
          ],
          crossAlignment: CrossAxisAlignment.start,
        ).p(16);
      }),
    );
  }
}

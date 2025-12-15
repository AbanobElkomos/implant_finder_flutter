import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../core/constants/colors.dart';

import '../controllers/profile_controller.dart';

class EditProfileView extends GetView<ProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Edit Profile'.text.make(),
        backgroundColor: MyAppColors.primaryColor,
      ),
      body: VStack([
        TextFormField(
          controller: controller.nameController,
          decoration: InputDecoration(
            labelText: 'Name',
            prefixIcon: Icon(Icons.person),
          ),
        ).pSymmetric(h: 16),
        16.heightBox,
        TextFormField(
          controller: controller.phoneController,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            prefixIcon: Icon(Icons.phone),
          ),
        ).pSymmetric(h: 16),
        16.heightBox,
        Obx(
          () => controller.isLoading.value
              ? CircularProgressIndicator().centered()
              : ElevatedButton(
                  onPressed: controller.updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyAppColors.primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: 'Update Profile'.text.make(),
                ).centered(),
        ),
      ], alignment: MainAxisAlignment.center).p(16),
    );
  }
}

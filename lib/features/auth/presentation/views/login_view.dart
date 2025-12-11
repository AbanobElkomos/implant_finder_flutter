import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_tailwind_ui/flutter_tailwind_ui.dart';

import '../../../../core/constants/colors.dart';
import '../../../../routes/app_pages.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.canvasColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: VStack(
            [
              Lottie.asset(
                'assets/lottie/login-animation.json',
                height: context.percentHeight * 30,
              ),
              "Welcome Back,".text.xl4.bold.make(),
              "Log in to continue".text.xl.make(),
              30.heightBox,
              TextFormField(
                controller: controller.emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ).pSymmetric(h: 16),
              16.heightBox,
              TextFormField(
                controller: controller.passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ).pSymmetric(h: 16),
              HStack(

                 [
                  Obx(
                    () => TCheckbox(
                      value: controller.rememberMe.value,
                      onChanged: (value) {
                        controller.rememberMe.value = value;
                      },
                    ),
                  ),
                  "  Remember me".text.make(),
                ],
              ).pSymmetric(h: 4),
              20.heightBox,
              Obx(
                () => controller.isLoading.value
                    ? CircularProgressIndicator().centered()
                    : ElevatedButton(
                        onPressed: controller.login,
                        child: "Login".text.white.make(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyAppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        ),
                      ).centered(),
              ),
              10.heightBox,
              TextButton(
                onPressed: () => Get.toNamed(Routes.SIGN_UP),
                child: "Don't have an account? Sign up".text.make(),
              ),
            ],
            alignment: MainAxisAlignment.center,
            crossAlignment: CrossAxisAlignment.center,
          ).p(16),
        ),
      ),
    );
  }
}

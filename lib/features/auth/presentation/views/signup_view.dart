import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../core/constants/colors.dart';
import '../controllers/auth_controller.dart';

class SignUpView extends GetView<AuthController> {
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
              "Create Account".text.xl4.bold.make(),
              "Sign up to get started".text.xl.make(),
              30.heightBox,
              TextFormField(
                controller: controller.nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ).pSymmetric(h: 16),
              16.heightBox,
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
                controller: controller.phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
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
              20.heightBox,
              Obx(
                () => PageTransitionSwitcher(
                  transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
                    return FadeScaleTransition(
                      animation: primaryAnimation,
                      child: child,
                    );
                  },
                  child: controller.isLoading.value
                      ? CircularProgressIndicator().centered()
                      : ElevatedButton(
                          onPressed: controller.signUp,
                          child: "Sign Up".text.white.make(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyAppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                          ),
                        ).centered(),
                ),
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

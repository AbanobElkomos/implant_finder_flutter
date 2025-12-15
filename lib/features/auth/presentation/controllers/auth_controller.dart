// lib/modules/auth/controllers/auth_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../routes/app_pages.dart';

class AuthController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  final GetStorage box = GetStorage();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  final isLoading = false.obs;
  final rememberMe = false.obs;
  final session = Rx<Session?>(null);

  StreamSubscription<AuthState>? _authSub;

  @override
  void onInit() {
    super.onInit();

    // Load existing session (SDK-persisted)
    session.value = supabase.auth.currentSession;

    // Listen to Supabase auth events (supabase_flutter 2.x)
    _authSub = supabase.auth.onAuthStateChange.listen((AuthState authState) {
      session.value = authState.session;

      if (authState.event == AuthChangeEvent.signedIn ||
          authState.event == AuthChangeEvent.tokenRefreshed) {
        // user now has a valid session → auto go home
        Get.offAllNamed(Routes.HOME);
      }

      if (authState.event == AuthChangeEvent.signedOut) {
        Get.offAllNamed(Routes.LOGIN);
      }
    });

    // Restore "remember me" preference (email-only) and auto-login if session exists
    _restorePreferencesAndAutoLogin();
  }

  Future<void> _restorePreferencesAndAutoLogin() async {
    rememberMe.value = box.read('remember_me') ?? false;

    if (rememberMe.value) {
      final storedEmail = box.read('email');
      if (storedEmail != null) {
        emailController.text = storedEmail;
      }
    }

    // If a session already exists, auto-navigate
    if (session.value != null) {
      await Future.delayed(Duration(milliseconds: 200));
      Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> signUp() async {
    isLoading.value = true;
    try {
      final response = await supabase.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = response.user;
      if (user != null) {
        await supabase.from('profiles').insert({
          'auth_id': user.id,
          'name': nameController.text.trim(),
          'phone': phoneController.text.trim(),
        });

        if (supabase.auth.currentSession != null) {
          Get.offAllNamed(Routes.HOME);
        } else {
          Get.snackbar("Success", "Check your email for verification.");
        }
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login() async {
    isLoading.value = true;
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        Get.snackbar("Error", "Email and password required");
        return;
      }

      // Store only email when rememberMe is ON (never store password)
      if (rememberMe.value) {
        await box.write('remember_me', true);
        await box.write('email', email);
      } else {
        await box.write('remember_me', false);
        await box.remove('email');
      }

      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session != null) {
        // navigation will also be triggered by the auth state listener,
        // but we can navigate immediately as well:
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.snackbar("Error", "Invalid login");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    _authSub?.cancel();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}

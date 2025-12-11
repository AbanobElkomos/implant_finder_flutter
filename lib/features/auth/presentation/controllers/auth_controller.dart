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
  final isInitialized = false.obs;

  StreamSubscription<AuthState>? _authSub;

  @override
  void onInit() {
    super.onInit();
    initializeAuth();
  }

  void initializeAuth() {
    if (isInitialized.value) return;

    // Load existing session
    session.value = supabase.auth.currentSession;

    // Listen to Supabase auth events
    _authSub = supabase.auth.onAuthStateChange.listen((AuthState authState) {
      session.value = authState.session;
      print('🔐 Auth state changed: ${authState.event}');

      // Handle auth events WITHOUT auto-navigation
      // Let the app handle navigation based on business logic
      if (authState.event == AuthChangeEvent.signedOut) {
        // Clear local data
        emailController.clear();
        passwordController.clear();
      }
    });

    _restorePreferences();
    isInitialized.value = true;
    print('✅ AuthController initialized');
  }

  Future<void> _restorePreferences() async {
    rememberMe.value = box.read('remember_me') ?? false;

    if (rememberMe.value) {
      final storedEmail = box.read('email');
      if (storedEmail != null) {
        emailController.text = storedEmail;
      }
    }

    // ⚠️ تمت إزالة auto-redirect
    // لا تحول تلقائياً إلى أي route هنا
    // دع main.dart أو routing system يتحكم في ذلك
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
          // Manual navigation بعد signup ناجح
          Get.offAllNamed(Routes.HOME);
        } else {
          Get.snackbar(
            "Success",
            "Check your email for verification.",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
        Get.snackbar(
          "Error",
          "Email and password required",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      // Store only email when rememberMe is ON
      if (rememberMe.value) {
        box.write('remember_me', true);
        box.write('email', email);
      } else {
        box.write('remember_me', false);
        box.remove('email');
      }

      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session != null) {
        // Manual navigation بعد login ناجح
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.snackbar(
          "Error",
          "Invalid login",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
      // Manual navigation بعد logout
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Check if user is authenticated
  bool get isAuthenticated => session.value != null;

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
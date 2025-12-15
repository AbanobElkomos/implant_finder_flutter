import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../routes/app_pages.dart';

class HomeController extends GetxController {
  // ✅ Constructor بسيط بدون parameters
  HomeController();

  // الحصول على Supabase instance داخل الكلاس
  SupabaseClient get supabase => Supabase.instance.client;

  final isLoading = false.obs;
  final vendorCount = 0.obs;
  final countryCount = 0.obs;
  final activeCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadStats();
  }

  Future<void> loadStats() async {
    isLoading.value = true;
    try {
      // TODO: Implement actual stats loading
      vendorCount.value = 12;
      countryCount.value = 8;
      activeCount.value = 10;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load stats: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign out: $e');
    }
  }
}
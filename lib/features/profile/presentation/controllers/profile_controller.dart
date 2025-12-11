import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  final user = Supabase.instance.client.auth.currentUser;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  final isLoading = false.obs;
  final profile = Rx<Map<String, dynamic>?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      if (user == null) {
        Get.snackbar('Error', 'You are not logged in.');
        return;
      }
      final response = await supabase
          .from('profiles')
          .select()
          .eq('auth_id', user!.id);

      if (response.isNotEmpty) {
        profile.value = response.first;
        nameController.text = profile.value?['name'] ?? '';
        phoneController.text = profile.value?['phone'] ?? '';
      } else {
        profile.value = null; // Explicitly set to null
      }
    } catch (e) {
      print(e.toString());
      Get.snackbar('Error', 'An error occurred while fetching your profile.');
      profile.value = null; // Ensure profile is null on error
    }
    isLoading.value = false;
  }

  Future<void> updateProfile() async {
    isLoading.value = true;
    try {
      if (user == null) {
        Get.snackbar('Error', 'You are not logged in.');
        return;
      }
      await supabase.from('profiles').update({
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
      }).eq('auth_id', user!.id);
      Get.snackbar('Success', 'Profile updated successfully');
      await fetchProfile(); // Refresh data on the profile page
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
    isLoading.value = false;
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}

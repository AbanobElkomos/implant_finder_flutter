import 'dart:io';
 import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/vendor_repository.dart';
import '../../domain/models/vendor.dart';

class VendorFormController extends GetxController {
  final VendorRepository repository;
  final SupabaseClient supabase;
  final ImagePicker _picker = ImagePicker();

  VendorFormController(this.repository, this.supabase);

  // ================= STATE =================
  final RxBool isLoading = false.obs;
  final RxBool isEditing = false.obs;
  final Rx<Vendor?> currentVendor = Rx<Vendor?>(null);
  final formKey = GlobalKey<FormState>();

  // Text controllers
  final nameController = TextEditingController();
  final countryController = TextEditingController();
  final emailController = TextEditingController();
  final websiteController = TextEditingController();
  final addressController = TextEditingController();
  final logoController = TextEditingController();
  final List<TextEditingController> phoneControllers = [TextEditingController()];

  // Store only File, convert to bytes when needed
  final Rx<File?> pickedLogo = Rx<File?>(null);

  // ================= PHONE FIELD MANAGEMENT =================

  void addPhoneField() {
    phoneControllers.add(TextEditingController());
    update();
  }

  void removePhoneField(int index) {
    if (phoneControllers.length > 1) {
      phoneControllers[index].dispose();
      phoneControllers.removeAt(index);
      update();
    }
  }

  void clearPhoneFields() {
    for (var controller in phoneControllers) {
      controller.dispose();
    }
    phoneControllers.clear();
    phoneControllers.add(TextEditingController());
    update();
  }

  // ================= LOGO PICKER =================

  Future<void> pickLogoFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image != null) {
        final file = File(image.path);
        pickedLogo.value = file;
        logoController.text = image.path; // Store local path
        update();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  // ================= SUPABASE LOGO UPLOAD =================

  Future<String?> uploadLogoToSupabase() async {
    // If no logo was picked, use existing URL
    if (pickedLogo.value == null) {
      final existingUrl = logoController.text.trim();
      return existingUrl.isEmpty ? null : existingUrl;
    }

    try {
      // Convert File to bytes for Supabase
      final bytes = await pickedLogo.value!.readAsBytes();
      final fileName = 'vendor_logo_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Upload to Supabase
      await supabase.storage
          .from('vendor-logos')
          .upload(fileName, bytes as File);

      // Get public URL
      final publicUrl = supabase.storage
          .from('vendor-logos')
          .getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      Get.snackbar('Warning', 'Failed to upload logo: $e');
      // Fallback to local path or existing URL
      return logoController.text.trim();
    }
  }

  // ================= LOAD VENDOR FOR EDITING =================

  Future<void> loadVendorForEditing(String vendorId) async {
    try {
      isLoading.value = true;
      isEditing.value = true;

      final vendor = await repository.getVendorById(vendorId);
      currentVendor.value = vendor;

      // Fill form fields
      nameController.text = vendor.name;
      countryController.text = vendor.organ ?? '';
      emailController.text = vendor.email ?? '';
      websiteController.text = vendor.website ?? '';
      addressController.text = vendor.address ?? '';
      logoController.text = vendor.logo ?? '';

      // Clear picked logo
      pickedLogo.value = null;

      // Fill phone numbers
      clearPhoneFields();
      for (var phone in vendor.phones) {
        phoneControllers.add(TextEditingController(text: phone));
      }
      if (phoneControllers.isEmpty) {
        phoneControllers.add(TextEditingController());
      }

      update();
        } catch (e) {
      Get.snackbar('Error', 'Failed to load vendor: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ================= RESET FORM =================

  void resetForm() {
    nameController.clear();
    countryController.clear();
    emailController.clear();
    websiteController.clear();
    addressController.clear();
    logoController.clear();
    clearPhoneFields();
    pickedLogo.value = null;
    isEditing.value = false;
    currentVendor.value = null;
    formKey.currentState?.reset();
  }

  // ================= SUBMIT FORM =================

  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      // Handle logo upload
      String? logoUrl;
      if (pickedLogo.value != null) {
        // Upload new logo
        logoUrl = await uploadLogoToSupabase();
      } else {
        // Use existing URL
        final existingUrl = logoController.text.trim();
        logoUrl = existingUrl.isEmpty ? null : existingUrl;
      }

      // Create vendor object
      final vendor = Vendor(
        id: isEditing.value ? currentVendor.value!.id : '',
        name: nameController.text.trim(),
        organ: countryController.text.trim(),
        email: emailController.text.trim().isEmpty ? null : emailController.text.trim(),
        website: websiteController.text.trim().isEmpty ? null : websiteController.text.trim(),
        address: addressController.text.trim().isEmpty ? null : addressController.text.trim(),
        logo: logoUrl,
        phones: phoneControllers
            .map((c) => c.text.trim())
            .where((phone) => phone.isNotEmpty)
            .toList(),
        createdAt: isEditing.value ? currentVendor.value!.createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save to repository
      if (isEditing.value) {
        await repository.updateVendor(vendor);
        Get.snackbar('Success', 'Vendor updated successfully');
      } else {
        await repository.createVendor(vendor);
        Get.snackbar('Success', 'Vendor created successfully');
      }

      resetForm();
      Get.back(result: true);
    } catch (e) {
      Get.snackbar('Error', 'Failed to save vendor: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ================= VALIDATION =================

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return null;
    if (!GetUtils.isEmail(value)) return 'Please enter a valid email';
    return null;
  }

  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // ================= DISPOSE =================

  @override
  void onClose() {
    nameController.dispose();
    countryController.dispose();
    emailController.dispose();
    websiteController.dispose();
    addressController.dispose();
    logoController.dispose();

    for (var controller in phoneControllers) {
      controller.dispose();
    }

    super.onClose();
  }
}
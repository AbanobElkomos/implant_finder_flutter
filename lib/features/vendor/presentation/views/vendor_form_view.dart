import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/models/vendor.dart';
import '../controllers/vendor_form_controller.dart';

class VendorFormView extends GetView<VendorFormController> {
  final Vendor? existingVendor;

  VendorFormView({this.existingVendor});

  @override
  Widget build(BuildContext context) {
    // Initialize form with existing data if editing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (existingVendor != null) {
        controller.initializeForm(existingVendor!);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(existingVendor == null ? 'Add New Vendor' : 'Edit Vendor'),
        backgroundColor: MyAppColors.primaryColor,
        actions: [
          if (existingVendor != null)
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteDialog(context),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information Section
              _buildSectionHeader('Basic Information'),
              16.heightBox,

              _buildTextFormField(
                controller: controller.nameController,
                label: 'Vendor Name *',
                hintText: 'Enter vendor name',
                icon: Icons.business,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vendor name is required';
                  }
                  return null;
                },
              ),
              12.heightBox,

              _buildTextFormField(
                controller: controller.countryController,
                label: 'Country *',
                hintText: 'e.g., Switzerland, USA',
                icon: Icons.flag,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Country is required';
                  }
                  return null;
                },
              ),
              12.heightBox,

              // Contact Information Section
              _buildSectionHeader('Contact Information'),
              16.heightBox,

              _buildTextFormField(
                controller: controller.emailController,
                label: 'Email',
                hintText: 'contact@vendor.com',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value != null && value.isNotEmpty && GetUtils.isEmail(value) ) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              12.heightBox,

              _buildTextFormField(
                controller: controller.websiteController,
                label: 'Website',
                hintText: 'https://www.vendor.com',
                icon: Icons.language,
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!value.startsWith('http://') && !value.startsWith('https://')) {
                      return 'Please enter a valid URL starting with http:// or https://';
                    }
                  }
                  return null;
                },
              ),
              12.heightBox,

              // Phone Numbers (Dynamic)
              _buildPhoneNumbersSection(),

              // Address Section
              _buildSectionHeader('Address'),
              16.heightBox,

              _buildTextFormField(
                controller: controller.addressController,
                label: 'Address',
                hintText: 'Full company address',
                icon: Icons.location_on,
                maxLines: 3,
              ),
              12.heightBox,

              // Logo URL Section
              _buildSectionHeader('Logo'),
              16.heightBox,

              _buildTextFormField(
                controller: controller.logoController,
                label: 'Logo URL',
                hintText: 'https://example.com/logo.png',
                icon: Icons.image,
                keyboardType: TextInputType.url,
              ),

              // Logo Preview
              Obx(() {
                if (controller.logoController.text.isNotEmpty) {
                  return Column(
                    children: [
                      12.heightBox,
                      'Logo Preview'.text.sm.gray500.make(),
                      8.heightBox,
                      Image.network(
                        controller.logoController.text,
                        height: 100,
                        width: 100,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
                          );
                        },
                      ).centered(),
                    ],
                  );
                }
                return SizedBox();
              }),

              40.heightBox,

              // Submit Button
              Obx(() {
                if (controller.isLoading.value) {
                  return CircularProgressIndicator().centered();
                }

                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyAppColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      existingVendor == null ? 'Add Vendor' : 'Update Vendor',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              }),

              20.heightBox,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: MyAppColors.primaryColor,
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    String? hintText,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: MyAppColors.primaryColor),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
    );
  }

  Widget _buildPhoneNumbersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        'Phone Numbers'.text.sm.gray500.make(),
        8.heightBox,
        Obx(() => Column(
          children: [
            ...controller.phoneControllers.asMap().entries.map((entry) {
              final index = entry.key;
              final phoneController = entry.value;

              return Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        hintText: 'Phone number ${index + 1}',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (index == 0 && (value == null || value.isEmpty)) {
                          return 'At least one phone number is required';
                        }
                        if (value != null && value.isNotEmpty && !value.isPhone) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                  if (controller.phoneControllers.length > 1)
                    IconButton(
                      icon: Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => controller.removePhoneField(index),
                    ),
                ],
              );
            }),

            8.heightBox,

            OutlinedButton.icon(
              onPressed: controller.addPhoneField,
              icon: Icon(Icons.add, size: 16),
              label: Text('Add Another Phone'),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: MyAppColors.primaryColor),
              ),
            ),
          ],
        )),
        16.heightBox,
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('Delete Vendor'),
        content: Text('Are you sure you want to delete this vendor? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteVendor();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
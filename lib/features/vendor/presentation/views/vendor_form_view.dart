import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_picker/country_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../core/constants/colors.dart';
import '../controllers/vendor_form_controller.dart';

class VendorFormView extends GetView<VendorFormController> {
  final String? vendorId;
  const VendorFormView({super.key, this.vendorId});

  @override
  Widget build(BuildContext context) {
    // Load vendor data if editing
    if (vendorId != null && vendorId!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.loadVendorForEditing(vendorId!);
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.isEditing.value ? 'Edit Vendor' : 'Add Vendor',
            style: GoogleFonts.lato(
              color: MyAppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: MyAppColors.primaryColor,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              MyAppColors.primaryColor.withValues(alpha:0.03),
              Colors.transparent,
            ],
            stops: const [0.0, 0.2],
          ),
        ),
        child: Form(
          key: controller.formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Header Section
              _buildHeaderSection(),
              24.heightBox,

              // Basic Information Section
              _buildSectionTitle('Basic Information'),
              16.heightBox,

              _field(
                controller.nameController,
                'Vendor Name',
                Icons.business_outlined,
                required: true,
              ),
              12.heightBox,

              // Country Field with Picker
              _buildCountryField(context),
              12.heightBox,

              _field(
                controller.emailController,
                'Email Address',
                Icons.email_outlined,
                validator: _emailValidator,
              ),
              12.heightBox,

              _field(
                controller.websiteController,
                'Website',
                Icons.language_outlined,
              ),
              12.heightBox,

              _field(
                controller.addressController,
                'Address',
                Icons.location_on_outlined,
                maxLines: 2,
              ),

              // Logo Section
              24.heightBox,
              _buildSectionTitle('Company Logo'),
              16.heightBox,
              _buildLogoSection(),

              // Phone Numbers Section
              24.heightBox,
              _buildSectionTitle('Contact Numbers'),
              16.heightBox,
              _phonesSection(),

              // Submit Button
              32.heightBox,
              _buildSubmitButton(),
              50.heightBox,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.storefront_outlined,
          size: 40,
          color: MyAppColors.primaryColor.withValues(alpha:0.8),
        ),
        12.heightBox,
        Text(
          'Vendor Details',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.grey[800],
            letterSpacing: -0.5,
          ),
        ),
        4.heightBox,
        Text(
          'Please fill in all required information',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: MyAppColors.primaryColor.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: MyAppColors.primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          12.widthBox,
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: MyAppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryField(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCountryPicker(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: AbsorbPointer(
          child: TextFormField(
            controller: controller.countryController,
            style: TextStyle(
              fontSize: 15,
              color: controller.countryController.text.isEmpty
                  ? Colors.grey[500]
                  : Colors.grey[800],
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Country is required';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Country',
              labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
              prefixIcon: Icon(
                Icons.flag_outlined,
                color: Colors.grey[500],
                size: 20,
              ),
              suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.grey[500]),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              hintText: 'Select a country',
              hintStyle: TextStyle(color: Colors.grey[500]),
            ),
          ),
        ),
      ),
    );
  }

  void _showCountryPicker(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      showWorldWide: false,
      favorite: ['US', 'GB', 'CA', 'AU', 'IN', 'DE', 'FR', 'JP', 'SG', 'AE'],
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
        bottomSheetHeight: 500,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        inputDecoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Type country name or code',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withValues(alpha:0.2),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyAppColors.primaryColor, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        searchTextStyle: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
      onSelect: (Country country) {
        controller.countryController.text = country.displayName;
        // Optional: Store additional country data in controller
        // controller.selectedCountryCode.value = country.countryCode;
        // controller.selectedCountryPhoneCode.value = country.phoneCode;
      },
    );
  }

  Widget _buildLogoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _field(
                controller.logoController,
                'Logo URL (optional)',
                Icons.link_outlined,
              ),
            ),
            12.widthBox,
            Container(
              decoration: BoxDecoration(
                color: MyAppColors.primaryColor.withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.photo_library_outlined,
                  color: MyAppColors.primaryColor,
                ),
                onPressed: controller.pickLogoFromGallery,
                tooltip: 'Pick from gallery',
              ),
            ),
          ],
        ),
        16.heightBox,
        Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  axisAlignment: -1.0,
                  child: child,
                ),
              );
            },
            child: controller.pickedLogo.value != null
                ? _buildImagePreview(
                    Image.file(controller.pickedLogo.value!),
                    controller.pickedLogo.value!.path,
                  )
                : controller.logoController.text.isNotEmpty
                ? _buildImagePreview(
                    Image.network(
                      controller.logoController.text,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildNoLogoPlaceholder(),
                    ),
                    controller.logoController.text,
                  )
                : _buildNoLogoPlaceholder(),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview(Widget image, String keyValue) {
    return Container(
      key: ValueKey(keyValue),
      height: 140,
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(12), child: image),
    ).centered();
  }

  Widget _buildNoLogoPlaceholder() {
    return Container(
      height: 140,
      width: 140,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, size: 40, color: Colors.grey[400]),
          8.heightBox,
          Text(
            'No logo',
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
    ).centered();
  }

  Widget _phonesSection() {
    return GetBuilder<VendorFormController>(
      builder: (c) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                ...c.phoneControllers.asMap().entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: MyAppColors.primaryColor.withValues(alpha:0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.phone_outlined,
                            size: 16,
                            color: MyAppColors.primaryColor,
                          ).centered(),
                        ),
                        12.widthBox,
                        Expanded(
                          child: TextFormField(
                            controller: e.value,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: 'Phone number ${e.key + 1}',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: MyAppColors.primaryColor,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                        if (c.phoneControllers.length > 1)
                          IconButton(
                            icon: Icon(
                              Icons.remove_circle_outlined,
                              color: Colors.red[400],
                            ),
                            onPressed: () => c.removePhoneField(e.key),
                            tooltip: 'Remove phone number',
                          ),
                      ],
                    ),
                  ),
                ),
                12.heightBox,
                OutlinedButton.icon(
                  onPressed: c.addPhoneField,
                  icon: Icon(
                    Icons.add_circle_outlined,
                    color: MyAppColors.primaryColor,
                  ),
                  label: Text(
                    'Add another phone number',
                    style: TextStyle(color: MyAppColors.primaryColor),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: BorderSide(color: MyAppColors.primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool required = false,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(fontSize: 15, color: Colors.grey[800]),
        validator:
            validator ??
            (required
                ? (v) => v == null || v.isEmpty ? '$label is required' : null
                : null),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.grey[500], size: 20),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          suffixIcon: required
              ? Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    '*',
                    style: TextStyle(
                      color: Colors.red[400],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(
      () => controller.isLoading.value
          ? Container(
              height: 54,
              decoration: BoxDecoration(
                color: MyAppColors.primaryColor.withValues(alpha:0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: MyAppColors.primaryColor.withValues(alpha:0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(
                        Colors.white.withValues(alpha:0.8),
                      ),
                    ),
                  ),
                  12.widthBox,
                  Text(
                    'Saving...',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ).centered(),
            )
          : ElevatedButton(
              onPressed: controller.submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: MyAppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                shadowColor: MyAppColors.primaryColor.withValues(alpha:0.3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outlined, size: 20),
                  10.widthBox,
                  const Text(
                    'Save Vendor',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  String? _emailValidator(String? v) {
    if (v == null || v.isEmpty) return null;
    if (!GetUtils.isEmail(v)) return 'Please enter a valid email address';
    return null;
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../core/constants/colors.dart';
import '../../domain/models/vendor.dart';
import '../controllers/vendor_controller.dart';

class VendorDetailsView extends GetView<VendorController> {
  final String vendorId;

  const VendorDetailsView({super.key, required this.vendorId});

  @override
  Widget build(BuildContext context) {
    // Find vendor by ID
    final vendor = controller.getVendorById(vendorId);

    if (vendor == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Vendor Not Found'),
          backgroundColor: MyAppColors.primaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[400],
              ),
              16.heightBox,
              Text(
                'Vendor not found',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              8.heightBox,
              Text(
                'Vendor with ID $vendorId does not exist',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              24.heightBox,
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyAppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Go Back',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          vendor.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: MyAppColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              // Navigate to edit form using the vendor ID
              Get.toNamed('/vendor/edit/${vendor.id}');
            },
            tooltip: 'Edit Vendor',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Vendor Logo Section
            Container(
              height: 200,
              color: Colors.grey[50],
              child: (vendor.logo != null && vendor.logo!.isNotEmpty)
                  ? Image.network(
                vendor.logo!,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => _buildLogoFallback(vendor),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2,
                      color: MyAppColors.primaryColor.withOpacity(0.5),
                    ),
                  );
                },
              )
                  : _buildLogoFallback(vendor),
            ),

            // Vendor Info Card
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      _buildInfoRow(
                        icon: Icons.business_outlined,
                        label: 'Name',
                        value: vendor.name,
                        isFirst: true,
                      ),

                      // Country
                      if (vendor.organ != null && vendor.organ!.isNotEmpty)
                        _buildInfoRow(
                          icon: Icons.flag_outlined,
                          label: 'Country',
                          value: vendor.organ!,
                        ),

                      // Email
                      if (vendor.email != null && vendor.email!.isNotEmpty)
                        _buildInfoRow(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: vendor.email!,
                          isEmail: true,
                        ),

                      // Website
                      if (vendor.website != null && vendor.website!.isNotEmpty)
                        _buildInfoRow(
                          icon: Icons.language_outlined,
                          label: 'Website',
                          value: vendor.website!,
                          isWebsite: true,
                        ),

                      // Address
                      if (vendor.address != null && vendor.address!.isNotEmpty)
                        _buildInfoRow(
                          icon: Icons.location_on_outlined,
                          label: 'Address',
                          value: vendor.address!,
                          isLast: true,
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Phone Numbers Section
            if (vendor.phones.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Contact Numbers',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              8.heightBox,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...vendor.phones.asMap().entries.map((entry) {
                          final index = entry.key;
                          final phone = entry.value;
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: index == vendor.phones.length - 1 ? 0 : 12,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: MyAppColors.primaryColor.withOpacity(0.1),
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
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Phone ${index + 1}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      4.heightBox,
                                      Text(
                                        phone,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ),
            ],

            // Dates Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey[200]!),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Created',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            4.heightBox,
                            Text(
                              _formatDate(vendor.createdAt),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 1,
                        color: Colors.grey[300],
                      ),
                      16.widthBox,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Last Updated',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            4.heightBox,
                            Text(
                              _formatDate(vendor.updatedAt),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Call Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: vendor.phones.isNotEmpty
                          ? () {
                        _makePhoneCall(vendor.phones.first);
                      }
                          : null,
                      icon: const Icon(Icons.phone, size: 20),
                      label: const Text('Call'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyAppColors.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  12.widthBox,
                  // Email Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: vendor.email != null && vendor.email!.isNotEmpty
                          ? () {
                        _sendEmail(vendor.email!);
                      }
                          : null,
                      icon: const Icon(Icons.email_outlined, size: 20),
                      label: const Text('Email'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: MyAppColors.primaryColor),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Delete Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: TextButton.icon(
                onPressed: () => _showDeleteDialog(vendor),
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.red[400],
                ),
                label: Text(
                  'Delete Vendor',
                  style: TextStyle(
                    color: Colors.red[400],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.red[50],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoFallback(Vendor vendor) {
    return Container(
      color: MyAppColors.primaryColor.withOpacity(0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.storefront_outlined,
            size: 48,
            color: MyAppColors.primaryColor.withOpacity(0.6),
          ),
          8.heightBox,
          Text(
            vendor.name.split(' ').take(2).join(' '),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
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

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isFirst = false,
    bool isLast = false,
    bool isEmail = false,
    bool isWebsite = false,
  }) {
    return Container(
      padding: EdgeInsets.only(
        top: isFirst ? 0 : 16,
        bottom: isLast ? 0 : 16,
      ),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18,
              color: MyAppColors.primaryColor,
            ).centered(),
          ),
          12.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                4.heightBox,
                if (isEmail)
                  GestureDetector(
                    onTap: () => _sendEmail(value),
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                else if (isWebsite)
                  GestureDetector(
                    onTap: () => _openWebsite(value),
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                else
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _makePhoneCall(String phoneNumber) {
    // TODO: Implement phone call functionality
    Get.snackbar(
      'Call',
      'Calling $phoneNumber',
      backgroundColor: MyAppColors.primaryColor,
      colorText: Colors.white,
    );
  }

  void _sendEmail(String email) {
    // TODO: Implement email functionality
    Get.snackbar(
      'Email',
      'Opening email client for $email',
      backgroundColor: MyAppColors.primaryColor,
      colorText: Colors.white,
    );
  }

  void _openWebsite(String url) {
    // TODO: Implement website opening functionality
    Get.snackbar(
      'Website',
      'Opening $url',
      backgroundColor: MyAppColors.primaryColor,
      colorText: Colors.white,
    );
  }

  void _showDeleteDialog(Vendor vendor) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Vendor'),
        content: Text(
          'Are you sure you want to delete "${vendor.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await _deleteVendor(vendor.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteVendor(String vendorId) async {
    try {
      // TODO: Implement delete functionality in repository
      // await controller.deleteVendor(vendorId);

      Get.snackbar(
        'Success',
        'Vendor deleted successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete vendor: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../core/constants/colors.dart';
import '../../domain/models/vendor.dart';

class VendorDetailView extends GetView {
  final Vendor vendor;

  const VendorDetailView({super.key, required this.vendor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: vendor.name.text.make(),
        backgroundColor: MyAppColors.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo
            if (vendor.logo != null)
              Image.network(
                vendor.logo!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.contain,
              ).p(16),

            // Details
            VStack([
              'Company Details'.text.xl2.bold.make().pOnly(bottom: 16),
              _buildDetailItem('Country', vendor.organ),
              _buildDetailItem('Website', vendor.website, isLink: true),
              _buildDetailItem('Email', vendor.email, isEmail: true),
              _buildDetailItem('Address', vendor.address),
              _buildDetailItem('Registered', _formatDate(vendor.createdAt)),
            ]).p(16),

            // Phone Numbers
            if (vendor.phones.isNotEmpty)
              Card(
                child: VStack([
                  'Contact Numbers'.text.xl.bold.make().pOnly(bottom: 12),
                  ...vendor.phones.map((phone) =>
                      HStack([
                        Icon(Icons.phone, size: 16, color: MyAppColors.primaryColor),
                        8.widthBox,
                        phone.text.make(),
                      ]).pOnly(bottom: 8)
                  ),
                ]).p(16),
              ).p(16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String? value,
      {bool isLink = false, bool isEmail = false}) {
    if (value == null || value.isEmpty) return SizedBox();

    return VStack([
      label.text.sm.gray500.make(),
      4.heightBox,
      if (isLink)
        value.text.blue600.underline.make().onTap(() {
          // Handle link tap
        })
      else if (isEmail)
        value.text.blue600.make().onTap(() {
          // Handle email tap
        })
      else
        value.text.lg.make(),
      16.heightBox,
    ]);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
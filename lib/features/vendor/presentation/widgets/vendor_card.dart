import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';import '../../../../core/constants/colors.dart';

import '../../domain/models/vendor.dart';

class VendorCard extends StatelessWidget {
  final Vendor vendor;
  final VoidCallback onTap;
  final bool showDetails;

  const VendorCard({
    super.key,
    required this.vendor,
    required this.onTap,
    this.showDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with logo and name
              Row(
                children: [
                  // Logo or placeholder
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: MyAppColors.primaryColor.withValues(alpha:0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: vendor.logo != null
                        ? Image.network(
                      vendor.logo!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.business,
                          color: MyAppColors.primaryColor,
                        );
                      },
                    )
                        : Icon(
                      Icons.business,
                      color: MyAppColors.primaryColor,
                    ),
                  ),
                  12.widthBox,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        vendor.name.text.lg.semiBold.make(),
                        if (vendor.organ != null)
                          vendor.organ!.text.sm.gray500.make(),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: MyAppColors.primaryColor,
                  ),
                ],
              ),

              // Details (if expanded)
              if (showDetails) ...[
                12.heightBox,
                Divider(height: 1),
                12.heightBox,

                // Contact info
                if (vendor.email != null)
                  Row(
                    children: [
                      Icon(Icons.email, size: 16, color: Colors.grey),
                      8.widthBox,
                      Expanded(child: vendor.email!.text.sm.make()),
                    ],
                  ).pOnly(bottom: 8),

                if (vendor.phones.isNotEmpty)
                  Row(
                    children: [
                      Icon(Icons.phone, size: 16, color: Colors.grey),
                      8.widthBox,
                      Expanded(
                        child: vendor.phones.first.text.sm.make(),
                      ),
                    ],
                  ).pOnly(bottom: 8),

                if (vendor.address != null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey),
                      8.widthBox,
                      Expanded(child: vendor.address!.text.sm.make()),
                    ],
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
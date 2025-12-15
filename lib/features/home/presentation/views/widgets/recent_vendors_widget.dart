import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../vendor/presentation/controllers/vendor_controller.dart';
import '../../../../vendor/presentation/views/vendor_list_view.dart';
import '../../../../vendor/presentation/widgets/vendor_card.dart';

class RecentVendorsWidget extends StatelessWidget {
  final VendorController controller;

  const RecentVendorsWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.vendors.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      // Get only the first 5 vendors (or last 5 if you want recent)
      final recentVendors = controller.vendors.take(5).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with "See All" link
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Vendors',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to full vendors page
                    Get.to(() => VendorListView());
                  },
                  child: const Row(
                    children: [
                      Text(
                        'See All',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios, size: 14, color: Colors.blue),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Horizontal List of Vendors
          SizedBox(
            height: 180, // Adjust based on your card design
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              itemCount: recentVendors.length,
              itemBuilder: (context, index) {
                final vendor = recentVendors[index];
                return Container(
                  width: 160, // Card width
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: VendorCard(
                    vendor: vendor,
                    onTap: () {
                      // Navigate to vendor details
                      controller.selectVendor(vendor as String);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
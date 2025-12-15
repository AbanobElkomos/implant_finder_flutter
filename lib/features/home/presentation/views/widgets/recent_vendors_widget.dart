import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../vendor/domain/models/vendor.dart';
import '../../../presentation/controllers/home_controller.dart';
import '../../../../vendor/presentation/views/vendor_list_view.dart';

class RecentVendorsWidget extends StatelessWidget {
  final HomeController homeController;

  const RecentVendorsWidget({super.key, required this.homeController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      /// SKELETON LOADING
      if (homeController.isLoading.value) {
        return _buildSkeleton();
      }

      if (homeController.topVendors.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Text('No vendors available'),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          _vendorList(homeController.topVendors),
        ],
      );
    });
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Top Vendors',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () => Get.to(() => VendorListView()),
            child: const Text('See All'),
          ),
        ],
      ),
    );
  }

  Widget _vendorList(List<Vendor> vendors) {
    return SizedBox(
      height: 230,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: vendors.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          final vendor = vendors[index];
          return SizedBox(
            width: 170,
            child: _VendorCard(vendor: vendor),
          );
        },
      ),
    );
  }

  Widget _buildSkeleton() {
    return SizedBox(
      height: 230,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 5,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, _) => const SizedBox(
          width: 170,
          child: _VendorSkeleton(),
        ),
      ),
    );
  }
}

/// ================= CARD =================

class _VendorCard extends StatelessWidget {
  final Vendor vendor;

  const _VendorCard({required this.vendor});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => Get.toNamed('/vendor/${vendor.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'vendor-logo-${vendor.id}',
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade200,
                  ),
                  child: vendor.logo != null
                      ? Image.network(vendor.logo!, fit: BoxFit.cover)
                      : const Icon(Icons.business),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                vendor.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VendorSkeleton extends StatelessWidget {
  const _VendorSkeleton();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 50, height: 50, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Container(height: 12, width: 80, color: Colors.grey.shade300),
          ],
        ),
      ),
    );
  }
}

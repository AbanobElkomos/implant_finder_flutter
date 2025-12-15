import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../core/constants/colors.dart';
import '../../../../routes/app_pages.dart';
import '../../domain/models/vendor.dart';
import '../controllers/vendor_controller.dart';

class VendorListView extends GetView<VendorController> {
  const VendorListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyAppColors.primaryColor,
        title: Center(
          child: Text(
            'Implant Vendors',
            style: GoogleFonts.lato(
              color: MyAppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: MyAppColors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          _buildSearchFilterBar(context),

          // Active Filters
          _buildActiveFilters(),

          // Vendor Grid
          _buildVendorGrid(),
          50.heightBox,

        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyAppColors.primaryColor,
        onPressed: () => Get.toNamed(Routes.VENDOR_ADD), // Use named route
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildSearchFilterBar(BuildContext context) {
    // Add context parameter
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Search Field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Icon(
                      Icons.search,
                      color: Colors.grey[500],
                      size: 20,
                    ),
                  ),
                  12.widthBox,
                  Expanded(
                    child: TextFormField(
                      controller: controller.searchController,
                      decoration: InputDecoration(
                        hintText: 'Search vendors...',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                      onChanged: (value) {
                        controller.search(value);
                      },
                    ),
                  ),
                  if (controller.searchController.text.isNotEmpty)
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.grey[500],
                        size: 18,
                      ),
                      onPressed: () {
                        controller.searchController.clear();
                        controller.search('');
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ).pOnly(right: 8),
                ],
              ),
            ),
          ),

          12.widthBox,

          // Filter Button
          Obx(() {
            final hasActiveFilters =
                controller.selectedCountry.isNotEmpty ||
                controller.searchQuery.isNotEmpty;

            return Container(
              decoration: BoxDecoration(
                color: hasActiveFilters
                    ? MyAppColors.primaryColor.withValues(alpha: 0.1)
                    : Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hasActiveFilters
                      ? MyAppColors.primaryColor
                      : Colors.grey[200]!,
                  width: hasActiveFilters ? 1.5 : 1,
                ),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.filter_list,
                  color: hasActiveFilters
                      ? MyAppColors.primaryColor
                      : Colors.grey[600],
                  size: 22,
                ),
                onPressed: () =>
                    _showFilterOptions(context), // Pass context here
                tooltip: 'Filter vendors',
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActiveFilters() {
    return Obx(() {
      if (controller.selectedCountry.isEmpty &&
          controller.searchQuery.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.filter_alt_outlined,
              color: MyAppColors.primaryColor,
              size: 16,
            ),
            8.widthBox,
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (controller.selectedCountry.isNotEmpty)
                    _buildFilterChip(
                      label: 'Country: ${controller.selectedCountry}',
                      onDelete: () => controller.setCountryFilter(''),
                    ),

                  if (controller.searchQuery.isNotEmpty)
                    _buildFilterChip(
                      label: 'Search: "${controller.searchQuery}"',
                      onDelete: () {
                        controller.searchController.clear();
                        controller.search('');
                      },
                    ),
                ],
              ),
            ),

            if (controller.selectedCountry.isNotEmpty ||
                controller.searchQuery.isNotEmpty)
              TextButton(
                onPressed: controller.clearFilters,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                ),
                child: Row(
                  children: [
                    Icon(Icons.close, color: Colors.grey[600], size: 16),
                    4.widthBox,
                    Text(
                      'Clear all',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildFilterChip({
    required String label,
    required VoidCallback onDelete,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: MyAppColors.primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 14, color: Colors.grey[500]),
            onPressed: onDelete,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ).pOnly(right: 4),
        ],
      ),
    );
  }

  Widget _buildVendorGrid() {
    return Obx(() {
      if (controller.isLoading.value && controller.vendors.isEmpty) {
        return Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation(
                      MyAppColors.primaryColor,
                    ),
                  ),
                ),
                16.heightBox,
                Text(
                  'Loading vendors...',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
        );
      }

      if (controller.error.isNotEmpty) {
        return Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
                16.heightBox,
                controller.error.value.text
                    .size(16)
                    .color(Colors.red[600]!)
                    .align(TextAlign.center)
                    .makeCentered()
                    .pSymmetric(h: 32),
                24.heightBox,
                ElevatedButton.icon(
                  onPressed: controller.loadVendors,
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text(
                    'Try Again',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyAppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      if (controller.filteredVendors.isEmpty) {
        return Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
                16.heightBox,
                Text(
                  'No vendors found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                8.heightBox,
                Text(
                  'Try adjusting your search or filters',
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
                16.heightBox,
                OutlinedButton(
                  onPressed: controller.clearFilters,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: MyAppColors.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Clear all filters',
                    style: TextStyle(color: MyAppColors.primaryColor),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return Expanded(
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.filteredVendors.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final vendor = controller.filteredVendors[index];
            return _vendorGridCard(vendor);
          },
        ),
      );
    });
  }

  Widget _vendorGridCard(Vendor vendor) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        // controller.selectVendor(vendor.id);
        Get.toNamed('${Routes.VENDOR_DETAIL}/${vendor.id}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey[100]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo/Image Section
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Container(
                  color: Colors.grey[50],
                  child: (vendor.logo != null && vendor.logo!.isNotEmpty)
                      ? Image.network(
                          vendor.logo!,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (_, _, _) => _logoFallback(vendor),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                                strokeWidth: 2,
                                color: MyAppColors.primaryColor.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            );
                          },
                        )
                      : _logoFallback(vendor),
                ),
              ),
            ),

            // Vendor Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vendor.name.trim(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.cairo(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[800],
                      height: 1.2,
                    ),
                  ),

                  4.heightBox,

                  if (vendor.organ != null && vendor.organ!.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 12,
                          color: Colors.grey[500],
                        ),
                        4.widthBox,
                        Expanded(
                          child: Text(
                            vendor.organ!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _logoFallback(Vendor vendor) {
    return Container(
      color: MyAppColors.primaryColor.withValues(alpha: 0.1),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.storefront_outlined,
            size: 32,
            color: MyAppColors.primaryColor.withValues(alpha: 0.6),
          ),
          8.heightBox,
          Text(
            vendor.name.split(' ').take(2).join(' '),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: MyAppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // FIXED FUNCTION: Changed parameter type from Context to BuildContext
  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        // Explicitly type the builder parameter
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              children: [
                // Drag Handle
                12.heightBox,
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                16.heightBox,

                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.filter_list_outlined,
                        color: MyAppColors.primaryColor,
                      ),
                      12.widthBox,
                      Expanded(
                        child: Text(
                          'Filter Vendors',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.grey[500]),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                ),

                16.heightBox,

                // Country Filter Section
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Obx(() {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Country',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                          16.heightBox,

                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildCountryChip(
                                label: 'All Countries',
                                isSelected: controller.selectedCountry.isEmpty,
                                onTap: () => controller.setCountryFilter(''),
                              ),
                              ...controller.countries.map((country) {
                                return _buildCountryChip(
                                  label: country,
                                  isSelected:
                                      controller.selectedCountry.value ==
                                      country,
                                  onTap: () =>
                                      controller.setCountryFilter(country),
                                );
                              }),
                            ],
                          ),
                          24.heightBox,
                        ],
                      );
                    }),
                  ),
                ),

                // Apply Button
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Colors.grey[200]!)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyAppColors.primaryColor,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCountryChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? MyAppColors.primaryColor : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? MyAppColors.primaryColor : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

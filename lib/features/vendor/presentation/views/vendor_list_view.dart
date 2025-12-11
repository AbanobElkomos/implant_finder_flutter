import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../core/constants/colors.dart';
import '../../domain/models/vendor.dart';
import '../controllers/vendor_controller.dart';

class VendorListView extends GetView<VendorController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Implant Vendors'.text.make(),
        backgroundColor: MyAppColors.primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading && controller.vendors.isEmpty) {
          return CircularProgressIndicator().centered();
        }

        if (controller.error.isNotEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              controller.error.text.red500.makeCentered(),
              20.heightBox,
              ElevatedButton(
                onPressed: controller.loadVendors,
                child: 'Retry'.text.make(),
              ),
            ],
          ).centered();
        }

        return Column(
          children: [
            // Filters summary
            if (controller.selectedCountry.isNotEmpty || controller.searchQuery.isNotEmpty)
              HStack([
                if (controller.selectedCountry.isNotEmpty)
                  Chip(
                    label: 'Country: ${controller.selectedCountry}'.text.make(),
                    onDeleted: () => controller.setCountryFilter(''),
                  ).pOnly(right: 8),
                if (controller.searchQuery.isNotEmpty)
                  Chip(
                    label: 'Search: ${controller.searchQuery}'.text.make(),
                    onDeleted: () => controller.search(''),
                  ),
                Spacer(),
                TextButton(
                  onPressed: controller.clearFilters,
                  child: 'Clear All'.text.sm.make(),
                ),
              ]).p(8),

            // Vendor list
            Expanded(
              child: ListView.builder(
                itemCount: controller.filteredVendors.length,
                itemBuilder: (context, index) {
                  final vendor = controller.filteredVendors[index];
                  return _buildVendorCard(vendor, context);
                },
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyAppColors.primaryColor,
        onPressed: () => Get.toNamed('/vendor/add'),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildVendorCard(Vendor vendor, BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: MyAppColors.primaryColor.withOpacity(0.1),
          child: vendor.logo != null
              ? Image.network(vendor.logo!, fit: BoxFit.cover)
              : vendor.name[0].text.xl.bold.make(),
        ),
        title: vendor.name.text.lg.semiBold.make(),
        subtitle: VStack([
          if (vendor.organ != null) '📍 ${vendor.organ}'.text.sm.make(),
          if (vendor.email != null) '📧 ${vendor.email}'.text.sm.make(),
          if (vendor.phone.isNotEmpty) '📱 ${vendor.phone.first}'.text.sm.make(),
        ]),
        trailing: Icon(Icons.chevron_right, color: MyAppColors.primaryColor),
        onTap: () {
          controller.selectVendor(vendor.id);
          Get.toNamed('/vendor/${vendor.id}');
        },
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: 'Search Vendors'.text.make(),
        content: TextFormField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter vendor name or email...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) => controller.search(value),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: 'Cancel'.text.make(),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'Filter by Country'.text.xl.bold.make(),
            16.heightBox,
            Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: 'All'.text.make(),
                  selected: controller.selectedCountry.isEmpty,
                  onSelected: (_) => controller.setCountryFilter(''),
                ),
                ...controller.countries.map((country) => FilterChip(
                  label: country.text.make(),
                  selected: controller.selectedCountry == country,
                  onSelected: (_) => controller.setCountryFilter(country),
                )),
              ],
            )),
            20.heightBox,
            ElevatedButton(
              onPressed: Get.back,
              child: 'Apply Filters'.text.white.make(),
              style: ElevatedButton.styleFrom(
                backgroundColor: MyAppColors.primaryColor,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
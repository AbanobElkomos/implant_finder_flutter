import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:implant_finder/features/home/presentation/views/widgets/recent_vendors_widget.dart';

import '../../../vendor/data/repositories/vendor_repository_impl.dart';
import '../../../vendor/presentation/controllers/vendor_controller.dart';
import '../../../vendor/presentation/views/vendor_list_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});


  @override
  Widget build(BuildContext context) {
    final VendorController vendorController = Get.put(
      VendorController(
        VendorRepositoryImpl(Get.find()), // Repository dependency
      ),
    );
    // Load vendors when home page is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vendorController.loadTopVendors();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Implant Finder'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Welcome section
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.blue[50],
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to Implant Finder',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Find medical implant vendors worldwide',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Recent Vendors Section
            RecentVendorsWidget(controller: vendorController),

            const SizedBox(height: 20),

            // Other home page sections can go here
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      _buildActionCard(
                        icon: Icons.search,
                        title: 'Search Vendors',
                        onTap: () => Get.to(() => VendorListView()),
                      ),
                      _buildActionCard(
                        icon: Icons.map,
                        title: 'View by Country',
                        onTap: () {
                          // Navigate to country filter view
                        },
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

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.blue),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
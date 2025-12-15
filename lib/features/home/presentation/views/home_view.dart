import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:implant_finder/features/home/presentation/views/widgets/recent_vendors_widget.dart';

import '../../../vendor/presentation/views/vendor_list_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(
      HomeController(Get.find()),
      permanent: true,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Implant Finder')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _welcome(),

            const SizedBox(height: 20),

            /// TOP VENDORS (HOME CONTROLLER)
            RecentVendorsWidget(homeController: homeController),

            const SizedBox(height: 20),

            _quickActions(),
          ],
        ),
      ),
    );
  }

  Widget _welcome() {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade100, Colors.white],
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to Implant Finder',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Find trusted implant vendors worldwide',
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _quickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 2.6,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              _action(Icons.search, 'Search Vendors', () => Get.to(() => VendorListView())),
              _action(Icons.public, 'By Country', () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _action(IconData icon, String title, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon, color: Colors.blue),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}

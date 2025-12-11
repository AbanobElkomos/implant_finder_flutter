import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../core/constants/colors.dart';
import '../../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Implant Finder'.text.make(),
        backgroundColor: MyAppColors.primaryColor,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.PROFILE),
            icon: Icon(Icons.person),
          ),
          IconButton(
            onPressed: controller.signOut,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: VStack(
        [
          'Welcome to Implant Finder!'.text.xl2.bold.makeCentered(),
          20.heightBox,
          'Find the best implant vendors in Egypt'.text.lg.makeCentered(),
          40.heightBox,

          // Quick Actions
          VStack([
            _buildActionCard(
              icon: Icons.business,
              title: 'Browse Vendors',
              subtitle: 'View all implant vendors',
              onTap: () => Get.toNamed(Routes.VENDOR_LIST),
              color: MyAppColors.primaryColor,
            ),
            16.heightBox,
            _buildActionCard(
              icon: Icons.search,
              title: 'Search',
              subtitle: 'Find specific vendors',
              onTap: () => Get.toNamed(Routes.VENDOR_LIST),
              color: MyAppColors.accentColor,
            ),
            16.heightBox,
            _buildActionCard(
              icon: Icons.person,
              title: 'My Profile',
              subtitle: 'View and edit your profile',
              onTap: () => Get.toNamed(Routes.PROFILE),
              color: Colors.green,
            ),
          ]).pSymmetric(h: 20),

          40.heightBox,

          // Quick Stats
          Obx(() => controller.isLoading.value
              ? CircularProgressIndicator().centered()
              : _buildStatsSection()),
        ],
        alignment: MainAxisAlignment.center,
      ).centered(),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, size: 40, color: color),
        title: title.text.lg.semiBold.make(),
        subtitle: subtitle.text.make(),
        trailing: Icon(Icons.chevron_right, color: MyAppColors.primaryColor),
        onTap: onTap,
      ),
    );
  }

  Widget _buildStatsSection() {
    return Card(
      child: VStack([
        'Quick Stats'.text.xl.bold.make().pOnly(bottom: 16),
        HStack([
          _buildStatItem('Vendors', '${controller.vendorCount}'),
          _buildStatItem('Countries', '${controller.countryCount}'),
          _buildStatItem('Active', '${controller.activeCount}'),
        ]),
      ]).p(16),
    ).pSymmetric(h: 20);
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          value.text.xl2.bold.color(MyAppColors.primaryColor).make(),
          4.heightBox,
          label.text.sm.gray500.make(),
        ],
      ),
    );
  }
}
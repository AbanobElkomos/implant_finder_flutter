import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/vendor_repository_impl.dart';
import '../controllers/vendor_controller.dart';
import '../controllers/vendor_form_controller.dart';


class VendorBinding extends Bindings {
  @override
  void dependencies() {
    // ================= Supabase =================
    if (!Get.isRegistered<SupabaseClient>()) {
      Get.put<SupabaseClient>(
        Supabase.instance.client,
        permanent: true,
      );
    }

    final supabase = Get.find<SupabaseClient>();

    // ================= Repository =================
    Get.lazyPut<VendorRepositoryImpl>(
          () => VendorRepositoryImpl(supabase),
      fenix: true,
    );

    // ================= Controllers =================
    Get.lazyPut<VendorController>(
          () => VendorController(Get.find<VendorRepositoryImpl>()),
      fenix: true,
    );

    Get.lazyPut<VendorFormController>(
          () => VendorFormController(
        Get.find<VendorRepositoryImpl>(),
        supabase,
      ),
      fenix: true,
    );
  }
}

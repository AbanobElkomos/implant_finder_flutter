import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/vendor/data/repositories/vendor_repository.dart';
import '../../features/vendor/data/repositories/vendor_repository_impl.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // ⚠️ الأهم: تسجيل SupabaseClient أولاً
    Get.put<SupabaseClient>(
      Supabase.instance.client,
      permanent: true, // يبقى موجوداً طوال عمر التطبيق
      tag: 'supabase',
    );
    // Vendor Repository (IMPORTANT)
    Get.lazyPut<VendorRepository>(
          () => VendorRepositoryImpl(Get.find<SupabaseClient>()),
      fenix: true,
    );
   }
}
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/vendor_repository_impl.dart';
import '../controllers/vendor_controller.dart';
import '../controllers/vendor_form_controller.dart';

class VendorBinding extends Bindings {
  @override
  void dependencies() {
    // ⚠️ تأكد من وجود SupabaseClient أولاً
    // إذا لم يكن مسجلاً، سجله هنا
    SupabaseClient supabaseClient;
    try {
      supabaseClient = Get.find<SupabaseClient>();
      print('✅ Found SupabaseClient in GetX');
    } catch (e) {
      // إذا لم يكن موجوداً، أنشئه
      supabaseClient = Supabase.instance.client;
      Get.put<SupabaseClient>(supabaseClient, permanent: true);
      print('⚠️ SupabaseClient not found, registered it');
    }

    // إنشاء repository
    final repository = VendorRepositoryImpl(supabaseClient);

    // تسجيل controllers
    Get.lazyPut<VendorController>(
          () => VendorController(repository),
      fenix: true,
    );

    Get.lazyPut<VendorFormController>(
          () => VendorFormController(repository, supabaseClient),
      fenix: true,
    );

    print('✅ VendorBinding dependencies loaded');
  }
}
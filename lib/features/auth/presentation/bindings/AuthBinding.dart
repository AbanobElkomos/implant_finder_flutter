import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // تأكد من أن SupabaseClient مسجل أولاً
    // عادةً يتم تسجيله في main.dart أو initial_binding

    Get.lazyPut<AuthController>(
          () => AuthController(),
      fenix: true, // يعيد الإنشاء عند الحاجة
    );
  }
}
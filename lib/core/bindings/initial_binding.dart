import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // ⚠️ الأهم: تسجيل SupabaseClient أولاً
    Get.put<SupabaseClient>(
      Supabase.instance.client,
      permanent: true, // يبقى موجوداً طوال عمر التطبيق
      tag: 'supabase',
    );

    print('✅ SupabaseClient registered in GetX');
  }
}
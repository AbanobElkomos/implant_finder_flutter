import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:implant_finder/core/constants/colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/bindings/initial_binding.dart';
import 'core/constants/app_constants.dart';
import 'core/locales/translation_service.dart';
import 'routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize GetStorage
  await GetStorage.init();

  // 2. Initialize Supabase
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnnonKey,
  );

  // 3. Configure GetX
  Get.config(
    enableLog: true,
    defaultPopGesture: true,
    defaultTransition: Transition.cupertino,
  );

  print('🚀 App initialized');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      theme: ThemeData(
        primaryColor: MyAppColors.primaryColor,
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: MyAppColors.accentColor),
        useMaterial3: true,
      ),

      // ============ Localization ============
      translations: TranslationService(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'US'),

      // ============ Initial Binding ============
      initialBinding: InitialBinding(),

      // ============ Initial Route ============
      // ⚠️ تحديد initial route بناءً على حالة المصادقة
      initialRoute: _getInitialRoute(),

      // ============ Routes ============
      getPages: AppPages.routes,

      // ============ Debug ============
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  // دالة لتحديد initial route
  String _getInitialRoute() {
    try {
      // تحقق إذا كان هناك جلسة نشطة
      final session = Supabase.instance.client.auth.currentSession;
      print('🔐 Current session: ${session != null ? "Active" : "None"}');

      if (session != null) {
        return Routes.HOME; // المستخدم مسجل دخول
      } else {
        return Routes.LOGIN; // المستخدم غير مسجل
      }
    } catch (e) {
      print('❌ Error checking auth: $e');
      return Routes.LOGIN; // في حالة خطأ، اذهب إلى login
    }
  }
}
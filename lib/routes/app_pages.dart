// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import '../features/auth/bindings/auth_binding.dart';
import '../features/auth/presentation/views/login_view.dart';
import '../features/auth/presentation/views/signup_view.dart';
import '../features/home/presentation/bindings/home_binding.dart';
import '../features/home/presentation/views/home_view.dart';
import '../features/profile/presentation/bindings/profile_binding.dart';
import '../features/profile/presentation/views/profile_view.dart';
import '../features/profile/presentation/views/edit_profile_view.dart';
 import '../features/vendor/presentation/bindings/vendor_binding.dart';
import '../features/vendor/presentation/views/vendor_details_view.dart';
import '../features/vendor/presentation/views/vendor_list_view.dart';
 import '../features/vendor/presentation/views/vendor_form_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    // ============ Auth Routes ============
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      binding: AuthBinding(), // ✅
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: Routes.SIGN_UP,
      page: () => SignUpView(),
      binding: AuthBinding(), // ✅
      transition: Transition.rightToLeft,
    ),

    // ============ Home Route ============
    GetPage(
      name: Routes.HOME,
      page: () => HomeView( ),
      binding: HomeBinding(), // ⬅️ ⚠️ هذا السطر الناقص!
      transition: Transition.fadeIn,
    ),

    // ============ Profile Routes ============
    GetPage(
      name: Routes.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(), // ✅
    ),

    GetPage(
      name: Routes.EDIT_PROFILE,
      page: () => EditProfileView(),
      binding: ProfileBinding(), // ✅
    ),

    // ============ Vendor Routes ============
    GetPage(
      name: Routes.VENDOR_LIST,
      page: () => VendorListView(),
      binding: VendorBinding(), // ✅
    ),

    // Vendor Details Route with parameter
    GetPage(
      name: '${Routes.VENDOR_DETAIL}/:id',
      page: () {
        final vendorId = Get.parameters['id'] ?? '';
        return VendorDetailsView(vendorId: vendorId);
      },
      binding: VendorBinding(),
    ),
    // Vendor Edit Route with parameter
    GetPage(
      name: '${Routes.VENDOR_EDIT}/:id',
      page: () {
        final vendorId = Get.parameters['id'] ?? '';
        return VendorFormView(vendorId: vendorId);
      },
      binding: VendorBinding(),
    ),
    GetPage(
      name: Routes.VENDOR_ADD,
      page: () => VendorFormView(),
      binding: VendorBinding(), // ✅
    ),
  ];
}
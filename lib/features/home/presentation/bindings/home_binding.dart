import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // ✅ صحيح: HomeController بدون parameters
    Get.lazyPut<HomeController>(
          () => HomeController(), // ⬅️ بدون client parameter
      fenix: true,
    );
  }
}
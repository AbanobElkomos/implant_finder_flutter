import 'package:get/get.dart';
import '../../../vendor/data/repositories/vendor_repository_impl.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
          () => HomeController(
        VendorRepositoryImpl(Get.find()),
      ),
    );
  }
}

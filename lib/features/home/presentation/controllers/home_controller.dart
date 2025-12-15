import 'package:get/get.dart';
import '../../../vendor/data/repositories/vendor_repository.dart';
import '../../../vendor/domain/models/vendor.dart';
 import '../../../vendor/domain/usecases/get_top_vendors_usecase.dart';

class HomeController extends GetxController {
  final VendorRepository repository;

  HomeController(this.repository);

  final RxList<Vendor> topVendors = <Vendor>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  late final GetTopVendorsUseCase _getTopVendors;

  bool _loadedOnce = false;

  @override
  void onInit() {
    super.onInit();
    _getTopVendors = GetTopVendorsUseCase(repository);
    loadTopVendors();
  }

  Future<void> loadTopVendors() async {
    if (_loadedOnce) return;
    _loadedOnce = true;

    try {
      isLoading.value = true;
      error.value = '';

      final result = await _getTopVendors.execute();
      topVendors.assignAll(result);
    } catch (e) {
      error.value = e.toString();
      topVendors.clear();
    } finally {
      isLoading.value = false;
    }
  }
}

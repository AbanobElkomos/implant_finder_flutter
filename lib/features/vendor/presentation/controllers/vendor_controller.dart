import 'package:get/get.dart';
import '../../domain/models/vendor.dart';
import '../../domain/usecases/get_vendors_usecase.dart';
import '../../data/repositories/vendor_repository_impl.dart';

class VendorController extends GetxController {
  final VendorRepositoryImpl _repository;
  final GetVendorsUseCase _getVendorsUseCase;
  final GetVendorsByCountryUseCase _getVendorsByCountryUseCase;

  VendorController(this._repository)
      : _getVendorsUseCase = GetVendorsUseCase(_repository),
        _getVendorsByCountryUseCase = GetVendorsByCountryUseCase(_repository);

  // State
  final RxList<Vendor> _vendors = <Vendor>[].obs;
  final Rx<Vendor?> _selectedVendor = Rx<Vendor?>(null);
  final RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;
  final RxList<String> _countries = <String>[].obs;
  final RxString _searchQuery = ''.obs;
  final RxString _selectedCountry = ''.obs;

  // ⚠️ أضف onInit
  @override
  void onInit() {
    super.onInit();
    print('🚀 VendorController initialized');
    print('   Repository: $_repository');

    // Load vendors بعد تأخير بسيط
    Future.delayed(Duration(milliseconds: 500), () {
      print('🔄 Auto-loading vendors from onInit...');
      loadVendors();
    });
  }
  // Getters
  List<Vendor> get vendors => _vendors.toList();
  Vendor? get selectedVendor => _selectedVendor.value;
  bool get isLoading => _isLoading.value;
  String get error => _error.value;
  List<String> get countries => _countries.toList();
  String get searchQuery => _searchQuery.value;
  String get selectedCountry => _selectedCountry.value;

  // Computed getters
  List<Vendor> get filteredVendors {
    var filtered = vendors;

    if (selectedCountry.isNotEmpty) {
      filtered = filtered.where((v) => v.organ == selectedCountry).toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((v) =>
      v.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          (v.email?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false)
      ).toList();
    }

    return filtered;
  }

  Map<String, List<Vendor>> get vendorsByCountry {
    final Map<String, List<Vendor>> grouped = {};
    for (var vendor in vendors) {
      final country = vendor.organ ?? 'Unknown';
      if (!grouped.containsKey(country)) {
        grouped[country] = [];
      }
      grouped[country]!.add(vendor);
    }
    return grouped;
  }

  // Actions
  Future<void> loadVendors() async {
    try {
      print('🔄 Loading vendors...');
      _isLoading.value = true;
      _error.value = '';

      final vendors = await _getVendorsUseCase.execute();
      print('📊 Vendors loaded: ${vendors.length} items');

      // طباعة أول 3 موردين للتأكد
      for (int i = 0; i < vendors.length && i < 3; i++) {
        print('   ${i + 1}. ${vendors[i].name} - ${vendors[i].organ}');
      }

      _vendors.assignAll(vendors);

      // Extract unique countries
      final countrySet = vendors
          .map((v) => v.organ)
          .where((country) => country != null && country.isNotEmpty)
          .cast<String>()
          .toSet();
      _countries.assignAll(countrySet.toList()..sort());

      print('📍 Countries found: $_countries');

      update();
    } catch (e) {
      print('❌ Error loading vendors: $e');
      _error.value = 'Failed to load vendors: $e';
      Get.snackbar('Error', _error.value);
    } finally {
      _isLoading.value = false;
      print('✅ Loading completed');
    }
  }
  Future<void> loadVendorsByCountry(String country) async {
    try {
      _isLoading.value = true;
      _selectedCountry.value = country;

      final vendors = await _getVendorsByCountryUseCase.execute(country);
      _vendors.assignAll(vendors);
    } catch (e) {
      _error.value = 'Failed to load vendors: $e';
      Get.snackbar('Error', _error.value);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> selectVendor(String id) async {
    try {
      _isLoading.value = true;
      final vendor = await _repository.getVendorById(id);
      _selectedVendor.value = vendor;
    } catch (e) {
      _error.value = 'Failed to load vendor details: $e';
      Get.snackbar('Error', _error.value);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> search(String query) async {
    _searchQuery.value = query;
    if (query.length >= 2) {
      try {
        _isLoading.value = true;
        final results = await _repository.searchVendors(query);
        _vendors.assignAll(results);
      } catch (e) {
        _error.value = 'Failed to search: $e';
      } finally {
        _isLoading.value = false;
      }
    }
  }

  void clearFilters() {
    _selectedCountry.value = '';
    _searchQuery.value = '';
    loadVendors();
  }

  void setCountryFilter(String country) {
    _selectedCountry.value = country;
  }

  @override
  void onClose() {
    _vendors.close();
    _selectedVendor.close();
    _isLoading.close();
    _error.close();
    _countries.close();
    _searchQuery.close();
    _selectedCountry.close();
    super.onClose();
  }
}
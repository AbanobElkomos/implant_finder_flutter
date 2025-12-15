import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/vendor_repository.dart';
import '../../domain/models/vendor.dart';
import '../../domain/usecases/get_top_vendors_usecase.dart';
import '../../domain/usecases/search_vendors_usecase.dart';
import '../../domain/usecases/get_vendors_by_country_usecase.dart';
import '../../domain/usecases/get_vendors_usecase.dart';

class VendorController extends GetxController {
  final VendorRepository repository;

  VendorController(this.repository);

  // ================= STATE =================

  /// All vendors
  final RxList<Vendor> vendors = <Vendor>[].obs;

  /// Filtered vendors (search / country)
  final RxList<Vendor> filteredVendors = <Vendor>[].obs;

  /// Loading state
  final RxBool isLoading = false.obs;

  /// Error message
  final RxString error = ''.obs;

  /// Selected country filter
  final RxString selectedCountry = ''.obs;

  /// Search query
  final RxString searchQuery = ''.obs;

  /// Countries list (derived)
  final RxList<String> countries = <String>[].obs;

  /// Search controller for text field
  final TextEditingController searchController = TextEditingController();

  // ================= USE CASES =================
  late final GetVendorsUseCase _getVendors;
  late final GetTopVendorsUseCase _getTopVendors;
  late final GetVendorsByCountryUseCase _getVendorsByCountry;
  late final SearchVendorsUseCase _searchVendors;

  @override
  void onInit() {
    super.onInit();

    _getVendors = GetVendorsUseCase(repository);
    _getTopVendors=GetTopVendorsUseCase(repository);
    _getVendorsByCountry = GetVendorsByCountryUseCase(repository);
    _searchVendors = SearchVendorsUseCase(repository);

    loadVendors();

    // Listen to search controller changes for real-time search
    searchController.addListener(() {
      // We'll debounce this in the actual search method
      if (searchController.text != searchQuery.value) {
        _performSearch(searchController.text);
      }
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // ================= LOAD =================

  Future<void> loadTopVendors() async {
    try {
      isLoading.value = true;
      error.value = '';

      final result = await _getTopVendors.execute();

      vendors.assignAll(result);
      filteredVendors.assignAll(result);

      _extractCountries(result);
    } catch (e) {
      error.value = e.toString();
      vendors.clear();
      filteredVendors.clear();
    } finally {
      isLoading.value = false;
    }

  }

    Future<void> loadVendors() async {
    try {
      isLoading.value = true;
      error.value = '';

      final result = await _getVendors.execute();

      vendors.assignAll(result);
      filteredVendors.assignAll(result);

      _extractCountries(result);
    } catch (e) {
      error.value = e.toString();
      vendors.clear();
      filteredVendors.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // ================= FILTER =================

  Future<void> setCountryFilter(String country) async {
    if (selectedCountry.value == country) return;

    selectedCountry.value = country;
    searchController.clear(); // Clear search when filtering by country
    searchQuery.value = '';

    if (country.isEmpty) {
      // If no country selected, show all vendors
      filteredVendors.assignAll(vendors);
      return;
    }

    try {
      isLoading.value = true;
      error.value = '';

      final result = await _getVendorsByCountry.execute(country);
      filteredVendors.assignAll(result);
    } catch (e) {
      error.value = e.toString();
      filteredVendors.assignAll(vendors.where((v) => v.organ == country).toList());
    } finally {
      isLoading.value = false;
    }
  }

  // ================= SEARCH =================

  // Real-time search with debouncing
  void _performSearch(String query) {
    // Cancel any previous debounce
    Get.find<VendorController>().searchQuery.value = query;

    // Debounce search to avoid too many API calls
    Future.delayed(const Duration(milliseconds: 300), () {
      if (query == searchQuery.value) {
        _executeSearch(query);
      }
    });
  }

  // Manual search trigger
  Future<void> search(String query) async {
    searchQuery.value = query;
    searchController.text = query;
    await _executeSearch(query);
  }

  // Actual search execution
  Future<void> _executeSearch(String query) async {
    // Clear country filter when searching
    selectedCountry.value = '';

    if (query.isEmpty) {
      filteredVendors.assignAll(vendors);
      return;
    }

    try {
      isLoading.value = true;
      error.value = '';

      final result = await _searchVendors.execute(query);
      filteredVendors.assignAll(result);
    } catch (e) {
      error.value = e.toString();
      // Fallback to local search if API fails
      filteredVendors.assignAll(
          vendors.where((v) =>
          v.name.toLowerCase().contains(query.toLowerCase()) ||
              (v.organ?.toLowerCase().contains(query.toLowerCase()) ?? false)
          ).toList()
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ================= COMBINED FILTERS =================

  Future<void> applyCombinedFilters() async {
    if (selectedCountry.value.isEmpty && searchQuery.value.isEmpty) {
      filteredVendors.assignAll(vendors);
      return;
    }

    try {
      isLoading.value = true;
      error.value = '';

      List<Vendor> result = vendors;

      // Apply country filter
      if (selectedCountry.value.isNotEmpty) {
        result = result.where((v) => v.organ == selectedCountry.value).toList();
      }

      // Apply search filter
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        result = result.where((v) =>
        v.name.toLowerCase().contains(query) ||
            (v.organ?.toLowerCase().contains(query) ?? false)
        ).toList();
      }

      filteredVendors.assignAll(result);
    } catch (e) {
      error.value = e.toString();
      // Fallback to local filtering
      _applyLocalFilters();
    } finally {
      isLoading.value = false;
    }
  }

  void _applyLocalFilters() {
    List<Vendor> result = vendors;

    if (selectedCountry.value.isNotEmpty) {
      result = result.where((v) => v.organ == selectedCountry.value).toList();
    }

    if (searchController.text.isNotEmpty) {
      final query = searchController.text.toLowerCase();
      result = result.where((v) =>
      v.name.toLowerCase().contains(query) ||
          (v.organ?.toLowerCase().contains(query) ?? false)
      ).toList();
    }

    filteredVendors.assignAll(result);
  }

  // ================= CLEAR =================

  void clearFilters() {
    selectedCountry.value = '';
    searchQuery.value = '';
    searchController.clear();

    // Reset to all vendors
    filteredVendors.assignAll(vendors);
    error.value = '';
  }

  void clearSearch() {
    searchQuery.value = '';
    searchController.clear();
    // If country filter is active, maintain it
    if (selectedCountry.value.isNotEmpty) {
      filteredVendors.assignAll(
          vendors.where((v) => v.organ == selectedCountry.value).toList()
      );
    } else {
      filteredVendors.assignAll(vendors);
    }
  }

  void clearCountryFilter() {
    selectedCountry.value = '';
    // If search is active, maintain it
    if (searchQuery.value.isNotEmpty) {
      _executeSearch(searchQuery.value);
    } else {
      filteredVendors.assignAll(vendors);
    }
  }

  // ================= HELPERS =================

  void _extractCountries(List<Vendor> list) {
    final uniqueCountries = list
        .map((e) => e.organ)
        .whereType<String>()
        .where((country) => country.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    countries.assignAll(uniqueCountries);
  }

  // Vendor statistics
  int get totalVendors => vendors.length;
  int get filteredVendorCount => filteredVendors.length;

  bool get hasActiveFilters =>
      selectedCountry.value.isNotEmpty || searchQuery.value.isNotEmpty;

  // ================= NAVIGATION =================
// In vendor_controller.dart
  void selectVendor(String id) {
    // Check if id is valid before navigating
    if (id.isEmpty) {
      Get.snackbar('Error', 'Invalid vendor ID',
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    // Navigate to vendor details
    Get.toNamed('/vendor/$id');
  }

  // ================= REFRESH =================

  Future<void> refreshVendors() async {
    await loadVendors();
  }

  // ================= UTILITY =================

  /// Get vendors by country for the filter chips
  List<Vendor> getVendorsByCountry(String country) {
    return vendors.where((v) => v.organ == country).toList();
  }

  /// Get vendor by ID
  Vendor? getVendorById(String id) {
    try {
      return vendors.firstWhere((vendor) => vendor.id == id);
    } catch (e) {
      return null;
    }
  }
}
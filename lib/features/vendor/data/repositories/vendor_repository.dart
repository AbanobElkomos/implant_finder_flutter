import '../../domain/models/vendor.dart';

abstract class VendorRepository {
  // ================= READ =================

  Future<List<Vendor>> getVendors();

  Future<Vendor> getVendorById(String id);

  Future<List<Vendor>> searchVendors(String query);

  /// ✅ REQUIRED (was missing)
  Future<List<Vendor>> getVendorsByCountry(String country);

  // ================= WRITE =================

  Future<Vendor> createVendor(Vendor vendor);

  Future<Vendor> updateVendor(Vendor vendor);

  Future<void> deleteVendor(String id);
}

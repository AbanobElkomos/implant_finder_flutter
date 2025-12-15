import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/vendor.dart';
import 'vendor_repository.dart';

class VendorRepositoryImpl implements VendorRepository {
  final SupabaseClient supabase;

  VendorRepositoryImpl(this.supabase);

  // ================= GET ALL =================
  @override
  Future<List<Vendor>> getVendors() async {
    try {
      final response = await supabase
          .from('vendors')
          .select()
          .order('name');

      return (response as List)
          .map((json) => Vendor.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch vendors: $e');
    }
  }

  // ================= GET BY ID =================
  @override
  Future<Vendor> getVendorById(String id) async {
    try {
      final response = await supabase
          .from('vendors')
          .select()
          .eq('id', id)
          .single();

      return Vendor.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch vendor: $e');
    }
  }

  // ================= SEARCH =================
  @override
  Future<List<Vendor>> searchVendors(String query) async {
    try {
      final response = await supabase
          .from('vendors')
          .select()
          .ilike('name', '%$query%')
          .order('name');

      return (response as List)
          .map((json) => Vendor.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to search vendors: $e');
    }
  }

  // ================= FILTER BY COUNTRY =================
  @override
  Future<List<Vendor>> getVendorsByCountry(String country) async {
    try {
      final response = await supabase
          .from('vendors')
          .select()
          .eq('organ', country) // country column
          .order('name');

      return (response as List)
          .map((json) => Vendor.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch vendors by country: $e');
    }
  }

  // ================= CREATE =================
  @override
  Future<Vendor> createVendor(Vendor vendor) async {
    try {
      final data = vendor.toJson();
      data.remove('id'); // Supabase generates it

      final response = await supabase
          .from('vendors')
          .insert(data)
          .select()
          .single();

      return Vendor.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create vendor: $e');
    }
  }

  // ================= UPDATE =================
  @override
  Future<Vendor> updateVendor(Vendor vendor) async {
    try {
      final response = await supabase
          .from('vendors')
          .update(vendor.toJson())
          .eq('id', vendor.id)
          .select()
          .single();

      return Vendor.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update vendor: $e');
    }
  }

  // ================= DELETE =================
  @override
  Future<void> deleteVendor(String id) async {
    try {
      await supabase
          .from('vendors')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete vendor: $e');
    }
  }
}

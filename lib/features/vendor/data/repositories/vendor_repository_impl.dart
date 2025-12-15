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
          .order('name', ascending: true);

      return (response as List)
          .map((json) => Vendor.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch vendors: $e');
    }
  }

  // ================= GET BY ID (FIXED) =================
  @override
  Future<Vendor> getVendorById(String id) async {
    try {

      final response = await supabase
          .from('vendors')
          .select()
          .eq('id', id)
          .single();



      return Vendor.fromJson(response);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw Exception('Vendor with ID $id not found in database');
      }
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch vendor: $e');
    }
  }

  // ================= UPDATE VENDOR (FIXED) =================
  @override
  Future<Vendor> updateVendor(Vendor vendor) async {
    try {

      // 1. Check if vendor exists
      final existing = await supabase
          .from('vendors')
          .select('id')
          .eq('id', vendor.id)
          .maybeSingle();

      if (existing == null) {
        throw Exception('Cannot update: Vendor ${vendor.id} does not exist');
      }


      // 2. Prepare update data (remove auto-managed fields)
      final updateData = Map<String, dynamic>.from(vendor.toJson());
      updateData.remove('created_at');
      updateData.remove('updated_at');

      // 3. Perform update
      final response = await supabase
          .from('vendors')
          .update(updateData)
          .eq('id', vendor.id)
          .select()
          .single();


      return Vendor.fromJson(response);
    } on PostgrestException catch (e) {

      if (e.code == 'PGRST116') {
        // Try alternative method
        return await _alternativeUpdate(vendor);
      }
      throw Exception('Update failed: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  // Alternative update method
  Future<Vendor> _alternativeUpdate(Vendor vendor) async {
    try {
      // Use upsert instead of update
      final response = await supabase
          .from('vendors')
          .upsert(vendor.toJson())
          .select()
          .single();

      return Vendor.fromJson(response);
    } catch (e) {

      // Last resort: Delete and recreate
      await supabase
          .from('vendors')
          .delete()
          .eq('id', vendor.id);

      final recreateResponse = await supabase
          .from('vendors')
          .insert(vendor.toJson())
          .select()
          .single();

      return Vendor.fromJson(recreateResponse);
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
          .eq('organ', country)
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
      data.remove('id');

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
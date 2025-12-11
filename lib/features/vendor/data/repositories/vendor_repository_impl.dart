import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/vendor.dart';

abstract class VendorRepository {
  Future<List<Vendor>> getVendors();
  Future<List<Vendor>> getVendorsByCountry(String country);
  Future<Vendor> getVendorById(String id);
  Future<List<Vendor>> searchVendors(String query);
}

class VendorRepositoryImpl implements VendorRepository {
  final SupabaseClient _supabase;

  VendorRepositoryImpl(this._supabase);

  @override
  Future<List<Vendor>> getVendors() async {
    try {
      final response = await _supabase
          .from('vendors')
          .select('*')
          ;

      print(response.toString()  );
      print("aaa");
      return (response as List)
          .map((json) => Vendor.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch vendors: $e');
    }
  }

  @override
  Future<List<Vendor>> getVendorsByCountry(String country) async {
    try {
      final response = await _supabase
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

  @override
  Future<Vendor> getVendorById(String id) async {
    try {
      final response = await _supabase
          .from('vendors')
          .select()
          .eq('id', id)
          .single();

      return Vendor.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch vendor: $e');
    }
  }

  @override
  Future<List<Vendor>> searchVendors(String query) async {
    try {
      final response = await _supabase
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
}
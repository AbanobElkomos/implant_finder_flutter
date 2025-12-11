import '../../data/repositories/vendor_repository_impl.dart';
import '../models/vendor.dart';

class GetVendorsUseCase {
  final VendorRepository repository;

  GetVendorsUseCase(this.repository);

  Future<List<Vendor>> execute() async {
    return await repository.getVendors();
  }
}

class GetVendorsByCountryUseCase {
  final VendorRepository repository;

  GetVendorsByCountryUseCase(this.repository);

  Future<List<Vendor>> execute(String country) async {
    return await repository.getVendorsByCountry(country);
  }
}
import '../../data/repositories/vendor_repository.dart';
import '../models/vendor.dart';

class GetVendorsByCountryUseCase {
  final VendorRepository repository;

  GetVendorsByCountryUseCase(this.repository);

  Future<List<Vendor>> execute(String country) {
    return repository.getVendorsByCountry(country);
  }
}

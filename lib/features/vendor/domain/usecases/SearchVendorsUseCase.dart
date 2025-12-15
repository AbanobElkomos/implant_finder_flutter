import '../../data/repositories/vendor_repository.dart';
import '../models/vendor.dart';

class SearchVendorsUseCase {
  final VendorRepository repository;

  SearchVendorsUseCase(this.repository);

  Future<List<Vendor>> execute(String query) {
    return repository.searchVendors(query);
  }
}

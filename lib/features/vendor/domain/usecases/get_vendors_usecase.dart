import '../../data/repositories/vendor_repository.dart';
import '../models/vendor.dart';

class GetVendorsUseCase {
  final VendorRepository repository;

  GetVendorsUseCase(this.repository);

  Future<List<Vendor>> execute() {
    return repository.getVendors();
  }
}

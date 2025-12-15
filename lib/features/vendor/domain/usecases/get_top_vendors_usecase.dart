import '../../data/repositories/vendor_repository.dart';
import '../models/vendor.dart';

class GetTopVendorsUseCase {
  final VendorRepository repository;

  GetTopVendorsUseCase(this.repository);

  Future<List<Vendor>> execute() {
    return repository.getTopVendors();
  }
}

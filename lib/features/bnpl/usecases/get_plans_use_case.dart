import '../models/installment_plan.dart';
import '../repository/bnpl_repository.dart';

class GetPlansUseCase {
  const GetPlansUseCase(this._repo);

  final BnplRepository _repo;

  /// Returns parsed plans, or null if repo returns null.
  Future<List<InstallmentPlan>?> call() async {
    final data = await _repo.getPlans();
    return data?.map(InstallmentPlan.fromJson).toList();
  }
}


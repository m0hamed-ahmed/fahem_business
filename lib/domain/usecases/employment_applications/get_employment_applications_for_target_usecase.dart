import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/employment_applications/employment_application_model.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class GetEmploymentApplicationsForTargetUseCase extends BaseUseCase<List<EmploymentApplicationModel>, GetEmploymentApplicationsForTargetParameters> {
  final BaseRepository _baseRepository;

  GetEmploymentApplicationsForTargetUseCase(this._baseRepository);

  @override
  Future<Either<Failure, List<EmploymentApplicationModel>>> call(GetEmploymentApplicationsForTargetParameters parameters) async {
    return await _baseRepository.getEmploymentApplicationsForTarget(parameters);
  }
}

class GetEmploymentApplicationsForTargetParameters {
  final int targetId;
  final String targetName;

  GetEmploymentApplicationsForTargetParameters({required this.targetId, required this.targetName});
}
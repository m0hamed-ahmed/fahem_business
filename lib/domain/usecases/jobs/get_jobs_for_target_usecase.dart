import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/jobs/job_model.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class GetJobsForTargetUseCase extends BaseUseCase<List<JobModel>, GetJobsForTargetParameters> {
  final BaseRepository _baseRepository;

  GetJobsForTargetUseCase(this._baseRepository);

  @override
  Future<Either<Failure, List<JobModel>>> call(GetJobsForTargetParameters parameters) async {
    return await _baseRepository.getJobsForTarget(parameters);
  }
}

class GetJobsForTargetParameters {
  final int targetId;
  final String targetName;

  GetJobsForTargetParameters({required this.targetId, required this.targetName});
}
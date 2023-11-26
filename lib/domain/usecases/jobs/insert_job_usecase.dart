import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/jobs/job_model.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class InsertJobUseCase extends BaseUseCase<JobModel, InsertJobParameters> {
  final BaseRepository _baseRepository;

  InsertJobUseCase(this._baseRepository);

  @override
  Future<Either<Failure, JobModel>> call(InsertJobParameters parameters) async {
    return await _baseRepository.insertJob(parameters);
  }
}

class InsertJobParameters {
  final JobModel jobModel;

  InsertJobParameters({required this.jobModel});
}
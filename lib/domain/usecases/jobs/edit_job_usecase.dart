import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/jobs/job_model.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class EditJobUseCase extends BaseUseCase<JobModel, EditJobParameters> {
  final BaseRepository _baseRepository;

  EditJobUseCase(this._baseRepository);

  @override
  Future<Either<Failure, JobModel>> call(EditJobParameters parameters) async {
    return await _baseRepository.editJob(parameters);
  }
}

class EditJobParameters {
  final JobModel jobModel;

  EditJobParameters({required this.jobModel});
}
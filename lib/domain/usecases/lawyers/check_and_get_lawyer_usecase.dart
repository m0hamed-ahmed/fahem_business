import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/lawyers/lawyer_model.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class CheckAndGetLawyerUseCase extends BaseUseCase<LawyerModel, CheckAndGetLawyerParameters> {
  final BaseRepository _baseRepository;

  CheckAndGetLawyerUseCase(this._baseRepository);

  @override
  Future<Either<Failure, LawyerModel>> call(CheckAndGetLawyerParameters parameters) async {
    return await _baseRepository.checkAndGetLawyer(parameters);
  }
}

class CheckAndGetLawyerParameters {
  final String emailAddress;
  final String password;

  CheckAndGetLawyerParameters({required this.emailAddress, required this.password});
}
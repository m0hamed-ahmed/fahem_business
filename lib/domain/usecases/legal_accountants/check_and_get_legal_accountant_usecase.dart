import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/legal_accountant/legal_account_model.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class CheckAndGetLegalAccountantUseCase extends BaseUseCase<LegalAccountantModel, CheckAndGetLegalAccountantParameters> {
  final BaseRepository _baseRepository;

  CheckAndGetLegalAccountantUseCase(this._baseRepository);

  @override
  Future<Either<Failure, LegalAccountantModel>> call(CheckAndGetLegalAccountantParameters parameters) async {
    return await _baseRepository.checkAndGetLegalAccountant(parameters);
  }
}

class CheckAndGetLegalAccountantParameters {
  final String emailAddress;
  final String password;

  CheckAndGetLegalAccountantParameters({required this.emailAddress, required this.password});
}
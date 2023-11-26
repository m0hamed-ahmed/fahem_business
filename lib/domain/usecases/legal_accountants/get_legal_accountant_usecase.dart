import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/legal_accountant/legal_account_model.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class GetLegalAccountantUseCase extends BaseUseCase<LegalAccountantModel, GetLegalAccountantParameters> {
  final BaseRepository _baseRepository;

  GetLegalAccountantUseCase(this._baseRepository);

  @override
  Future<Either<Failure, LegalAccountantModel>> call(GetLegalAccountantParameters parameters) async {
    return await _baseRepository.getLegalAccountant(parameters);
  }
}

class GetLegalAccountantParameters {
  final int legalAccountantId;

  GetLegalAccountantParameters({required this.legalAccountantId});
}
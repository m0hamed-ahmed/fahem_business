import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/legal_accountant/legal_account_model.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class EditLegalAccountantUseCase extends BaseUseCase<LegalAccountantModel, EditLegalAccountantParameters> {
  final BaseRepository _baseRepository;

  EditLegalAccountantUseCase(this._baseRepository);

  @override
  Future<Either<Failure, LegalAccountantModel>> call(EditLegalAccountantParameters parameters) async {
    return await _baseRepository.editLegalAccountant(parameters);
  }
}

class EditLegalAccountantParameters {
  final LegalAccountantModel legalAccountantModel;

  EditLegalAccountantParameters({required this.legalAccountantModel});
}
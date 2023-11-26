import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/legal_accountant/legal_account_model.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class EditLegalAccountantIdentificationImagesUseCase extends BaseUseCase<LegalAccountantModel, EditLegalAccountantIdentificationImagesParameters> {
  final BaseRepository _baseRepository;

  EditLegalAccountantIdentificationImagesUseCase(this._baseRepository);

  @override
  Future<Either<Failure, LegalAccountantModel>> call(EditLegalAccountantIdentificationImagesParameters parameters) async {
    return await _baseRepository.editLegalAccountantIdentificationImages(parameters);
  }
}

class EditLegalAccountantIdentificationImagesParameters {
  final int legalAccountantId;
  final List<String> identificationImages;

  EditLegalAccountantIdentificationImagesParameters({required this.legalAccountantId, required this.identificationImages});
}
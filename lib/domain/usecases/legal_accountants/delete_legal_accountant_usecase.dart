import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class DeleteLegalAccountantUseCase extends BaseUseCase<void, DeleteLegalAccountantParameters> {
  final BaseRepository _baseRepository;

  DeleteLegalAccountantUseCase(this._baseRepository);

  @override
  Future<Either<Failure, void>> call(DeleteLegalAccountantParameters parameters) async {
    return await _baseRepository.deleteLegalAccountant(parameters);
  }
}

class DeleteLegalAccountantParameters {
  final int legalAccountantId;

  DeleteLegalAccountantParameters({required this.legalAccountantId});
}
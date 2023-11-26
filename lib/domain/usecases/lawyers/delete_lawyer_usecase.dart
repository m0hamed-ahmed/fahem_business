import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class DeleteLawyerUseCase extends BaseUseCase<void, DeleteLawyerParameters> {
  final BaseRepository _baseRepository;

  DeleteLawyerUseCase(this._baseRepository);

  @override
  Future<Either<Failure, void>> call(DeleteLawyerParameters parameters) async {
    return await _baseRepository.deleteLawyer(parameters);
  }
}

class DeleteLawyerParameters {
  final int lawyerId;

  DeleteLawyerParameters({required this.lawyerId});
}
import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class DeletePublicRelationUseCase extends BaseUseCase<void, DeletePublicRelationParameters> {
  final BaseRepository _baseRepository;

  DeletePublicRelationUseCase(this._baseRepository);

  @override
  Future<Either<Failure, void>> call(DeletePublicRelationParameters parameters) async {
    return await _baseRepository.deletePublicRelation(parameters);
  }
}

class DeletePublicRelationParameters {
  final int publicRelationId;

  DeletePublicRelationParameters({required this.publicRelationId});
}
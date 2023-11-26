import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/public_relations/public_relation_model.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class GetPublicRelationUseCase extends BaseUseCase<PublicRelationModel, GetPublicRelationParameters> {
  final BaseRepository _baseRepository;

  GetPublicRelationUseCase(this._baseRepository);

  @override
  Future<Either<Failure, PublicRelationModel>> call(GetPublicRelationParameters parameters) async {
    return await _baseRepository.getPublicRelation(parameters);
  }
}

class GetPublicRelationParameters {
  final int publicRelationId;

  GetPublicRelationParameters({required this.publicRelationId});
}
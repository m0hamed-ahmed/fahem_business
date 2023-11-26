import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/public_relations/public_relation_model.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class InsertPublicRelationUseCase extends BaseUseCase<PublicRelationModel, InsertPublicRelationParameters> {
  final BaseRepository _baseRepository;

  InsertPublicRelationUseCase(this._baseRepository);

  @override
  Future<Either<Failure, PublicRelationModel>> call(InsertPublicRelationParameters parameters) async {
    return await _baseRepository.insertPublicRelation(parameters);
  }
}

class InsertPublicRelationParameters {
  final PublicRelationModel publicRelationModel;

  InsertPublicRelationParameters({required this.publicRelationModel});
}
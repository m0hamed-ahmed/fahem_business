import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/public_relations/public_relation_model.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class EditPublicRelationUseCase extends BaseUseCase<PublicRelationModel, EditPublicRelationParameters> {
  final BaseRepository _baseRepository;

  EditPublicRelationUseCase(this._baseRepository);

  @override
  Future<Either<Failure, PublicRelationModel>> call(EditPublicRelationParameters parameters) async {
    return await _baseRepository.editPublicRelation(parameters);
  }
}

class EditPublicRelationParameters {
  final PublicRelationModel publicRelationModel;

  EditPublicRelationParameters({required this.publicRelationModel});
}
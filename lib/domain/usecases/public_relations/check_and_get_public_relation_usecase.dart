import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/public_relations/public_relation_model.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class CheckAndGetPublicRelationUseCase extends BaseUseCase<PublicRelationModel, CheckAndGetPublicRelationParameters> {
  final BaseRepository _baseRepository;

  CheckAndGetPublicRelationUseCase(this._baseRepository);

  @override
  Future<Either<Failure, PublicRelationModel>> call(CheckAndGetPublicRelationParameters parameters) async {
    return await _baseRepository.checkAndGetPublicRelation(parameters);
  }
}

class CheckAndGetPublicRelationParameters {
  final String emailAddress;
  final String password;

  CheckAndGetPublicRelationParameters({required this.emailAddress, required this.password});
}
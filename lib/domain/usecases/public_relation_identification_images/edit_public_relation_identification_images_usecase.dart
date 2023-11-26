import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/public_relations/public_relation_model.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class EditPublicRelationIdentificationImagesUseCase extends BaseUseCase<PublicRelationModel, EditPublicRelationIdentificationImagesParameters> {
  final BaseRepository _baseRepository;

  EditPublicRelationIdentificationImagesUseCase(this._baseRepository);

  @override
  Future<Either<Failure, PublicRelationModel>> call(EditPublicRelationIdentificationImagesParameters parameters) async {
    return await _baseRepository.editPublicRelationIdentificationImages(parameters);
  }
}

class EditPublicRelationIdentificationImagesParameters {
  final int publicRelationId;
  final List<String> identificationImages;

  EditPublicRelationIdentificationImagesParameters({required this.publicRelationId, required this.identificationImages});
}
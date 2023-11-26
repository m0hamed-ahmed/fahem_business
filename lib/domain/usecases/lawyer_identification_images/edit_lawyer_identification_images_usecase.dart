import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/lawyers/lawyer_model.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class EditLawyerIdentificationImagesUseCase extends BaseUseCase<LawyerModel, EditLawyerIdentificationImagesParameters> {
  final BaseRepository _baseRepository;

  EditLawyerIdentificationImagesUseCase(this._baseRepository);

  @override
  Future<Either<Failure, LawyerModel>> call(EditLawyerIdentificationImagesParameters parameters) async {
    return await _baseRepository.editLawyerIdentificationImages(parameters);
  }
}

class EditLawyerIdentificationImagesParameters {
  final int lawyerId;
  final List<String> identificationImages;

  EditLawyerIdentificationImagesParameters({required this.lawyerId, required this.identificationImages});
}
import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/lawyers/lawyer_model.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class EditLawyerUseCase extends BaseUseCase<LawyerModel, EditLawyerParameters> {
  final BaseRepository _baseRepository;

  EditLawyerUseCase(this._baseRepository);

  @override
  Future<Either<Failure, LawyerModel>> call(EditLawyerParameters parameters) async {
    return await _baseRepository.editLawyer(parameters);
  }
}

class EditLawyerParameters {
  final LawyerModel lawyerModel;

  EditLawyerParameters({required this.lawyerModel});
}
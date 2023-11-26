import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/lawyers/lawyer_model.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class InsertLawyerUseCase extends BaseUseCase<LawyerModel, InsertLawyerParameters> {
  final BaseRepository _baseRepository;

  InsertLawyerUseCase(this._baseRepository);

  @override
  Future<Either<Failure, LawyerModel>> call(InsertLawyerParameters parameters) async {
    return await _baseRepository.insertLawyer(parameters);
  }
}

class InsertLawyerParameters {
  final LawyerModel lawyerModel;

  InsertLawyerParameters({required this.lawyerModel});
}
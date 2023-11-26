import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/lawyers/lawyer_model.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class GetLawyerUseCase extends BaseUseCase<LawyerModel, GetLawyerParameters> {
  final BaseRepository _baseRepository;

  GetLawyerUseCase(this._baseRepository);

  @override
  Future<Either<Failure, LawyerModel>> call(GetLawyerParameters parameters) async {
    return await _baseRepository.getLawyer(parameters);
  }
}

class GetLawyerParameters {
  final int lawyerId;

  GetLawyerParameters({required this.lawyerId});
}
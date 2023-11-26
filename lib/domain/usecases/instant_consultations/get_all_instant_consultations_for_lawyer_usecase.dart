import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/transactions/transaction_model.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class GetAllInstantConsultationsForLawyerUseCase extends BaseUseCase<List<TransactionModel>, GetAllInstantConsultationsForLawyerParameters> {
  final BaseRepository _baseRepository;

  GetAllInstantConsultationsForLawyerUseCase(this._baseRepository);

  @override
  Future<Either<Failure, List<TransactionModel>>> call(GetAllInstantConsultationsForLawyerParameters parameters) async {
    return await _baseRepository.getAllInstantConsultationsForLawyer(parameters);
  }
}

class GetAllInstantConsultationsForLawyerParameters {
  final int lawyerId;

  GetAllInstantConsultationsForLawyerParameters({required this.lawyerId});
}
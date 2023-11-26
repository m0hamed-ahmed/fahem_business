import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/transactions/transaction_model.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class GetRequestThePhoneNumberForTargetUseCase extends BaseUseCase<List<TransactionModel>, GetRequestThePhoneNumberForTargetParameters> {
  final BaseRepository _baseRepository;

  GetRequestThePhoneNumberForTargetUseCase(this._baseRepository);

  @override
  Future<Either<Failure, List<TransactionModel>>> call(GetRequestThePhoneNumberForTargetParameters parameters) async {
    return await _baseRepository.getRequestThePhoneNumberForTarget(parameters);
  }
}

class GetRequestThePhoneNumberForTargetParameters {
  final int targetId;
  final String transactionType;

  GetRequestThePhoneNumberForTargetParameters({required this.targetId, required this.transactionType});
}
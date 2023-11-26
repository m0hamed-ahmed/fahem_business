import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/transactions/transaction_model.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class GetBookingAppointmentsForTargetUseCase extends BaseUseCase<List<TransactionModel>, GetBookingAppointmentsForTargetParameters> {
  final BaseRepository _baseRepository;

  GetBookingAppointmentsForTargetUseCase(this._baseRepository);

  @override
  Future<Either<Failure, List<TransactionModel>>> call(GetBookingAppointmentsForTargetParameters parameters) async {
    return await _baseRepository.getBookingAppointmentsForTarget(parameters);
  }
}

class GetBookingAppointmentsForTargetParameters {
  final int targetId;
  final String transactionType;

  GetBookingAppointmentsForTargetParameters({required this.targetId, required this.transactionType});
}
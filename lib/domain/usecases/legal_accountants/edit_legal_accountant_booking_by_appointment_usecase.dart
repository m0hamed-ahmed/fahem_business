import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/legal_accountant/legal_account_model.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class EditLegalAccountantBookingByAppointmentUseCase extends BaseUseCase<LegalAccountantModel, EditLegalAccountantBookingByAppointmentParameters> {
  final BaseRepository _baseRepository;

  EditLegalAccountantBookingByAppointmentUseCase(this._baseRepository);

  @override
  Future<Either<Failure, LegalAccountantModel>> call(EditLegalAccountantBookingByAppointmentParameters parameters) async {
    return await _baseRepository.editLegalAccountantBookingByAppointment(parameters);
  }
}

class EditLegalAccountantBookingByAppointmentParameters {
  final int legalAccountantId;
  final bool isBookingByAppointment;
  final List<String> availablePeriods;

  EditLegalAccountantBookingByAppointmentParameters({
    required this.legalAccountantId,
    required this.isBookingByAppointment,
    required this.availablePeriods,
  });
}
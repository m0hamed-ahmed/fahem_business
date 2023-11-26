import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/lawyers/lawyer_model.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class EditLawyerBookingByAppointmentUseCase extends BaseUseCase<LawyerModel, EditLawyerBookingByAppointmentParameters> {
  final BaseRepository _baseRepository;

  EditLawyerBookingByAppointmentUseCase(this._baseRepository);

  @override
  Future<Either<Failure, LawyerModel>> call(EditLawyerBookingByAppointmentParameters parameters) async {
    return await _baseRepository.editLawyerBookingByAppointment(parameters);
  }
}

class EditLawyerBookingByAppointmentParameters {
  final int lawyerId;
  final bool isBookingByAppointment;
  final List<String> availablePeriods;

  EditLawyerBookingByAppointmentParameters({
    required this.lawyerId,
    required this.isBookingByAppointment,
    required this.availablePeriods,
  });
}
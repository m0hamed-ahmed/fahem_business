import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/public_relations/public_relation_model.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class EditPublicRelationBookingByAppointmentUseCase extends BaseUseCase<PublicRelationModel, EditPublicRelationBookingByAppointmentParameters> {
  final BaseRepository _baseRepository;

  EditPublicRelationBookingByAppointmentUseCase(this._baseRepository);

  @override
  Future<Either<Failure, PublicRelationModel>> call(EditPublicRelationBookingByAppointmentParameters parameters) async {
    return await _baseRepository.editPublicRelationBookingByAppointment(parameters);
  }
}

class EditPublicRelationBookingByAppointmentParameters {
  final int publicRelationId;
  final bool isBookingByAppointment;
  final List<String> availablePeriods;

  EditPublicRelationBookingByAppointmentParameters({
    required this.publicRelationId,
    required this.isBookingByAppointment,
    required this.availablePeriods,
  });
}
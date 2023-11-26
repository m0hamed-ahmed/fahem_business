import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class IsAllLawyerDataValidUseCase extends BaseUseCase<bool, IsAllLawyerDataValidParameters> {
  final BaseRepository _baseRepository;

  IsAllLawyerDataValidUseCase(this._baseRepository);

  @override
  Future<Either<Failure, bool>> call(IsAllLawyerDataValidParameters parameters) async {
    return await _baseRepository.isAllLawyerDataValid(parameters);
  }
}

class IsAllLawyerDataValidParameters {
  final String emailAddress;
  final String password;
  final String phoneNumber;

  IsAllLawyerDataValidParameters({required this.emailAddress, required this.password, required this.phoneNumber});
}
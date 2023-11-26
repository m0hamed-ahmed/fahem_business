import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class IsAllLegalAccountantDataValidUseCase extends BaseUseCase<bool, IsAllLegalAccountantDataValidParameters> {
  final BaseRepository _baseRepository;

  IsAllLegalAccountantDataValidUseCase(this._baseRepository);

  @override
  Future<Either<Failure, bool>> call(IsAllLegalAccountantDataValidParameters parameters) async {
    return await _baseRepository.isAllLegalAccountantDataValid(parameters);
  }
}

class IsAllLegalAccountantDataValidParameters {
  final String emailAddress;
  final String password;
  final String phoneNumber;

  IsAllLegalAccountantDataValidParameters({required this.emailAddress, required this.password, required this.phoneNumber});
}
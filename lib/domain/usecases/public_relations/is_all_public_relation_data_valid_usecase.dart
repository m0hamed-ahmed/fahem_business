import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class IsAllPublicRelationDataValidUseCase extends BaseUseCase<bool, IsAllPublicRelationDataValidParameters> {
  final BaseRepository _baseRepository;

  IsAllPublicRelationDataValidUseCase(this._baseRepository);

  @override
  Future<Either<Failure, bool>> call(IsAllPublicRelationDataValidParameters parameters) async {
    return await _baseRepository.isAllPublicRelationDataValid(parameters);
  }
}

class IsAllPublicRelationDataValidParameters {
  final String emailAddress;
  final String password;
  final String phoneNumber;

  IsAllPublicRelationDataValidParameters({required this.emailAddress, required this.password, required this.phoneNumber});
}
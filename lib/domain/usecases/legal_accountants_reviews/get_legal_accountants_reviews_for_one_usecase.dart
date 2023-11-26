import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/legal_accountants_reviews/legal_account_review_model.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class GetLegalAccountantReviewsForOneUseCase extends BaseUseCase<List<LegalAccountantReviewModel>, GetLegalAccountantReviewsForOneParameters> {
  final BaseRepository _baseRepository;

  GetLegalAccountantReviewsForOneUseCase(this._baseRepository);

  @override
  Future<Either<Failure, List<LegalAccountantReviewModel>>> call(GetLegalAccountantReviewsForOneParameters parameters) async {
    return await _baseRepository.getLegalAccountantReviewsForOne(parameters);
  }
}

class GetLegalAccountantReviewsForOneParameters {
  final int legalAccountantId;

  GetLegalAccountantReviewsForOneParameters({required this.legalAccountantId});
}
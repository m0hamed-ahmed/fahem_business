import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/lawyers_reviews/lawyer_review_model.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class GetLawyerReviewsForOneUseCase extends BaseUseCase<List<LawyerReviewModel>, GetLawyerReviewsForOneParameters> {
  final BaseRepository _baseRepository;

  GetLawyerReviewsForOneUseCase(this._baseRepository);

  @override
  Future<Either<Failure, List<LawyerReviewModel>>> call(GetLawyerReviewsForOneParameters parameters) async {
    return await _baseRepository.getLawyerReviewsForOne(parameters);
  }
}

class GetLawyerReviewsForOneParameters {
  final int lawyerId;

  GetLawyerReviewsForOneParameters({required this.lawyerId});
}
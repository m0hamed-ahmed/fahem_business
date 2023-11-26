import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/public_relations_reviews/public_relation_review_model.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class GetPublicRelationsReviewsForOneUseCase extends BaseUseCase<List<PublicRelationReviewModel>, GetPublicRelationsReviewsForOneParameters> {
  final BaseRepository _baseRepository;

  GetPublicRelationsReviewsForOneUseCase(this._baseRepository);

  @override
  Future<Either<Failure, List<PublicRelationReviewModel>>> call(GetPublicRelationsReviewsForOneParameters parameters) async {
    return await _baseRepository.getPublicRelationsReviewsForOne(parameters);
  }
}

class GetPublicRelationsReviewsForOneParameters {
  final int publicRelationId;

  GetPublicRelationsReviewsForOneParameters({required this.publicRelationId});
}
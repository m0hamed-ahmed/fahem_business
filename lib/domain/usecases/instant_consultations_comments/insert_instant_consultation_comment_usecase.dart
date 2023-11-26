import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/instant_consultations_comments/instant_consultation_comment_model.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class InsertInstantConsultationCommentUseCase extends BaseUseCase<InstantConsultationCommentModel, InsertInstantConsultationCommentParameters> {
  final BaseRepository _baseRepository;

  InsertInstantConsultationCommentUseCase(this._baseRepository);

  @override
  Future<Either<Failure, InstantConsultationCommentModel>> call(InsertInstantConsultationCommentParameters parameters) async {
    return await _baseRepository.insertInstantConsultationComment(parameters);
  }
}

class InsertInstantConsultationCommentParameters {
  final InstantConsultationCommentModel instantConsultationCommentModel;

  InsertInstantConsultationCommentParameters({required this.instantConsultationCommentModel});
}
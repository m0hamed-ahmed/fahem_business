import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/public_relations_categories/public_relation_category_model.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class GetAllPublicRelationsCategoriesUseCase extends BaseUseCase<List<PublicRelationCategoryModel>, NoParameters> {
  final BaseRepository _baseRepository;

  GetAllPublicRelationsCategoriesUseCase(this._baseRepository);

  @override
  Future<Either<Failure, List<PublicRelationCategoryModel>>> call(NoParameters parameters) async {
    return await _baseRepository.getAllPublicRelationsCategories();
  }
}
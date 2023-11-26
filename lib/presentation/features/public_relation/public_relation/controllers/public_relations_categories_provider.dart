import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/core/utils/dialogs.dart';
import 'package:fahem_business/data/models/public_relations_categories/public_relation_category_model.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';
import 'package:fahem_business/domain/usecases/public_relations_categories/get_all_public_relations_categories_usecase.dart';
import 'package:flutter/material.dart';

class PublicRelationsCategoriesProvider with ChangeNotifier {
  final GetAllPublicRelationsCategoriesUseCase _getAllPublicRelationsCategoriesUseCase;

  PublicRelationsCategoriesProvider(this._getAllPublicRelationsCategoriesUseCase);

  Future<Either<Failure, List<PublicRelationCategoryModel>>> _getAllPublicRelationsCategoriesImpl() async {
    return await _getAllPublicRelationsCategoriesUseCase.call(const NoParameters());
  }

  List<PublicRelationCategoryModel> _publicRelationsCategories = [];
  List<PublicRelationCategoryModel> get publicRelationsCategories => _publicRelationsCategories;
  setPublicRelationsCategories(List<PublicRelationCategoryModel> publicRelationsCategories) => _publicRelationsCategories = publicRelationsCategories;

  Future<void> getAllPublicRelationsCategories(BuildContext context) async {
    if(_publicRelationsCategories.isNotEmpty) return;
    Either<Failure, List<PublicRelationCategoryModel>> response = await _getAllPublicRelationsCategoriesImpl();
    response.fold((failure) async {
      Dialogs.failureOccurred(context, failure);
    }, (publicRelationsCategories) async {
      setPublicRelationsCategories(publicRelationsCategories);
    });
  }
}
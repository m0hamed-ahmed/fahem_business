import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/core/utils/dialogs.dart';
import 'package:fahem_business/data/models/lawyers_categories/lawyer_category_model.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';
import 'package:fahem_business/domain/usecases/lawyers_categories/get_all_lawyers_categories_usecase.dart';
import 'package:flutter/material.dart';

class LawyersCategoriesProvider with ChangeNotifier {
  final GetAllLawyersCategoriesUseCase _getAllLawyersCategoriesUseCase;

  LawyersCategoriesProvider(this._getAllLawyersCategoriesUseCase);

  Future<Either<Failure, List<LawyerCategoryModel>>> _getAllLawyersCategoriesImpl() async {
    return await _getAllLawyersCategoriesUseCase.call(const NoParameters());
  }

  List<LawyerCategoryModel> _lawyersCategories = [];
  List<LawyerCategoryModel> get lawyersCategories => _lawyersCategories;
  setLawyersCategories(List<LawyerCategoryModel> lawyersCategories) => _lawyersCategories = lawyersCategories;

  Future<void> getAllLawyersCategories(BuildContext context) async {
    if(_lawyersCategories.isNotEmpty) return;
    Either<Failure, List<LawyerCategoryModel>> response = await _getAllLawyersCategoriesImpl();
    response.fold((failure) async {
      await Dialogs.failureOccurred(context, failure);
    }, (lawyersCategories) async {
      setLawyersCategories(lawyersCategories);
    });
  }
}
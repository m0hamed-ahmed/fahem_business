import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/lawyers/lawyer_model.dart';
import 'package:fahem_business/domain/usecases/lawyers/check_and_get_lawyer_usecase.dart';
import 'package:fahem_business/domain/usecases/lawyers/delete_lawyer_usecase.dart';
import 'package:fahem_business/domain/usecases/lawyers/get_lawyer_usecase.dart';
import 'package:fahem_business/domain/usecases/lawyers/insert_lawyer_usecase.dart';
import 'package:fahem_business/domain/usecases/lawyers/is_all_lawyer_data_valid_usecase.dart';
import 'package:flutter/material.dart';

class LawyerProvider with ChangeNotifier {
  final CheckAndGetLawyerUseCase _checkAndGetLawyerUseCase;
  final GetLawyerUseCase _getLawyerUseCase;
  final IsAllLawyerDataValidUseCase _isAllLawyerDataValidUseCase;
  final InsertLawyerUseCase _insertLawyerUseCase;
  final DeleteLawyerUseCase _deleteLawyerUseCase;

  LawyerProvider(
    this._checkAndGetLawyerUseCase,
    this._getLawyerUseCase,
    this._isAllLawyerDataValidUseCase,
    this._insertLawyerUseCase,
    this._deleteLawyerUseCase,
  );

  Future<Either<Failure, LawyerModel>> checkAndGetLawyerImpl(CheckAndGetLawyerParameters parameters) async {
    return await _checkAndGetLawyerUseCase.call(parameters);
  }

  Future<Either<Failure, LawyerModel>> getLawyerImpl(GetLawyerParameters parameters) async {
    return await _getLawyerUseCase.call(parameters);
  }

  Future<Either<Failure, bool>> isAllLawyerDataValidImpl(IsAllLawyerDataValidParameters parameters) async {
    return await _isAllLawyerDataValidUseCase.call(parameters);
  }

  Future<Either<Failure, LawyerModel>> insertLawyerImpl(InsertLawyerParameters parameters) async {
    return await _insertLawyerUseCase.call(parameters);
  }

  Future<Either<Failure, void>> deleteLawyerImpl(DeleteLawyerParameters parameters) async {
    return await _deleteLawyerUseCase.call(parameters);
  }

  late LawyerModel _lawyer;
  LawyerModel get lawyer => _lawyer;
  setLawyer(LawyerModel lawyer) => _lawyer = lawyer;
  changeLawyer(LawyerModel lawyer) {_lawyer = lawyer; notifyListeners();}
}
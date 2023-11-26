import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/legal_accountant/legal_account_model.dart';
import 'package:fahem_business/domain/usecases/legal_accountants/check_and_get_legal_accountant_usecase.dart';
import 'package:fahem_business/domain/usecases/legal_accountants/delete_legal_accountant_usecase.dart';
import 'package:fahem_business/domain/usecases/legal_accountants/get_legal_accountant_usecase.dart';
import 'package:fahem_business/domain/usecases/legal_accountants/insert_legal_accountant_usecase.dart';
import 'package:fahem_business/domain/usecases/legal_accountants/is_all_legal_accountant_data_valid_usecase.dart';
import 'package:flutter/material.dart';

class LegalAccountantProvider with ChangeNotifier {
  final CheckAndGetLegalAccountantUseCase _checkAndGetLegalAccountantUseCase;
  final GetLegalAccountantUseCase _getLegalAccountantUseCase;
  final IsAllLegalAccountantDataValidUseCase _isAllLegalAccountantDataValidUseCase;
  final InsertLegalAccountantUseCase _insertLegalAccountantUseCase;
  final DeleteLegalAccountantUseCase _deleteLegalAccountantUseCase;

  LegalAccountantProvider(
    this._checkAndGetLegalAccountantUseCase,
    this._getLegalAccountantUseCase,
    this._isAllLegalAccountantDataValidUseCase,
    this._insertLegalAccountantUseCase,
    this._deleteLegalAccountantUseCase,
  );

  Future<Either<Failure, LegalAccountantModel>> checkAndGetLegalAccountantImpl(CheckAndGetLegalAccountantParameters parameters) async {
    return await _checkAndGetLegalAccountantUseCase.call(parameters);
  }

  Future<Either<Failure, LegalAccountantModel>> getLegalAccountantImpl(GetLegalAccountantParameters parameters) async {
    return await _getLegalAccountantUseCase.call(parameters);
  }

  Future<Either<Failure, bool>> isAllLegalAccountantDataValidImpl(IsAllLegalAccountantDataValidParameters parameters) async {
    return await _isAllLegalAccountantDataValidUseCase.call(parameters);
  }

  Future<Either<Failure, LegalAccountantModel>> insertLegalAccountantImpl(InsertLegalAccountantParameters parameters) async {
    return await _insertLegalAccountantUseCase.call(parameters);
  }

  Future<Either<Failure, void>> deleteLegalAccountantImpl(DeleteLegalAccountantParameters parameters) async {
    return await _deleteLegalAccountantUseCase.call(parameters);
  }

  late LegalAccountantModel _legalAccountant;
  LegalAccountantModel get legalAccountant => _legalAccountant;
  setLegalAccountant(LegalAccountantModel legalAccountant) => _legalAccountant = legalAccountant;
  changeLegalAccountant(LegalAccountantModel legalAccountant) {_legalAccountant = legalAccountant; notifyListeners();}
}
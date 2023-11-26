import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/public_relations/public_relation_model.dart';
import 'package:fahem_business/domain/usecases/public_relations/check_and_get_public_relation_usecase.dart';
import 'package:fahem_business/domain/usecases/public_relations/delete_public_relation_usecase.dart';
import 'package:fahem_business/domain/usecases/public_relations/get_public_relation_usecase.dart';
import 'package:fahem_business/domain/usecases/public_relations/insert_public_relation_usecase.dart';
import 'package:fahem_business/domain/usecases/public_relations/is_all_public_relation_data_valid_usecase.dart';
import 'package:flutter/material.dart';

class PublicRelationProvider with ChangeNotifier {
  final CheckAndGetPublicRelationUseCase _checkAndGetPublicRelationUseCase;
  final GetPublicRelationUseCase _getPublicRelationUseCase;
  final IsAllPublicRelationDataValidUseCase _isAllPublicRelationDataValidUseCase;
  final InsertPublicRelationUseCase _insertPublicRelationUseCase;
  final DeletePublicRelationUseCase _deletePublicRelationUseCase;

  PublicRelationProvider(
    this._checkAndGetPublicRelationUseCase, 
    this._getPublicRelationUseCase,
    this._isAllPublicRelationDataValidUseCase,
    this._insertPublicRelationUseCase,
    this._deletePublicRelationUseCase,
  );

  Future<Either<Failure, PublicRelationModel>> checkAndGetPublicRelationImpl(CheckAndGetPublicRelationParameters parameters) async {
    return await _checkAndGetPublicRelationUseCase.call(parameters);
  }

  Future<Either<Failure, PublicRelationModel>> getPublicRelationImpl(GetPublicRelationParameters parameters) async {
    return await _getPublicRelationUseCase.call(parameters);
  }

  Future<Either<Failure, bool>> isAllPublicRelationDataValidImpl(IsAllPublicRelationDataValidParameters parameters) async {
    return await _isAllPublicRelationDataValidUseCase.call(parameters);
  }

  Future<Either<Failure, PublicRelationModel>> insertPublicRelationImpl(InsertPublicRelationParameters parameters) async {
    return await _insertPublicRelationUseCase.call(parameters);
  }

  Future<Either<Failure, void>> deletePublicRelationImpl(DeletePublicRelationParameters parameters) async {
    return await _deletePublicRelationUseCase.call(parameters);
  }

  late PublicRelationModel _publicRelation;
  PublicRelationModel get publicRelation => _publicRelation;
  setPublicRelation(PublicRelationModel publicRelation) => _publicRelation = publicRelation;
  changePublicRelation(PublicRelationModel publicRelation) {_publicRelation = publicRelation; notifyListeners();}
}
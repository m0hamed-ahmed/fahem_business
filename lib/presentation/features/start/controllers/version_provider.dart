import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/version/version_model.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';
import 'package:fahem_business/domain/usecases/version/get_version_usecase.dart';
import 'package:flutter/material.dart';

class VersionProvider with ChangeNotifier {
  final GetVersionUseCase _getVersionUseCase;

  VersionProvider(this._getVersionUseCase);

  Future<Either<Failure, VersionModel>> getVersionImpl() async {
    return await _getVersionUseCase.call(const NoParameters());
  }
}
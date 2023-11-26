import 'dart:convert';
import 'package:fahem_business/core/resources/colors_manager.dart';
import 'package:fahem_business/core/utils/cache_helper.dart';
import 'package:fahem_business/core/utils/enums.dart';
import 'package:fahem_business/data/models/lawyers/lawyer_model.dart';
import 'package:fahem_business/data/models/legal_accountant/legal_account_model.dart';
import 'package:fahem_business/data/models/public_relations/public_relation_model.dart';
import 'package:fahem_business/presentation/features/start/controllers/splash_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainProvider with ChangeNotifier {

  String getNameFromAccount(BuildContext context) {
    String accountType = CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT_TYPE);
    String accountCached = CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT);

    if(accountType == AccountTypeEnum.lawyers.name) {
      LawyerModel lawyerModel = LawyerModel.fromJson(json.decode(accountCached));
      return lawyerModel.name;
    }
    else if(accountType == AccountTypeEnum.publicRelations.name) {
      PublicRelationModel publicRelationModel = PublicRelationModel.fromJson(json.decode(accountCached));
      return publicRelationModel.name;
    }
    else {
      LegalAccountantModel legalAccountantModel = LegalAccountantModel.fromJson(json.decode(accountCached));
      return legalAccountantModel.name;
    }
  }

  bool getIsVerifiedFromAccount(BuildContext context) {
    String accountType = CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT_TYPE);
    String accountCached = CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT);

    if(accountType == AccountTypeEnum.lawyers.name) {
      LawyerModel lawyerModel = LawyerModel.fromJson(json.decode(accountCached));
      return lawyerModel.isVerified;
    }
    else if(accountType == AccountTypeEnum.publicRelations.name) {
      PublicRelationModel publicRelationModel = PublicRelationModel.fromJson(json.decode(accountCached));
      return publicRelationModel.isVerified;
    }
    else {
      LegalAccountantModel legalAccountantModel = LegalAccountantModel.fromJson(json.decode(accountCached));
      return legalAccountantModel.isVerified;
    }
  }

  AccountStatus getAccountStatus(BuildContext context) {
    String accountType = CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT_TYPE);
    String accountCached = CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT);

    if(accountType == AccountTypeEnum.lawyers.name) {
      LawyerModel lawyerModel = LawyerModel.fromJson(json.decode(accountCached));
      return lawyerModel.accountStatus;
    }
    else if(accountType == AccountTypeEnum.publicRelations.name) {
      PublicRelationModel publicRelationModel = PublicRelationModel.fromJson(json.decode(accountCached));
      return publicRelationModel.accountStatus;
    }
    else {
      LegalAccountantModel legalAccountantModel = LegalAccountantModel.fromJson(json.decode(accountCached));
      return legalAccountantModel.accountStatus;
    }
  }

  int getIdentificationImagesLength(BuildContext context) {
    String accountType = CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT_TYPE);
    String accountCached = CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT);

    if(accountType == AccountTypeEnum.lawyers.name) {
      LawyerModel lawyerModel = LawyerModel.fromJson(json.decode(accountCached));
      return lawyerModel.identificationImages.length;
    }
    else if(accountType == AccountTypeEnum.publicRelations.name) {
      PublicRelationModel publicRelationModel = PublicRelationModel.fromJson(json.decode(accountCached));
      return publicRelationModel.identificationImages.length;
    }
    else {
      LegalAccountantModel legalAccountantModel = LegalAccountantModel.fromJson(json.decode(accountCached));
      return legalAccountantModel.identificationImages.length;
    }
  }

  Color getStatusColor(BuildContext context) {
    return getAccountStatus(context) == AccountStatus.pending
        ? ColorsManager.orange
        : getAccountStatus(context) == AccountStatus.acceptable
          ? ColorsManager.green
          : ColorsManager.red;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  changeIsLoading(bool isLoading) {_isLoading = isLoading; notifyListeners();}

  Future<void> onRefresh(BuildContext context) async {
    SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    changeIsLoading(true);
    await splashProvider.getData(context: context, isSwipeRefresh: true);
    changeIsLoading(false);
  }
}
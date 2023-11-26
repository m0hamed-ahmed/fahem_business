import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/core/network/firebase_constants.dart';
import 'package:fahem_business/core/resources/constants_manager.dart';
import 'package:fahem_business/core/resources/routes_manager.dart';
import 'package:fahem_business/core/services/notification_service.dart';
import 'package:fahem_business/core/utils/cache_helper.dart';
import 'package:fahem_business/core/utils/dialogs.dart';
import 'package:fahem_business/core/utils/enums.dart';
import 'package:fahem_business/data/models/lawyers/lawyer_model.dart';
import 'package:fahem_business/data/models/legal_accountant/legal_account_model.dart';
import 'package:fahem_business/data/models/public_relations/public_relation_model.dart';
import 'package:fahem_business/data/models/static/account_type_model.dart';
import 'package:fahem_business/domain/usecases/lawyers/check_and_get_lawyer_usecase.dart';
import 'package:fahem_business/domain/usecases/legal_accountants/check_and_get_legal_accountant_usecase.dart';
import 'package:fahem_business/domain/usecases/public_relations/check_and_get_public_relation_usecase.dart';
import 'package:fahem_business/presentation/features/lawyer/lawyer/controllers/lawyer_provider.dart';
import 'package:fahem_business/presentation/features/legal_accountant/legal_accountant/controllers/legal_accountant_provider.dart';
import 'package:fahem_business/presentation/features/public_relation/public_relation/controllers/public_relation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginProvider with ChangeNotifier {

  AccountTypeModel? _accountTypeModel;
  AccountTypeModel? get accountTypeModel => _accountTypeModel;
  changeAccountTypeModel(AccountTypeModel? accountTypeModel) {_accountTypeModel = accountTypeModel; notifyListeners();}

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  changeIsLoading(bool isLoading) {_isLoading = isLoading; notifyListeners();}

  bool _isButtonClicked = false;
  bool get isButtonClicked => _isButtonClicked;
  setIsButtonClicked(bool isButtonClicked) => _isButtonClicked = isButtonClicked;
  changeIsButtonClicked(bool isButtonClicked) {_isButtonClicked = isButtonClicked; notifyListeners();}

  bool _isShowPassword = false;
  bool get isShowPassword => _isShowPassword;
  setIsShowPassword(bool isShowPassword) => _isShowPassword = isShowPassword;
  changeIsShowPassword() {_isShowPassword = !_isShowPassword; notifyListeners();}

  bool isAllValid() {
    if(_accountTypeModel == null) {return false;}
    return true;
  }

  void resetAllData() {
    setIsButtonClicked(false);
    setIsShowPassword(false);
  }

  Future<void> checkAndGetAccount({required BuildContext context, required String emailAddress, required String password}) async {
    changeIsLoading(true);

    if(_accountTypeModel!.accountType == AccountTypeEnum.lawyers.name) {
      LawyerProvider lawyerProvider = Provider.of<LawyerProvider>(context, listen: false);

      // Check And Get Lawyer
      CheckAndGetLawyerParameters parameters = CheckAndGetLawyerParameters(
        emailAddress: emailAddress,
        password: password,
      );
      Either<Failure, LawyerModel> response = await lawyerProvider.checkAndGetLawyerImpl(parameters);
      response.fold((failure) async {
        changeIsLoading(false);
        Dialogs.failureOccurred(context, failure);
      }, (lawyer) async {
        await NotificationService.subscribeToTopic(FirebaseConstants.fahemBusinessTopic).then((value) async {
          await NotificationService.subscribeToTopic('${lawyer.lawyerId}${ConstantsManager.fahemBusinessLawyersKeyword}').then((value) {
            if(lawyer.isSubscriberToInstantConsultationService) NotificationService.subscribeToTopic(FirebaseConstants.instantConsultationsTopic);
            NotificationService.createLocalNotification(title: 'اهلا ${lawyer.name}', body: 'مرحبا بك فى فاهم نحن سعداء بتواجدك معنا');
            changeIsLoading(false);
            CacheHelper.setData(key: PREFERENCES_KEY_IS_LOGGED, value: true);
            CacheHelper.setData(key: PREFERENCES_KEY_ACCOUNT_TYPE, value: _accountTypeModel!.accountType);
            CacheHelper.setData(key: PREFERENCES_KEY_ACCOUNT, value: json.encode(LawyerModel.toMap(lawyer)));
            lawyerProvider.changeLawyer(lawyer);
            resetAllData();
            Navigator.pushReplacementNamed(context, Routes.splashRoute);
          }).catchError((error) {
            changeIsLoading(false);
          });
        }).catchError((error) {
          changeIsLoading(false);
        });
      });
    }
    else if(_accountTypeModel!.accountType == AccountTypeEnum.publicRelations.name) {
      PublicRelationProvider publicRelationProvider = Provider.of<PublicRelationProvider>(context, listen: false);

      // Check And Get Public Relation
      CheckAndGetPublicRelationParameters parameters = CheckAndGetPublicRelationParameters(
        emailAddress: emailAddress,
        password: password,
      );
      Either<Failure, PublicRelationModel> response = await publicRelationProvider.checkAndGetPublicRelationImpl(parameters);
      response.fold((failure) async {
        changeIsLoading(false);
        Dialogs.failureOccurred(context, failure);
      }, (publicRelation) async {
        await NotificationService.subscribeToTopic(FirebaseConstants.fahemBusinessTopic).then((value) async {
          await NotificationService.subscribeToTopic('${publicRelation.publicRelationId}${ConstantsManager.fahemBusinessPublicRelationsKeyword}').then((value) {
            NotificationService.createLocalNotification(title: 'اهلا ${publicRelation.name}', body: 'مرحبا بك فى فاهم نحن سعداء بتواجدك معنا');
            changeIsLoading(false);
            CacheHelper.setData(key: PREFERENCES_KEY_IS_LOGGED, value: true);
            CacheHelper.setData(key: PREFERENCES_KEY_ACCOUNT_TYPE, value: _accountTypeModel!.accountType);
            CacheHelper.setData(key: PREFERENCES_KEY_ACCOUNT, value: json.encode(PublicRelationModel.toMap(publicRelation)));
            publicRelationProvider.changePublicRelation(publicRelation);
            resetAllData();
            Navigator.pushReplacementNamed(context, Routes.splashRoute);
          }).catchError((error) {
            changeIsLoading(false);
          });
        }).catchError((error) {
          changeIsLoading(false);
        });
      });
    }
    else if(_accountTypeModel!.accountType == AccountTypeEnum.legalAccountants.name) {
      LegalAccountantProvider legalAccountantProvider = Provider.of<LegalAccountantProvider>(context, listen: false);

      // Check And Get Legal Account
      CheckAndGetLegalAccountantParameters parameters = CheckAndGetLegalAccountantParameters(
        emailAddress: emailAddress,
        password: password,
      );
      Either<Failure, LegalAccountantModel> response = await legalAccountantProvider.checkAndGetLegalAccountantImpl(parameters);
      response.fold((failure) async {
        changeIsLoading(false);
        Dialogs.failureOccurred(context, failure);
      }, (legalAccountant) async {
        await NotificationService.subscribeToTopic(FirebaseConstants.fahemBusinessTopic).then((value) async {
          await NotificationService.subscribeToTopic('${legalAccountant.legalAccountantId}${ConstantsManager.fahemBusinessLegalAccountantsKeyword}').then((value) {
            NotificationService.createLocalNotification(title: 'اهلا ${legalAccountant.name}', body: 'مرحبا بك فى فاهم نحن سعداء بتواجدك معنا');
            changeIsLoading(false);
            CacheHelper.setData(key: PREFERENCES_KEY_IS_LOGGED, value: true);
            CacheHelper.setData(key: PREFERENCES_KEY_ACCOUNT_TYPE, value: _accountTypeModel!.accountType);
            CacheHelper.setData(key: PREFERENCES_KEY_ACCOUNT, value: json.encode(LegalAccountantModel.toMap(legalAccountant)));
            legalAccountantProvider.changeLegalAccountant(legalAccountant);
            resetAllData();
            Navigator.pushReplacementNamed(context, Routes.splashRoute);
          }).catchError((error) {
            changeIsLoading(false);
          });
        }).catchError((error) {
          changeIsLoading(false);
        });

      });
    }
  }
}
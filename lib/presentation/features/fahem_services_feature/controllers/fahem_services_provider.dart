import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/core/network/firebase_constants.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/services/notification_service.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/cache_helper.dart';
import 'package:fahem_business/core/utils/dialogs.dart';
import 'package:fahem_business/core/utils/enums.dart';
import 'package:fahem_business/core/utils/extensions.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/data/models/lawyers/lawyer_model.dart';
import 'package:fahem_business/domain/usecases/lawyers/edit_subscription_of_fahem_services_usecase.dart';
import 'package:fahem_business/presentation/features/lawyer/lawyer/controllers/lawyer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FahemServicesProvider with ChangeNotifier {
  final EditSubscriptionOfFahemServicesUseCase _editSubscriptionOfFahemServicesUseCase;

  FahemServicesProvider(this._editSubscriptionOfFahemServicesUseCase);

  Future<Either<Failure, LawyerModel>> editSubscriptionOfFahemServicesImpl(EditSubscriptionOfFahemServicesParameters parameters) async {
    return await _editSubscriptionOfFahemServicesUseCase.call(parameters);
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  changeIsLoading(bool isLoading) {_isLoading = isLoading; notifyListeners();}

  List<String> _fahemServicesIds = [];
  List<String> get fahemServicesIds => _fahemServicesIds;
  setFahemServicesIds(List<String> fahemServicesIds) => _fahemServicesIds = fahemServicesIds;
  changeFahemServicesIds(List<String> fahemServicesIds) {_fahemServicesIds = fahemServicesIds; notifyListeners();}
  toggleFahemServiceId(String fahemServiceId) {
    if(_fahemServicesIds.contains(fahemServiceId)) {
      _fahemServicesIds.removeWhere((element) => element == fahemServiceId);
    }
    else {
      _fahemServicesIds.add(fahemServiceId);
    }
    notifyListeners();
  }

  Future<void> onPressedSave(BuildContext context) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    LawyerProvider lawyerProvider = Provider.of<LawyerProvider>(context, listen: false);
    
    changeIsLoading(true);

    // Edit Subscription Of Fahem Services
    EditSubscriptionOfFahemServicesParameters parameters = EditSubscriptionOfFahemServicesParameters(
      lawyerId: lawyerProvider.lawyer.lawyerId,
      isSubscriberToInstantLawyerService: _fahemServicesIds.contains(FahemServiceType.instantLawyer.name),
      isSubscriberToInstantConsultationService: _fahemServicesIds.contains(FahemServiceType.instantConsultation.name),
      isSubscriberToSecretConsultationService: _fahemServicesIds.contains(FahemServiceType.secretConsultation.name),
      isSubscriberToEstablishingCompaniesService: _fahemServicesIds.contains(FahemServiceType.establishingCompanies.name),
      isSubscriberToRealEstateLegalAdviceService: _fahemServicesIds.contains(FahemServiceType.realEstateLegalAdvice.name),
      isSubscriberToInvestmentLegalAdviceService: _fahemServicesIds.contains(FahemServiceType.investmentLegalAdvice.name),
      isSubscriberToTrademarkRegistrationAndIntellectualProtectionServ: _fahemServicesIds.contains(FahemServiceType.trademarkRegistrationAndIntellectualProtection.name),
      isSubscriberToDebtCollectionService: _fahemServicesIds.contains(FahemServiceType.debtCollection.name),
    );
    Either<Failure, LawyerModel> response = await editSubscriptionOfFahemServicesImpl(parameters);
    response.fold((failure) async {
      changeIsLoading(false);
      Dialogs.failureOccurred(context, failure);
    }, (lawyer) {
      if(lawyer.isSubscriberToInstantConsultationService) {
        NotificationService.subscribeToTopic(FirebaseConstants.instantConsultationsTopic);
      }
      else {
        NotificationService.unsubscribeFromTopic(FirebaseConstants.instantConsultationsTopic);
      }
      changeIsLoading(false);
      CacheHelper.setData(key: PREFERENCES_KEY_ACCOUNT, value: json.encode(LawyerModel.toMap(lawyer)));
      lawyerProvider.changeLawyer(lawyer);
      Dialogs.showBottomSheetMessage(context: context, message: Methods.getText(StringsManager.modifiedSuccessfully, appProvider.isEnglish).toTitleCase(), showMessage: ShowMessage.success);
    });
  }
}
import 'dart:convert';

import 'package:fahem_business/core/resources/assets_manager.dart';
import 'package:fahem_business/core/resources/constants_manager.dart';
import 'package:fahem_business/core/resources/routes_manager.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/utils/cache_helper.dart';
import 'package:fahem_business/core/utils/enums.dart';
import 'package:fahem_business/core/utils/extensions.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/data/models/lawyers/lawyer_model.dart';
import 'package:fahem_business/data/models/static/main_model.dart';

String getProfileRoute(String accountType) {
  if(accountType == AccountTypeEnum.lawyers.name) {
    return Routes.lawyerProfileRoute;
  }
  else if(accountType == AccountTypeEnum.publicRelations.name) {
    return Routes.publicRelationProfileRoute;
  }
  else if(accountType == AccountTypeEnum.legalAccountants.name) {
    return Routes.legalAccountantProfileRoute;
  }
  else {
    return ConstantsManager.empty;
  }
}

String getReviewsRoute(String accountType) {
  if(accountType == AccountTypeEnum.lawyers.name) {
    return Routes.lawyerReviewsRoute;
  }
  else if(accountType == AccountTypeEnum.publicRelations.name) {
    return Routes.publicRelationReviewsRoute;
  }
  else if(accountType == AccountTypeEnum.legalAccountants.name) {
    return Routes.legalAccountantReviewsRoute;
  }
  else {
    return ConstantsManager.empty;
  }
}

List<MainModel> mainData() {
  String accountType = CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT_TYPE);

  return [
    MainModel(
      textAr: Methods.getText(StringsManager.profile, false).toTitleCase(),
      textEn: Methods.getText(StringsManager.profile, true).toTitleCase(),
      image: ImagesManager.profile,
      route: getProfileRoute(accountType),
    ),
    MainModel(
      textAr: Methods.getText(StringsManager.reviews, false).toTitleCase(),
      textEn: Methods.getText(StringsManager.reviews, true).toTitleCase(),
      image: ImagesManager.reviews,
      route: getReviewsRoute(accountType),
    ),

    MainModel(
      textAr: Methods.getText(StringsManager.jobs, false).toTitleCase(),
      textEn: Methods.getText(StringsManager.jobs, true).toTitleCase(),
      image: ImagesManager.jobs,
      route: Routes.jobsRoute,
    ),
    MainModel(
      textAr: Methods.getText(StringsManager.employmentApplications, false).toTitleCase(),
      textEn: Methods.getText(StringsManager.employmentApplications, true).toTitleCase(),
      image: ImagesManager.employmentApplications,
      route: Routes.employmentApplicationsRoute,
    ),

    if(accountType == AccountTypeEnum.lawyers.name) MainModel(
      textAr: Methods.getText(StringsManager.fahemServices, false).toTitleCase(),
      textEn: Methods.getText(StringsManager.fahemServices, true).toTitleCase(),
      image: ImagesManager.fahemServices,
      route: Routes.fahemServicesRoute,
    ),
    if(accountType == AccountTypeEnum.lawyers.name && LawyerModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT))).isSubscriberToInstantConsultationService) MainModel(
      textAr: Methods.getText(StringsManager.instantConsultations, false).toTitleCase(),
      textEn: Methods.getText(StringsManager.instantConsultations, true).toTitleCase(),
      image: ImagesManager.instantConsultations,
      route: Routes.instantConsultationsRoute,
    ),

    MainModel(
      textAr: Methods.getText(StringsManager.requestThePhoneNumber, false).toTitleCase(),
      textEn: Methods.getText(StringsManager.requestThePhoneNumber, true).toTitleCase(),
      image: ImagesManager.requestThePhoneNumber,
      route: Routes.requestThePhoneNumberRoute,
    ),
    MainModel(
      textAr: Methods.getText(StringsManager.bookingAppointments, false).toTitleCase(),
      textEn: Methods.getText(StringsManager.bookingAppointments, true).toTitleCase(),
      image: ImagesManager.bookingAppointments,
      route: Routes.bookingAppointmentsRoute,
    ),
    MainModel(
      textAr: Methods.getText(StringsManager.settings, false).toTitleCase(),
      textEn: Methods.getText(StringsManager.settings, true).toTitleCase(),
      image: ImagesManager.settings,
      route: Routes.settingsRoute,
    ),
  ];
}
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/utils/enums.dart';
import 'package:fahem_business/core/utils/extensions.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/data/models/static/fahem_service_model.dart';

List<FahemServiceModel> fahemServicesData = [
  FahemServiceModel(
    fahemServiceType: FahemServiceType.instantLawyer,
    nameAr: Methods.getText(StringsManager.instantLawyer, false).toTitleCase(),
    nameEn: Methods.getText(StringsManager.instantLawyer, true).toTitleCase(),
  ),
  FahemServiceModel(
    fahemServiceType: FahemServiceType.instantConsultation,
    nameAr: Methods.getText(StringsManager.instantConsultation, false).toTitleCase(),
    nameEn: Methods.getText(StringsManager.instantConsultation, true).toTitleCase(),
  ),
  FahemServiceModel(
    fahemServiceType: FahemServiceType.establishingCompanies,
    nameAr: Methods.getText(StringsManager.establishingCompanies, false).toTitleCase(),
    nameEn: Methods.getText(StringsManager.establishingCompanies, true).toTitleCase(),
  ),
  FahemServiceModel(
    fahemServiceType: FahemServiceType.realEstateLegalAdvice,
    nameAr: Methods.getText(StringsManager.realEstateLegalAdvice, false).toTitleCase(),
    nameEn: Methods.getText(StringsManager.realEstateLegalAdvice, true).toTitleCase(),
  ),
  FahemServiceModel(
    fahemServiceType: FahemServiceType.investmentLegalAdvice,
    nameAr: Methods.getText(StringsManager.investmentLegalAdvice, false).toTitleCase(),
    nameEn: Methods.getText(StringsManager.investmentLegalAdvice, true).toTitleCase(),
  ),
  FahemServiceModel(
    fahemServiceType: FahemServiceType.trademarkRegistrationAndIntellectualProtection,
    nameAr: Methods.getText(StringsManager.trademarkRegistrationAndIntellectualProtection, false).toTitleCase(),
    nameEn: Methods.getText(StringsManager.trademarkRegistrationAndIntellectualProtection, true).toTitleCase(),
  ),
  FahemServiceModel(
    fahemServiceType: FahemServiceType.debtCollection,
    nameAr: Methods.getText(StringsManager.debtCollection, false).toTitleCase(),
    nameEn: Methods.getText(StringsManager.debtCollection, true).toTitleCase(),
  ),
];

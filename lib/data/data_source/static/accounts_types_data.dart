import 'package:fahem_business/core/resources/assets_manager.dart';
import 'package:fahem_business/core/resources/routes_manager.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/utils/enums.dart';
import 'package:fahem_business/core/utils/extensions.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/data/models/static/account_type_model.dart';

List<AccountTypeModel> accountsTypesData = [
  AccountTypeModel(
    accountType: AccountTypeEnum.lawyers.name,
    image: ImagesManager.lawyers,
    nameAr: Methods.getText(StringsManager.lawyers, false).toTitleCase(),
    nameEn: Methods.getText(StringsManager.lawyers, true).toTitleCase(),
    route: Routes.registerLawyerRoute,
  ),
  AccountTypeModel(
    accountType: AccountTypeEnum.publicRelations.name,
    image: ImagesManager.publicRelations,
    nameAr: Methods.getText(StringsManager.publicRelations, false).toTitleCase(),
    nameEn: Methods.getText(StringsManager.publicRelations, true).toTitleCase(),
    route: Routes.registerPublicRelationRoute,
  ),
  AccountTypeModel(
    accountType: AccountTypeEnum.legalAccountants.name,
    image: ImagesManager.legalAccountants,
    nameAr: Methods.getText(StringsManager.legalAccountants, false).toTitleCase(),
    nameEn: Methods.getText(StringsManager.legalAccountants, true).toTitleCase(),
    route: Routes.registerLegalAccountantRoute,
  ),
];
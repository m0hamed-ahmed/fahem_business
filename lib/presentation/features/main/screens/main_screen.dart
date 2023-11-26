import 'package:fahem_business/core/resources/assets_manager.dart';
import 'package:fahem_business/core/resources/colors_manager.dart';
import 'package:fahem_business/core/resources/constants_manager.dart';
import 'package:fahem_business/core/resources/fonts_manager.dart';
import 'package:fahem_business/core/resources/routes_manager.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/resources/values_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/cache_helper.dart';
import 'package:fahem_business/core/utils/dialogs.dart';
import 'package:fahem_business/core/utils/enums.dart';
import 'package:fahem_business/core/utils/extensions.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/data/data_source/static/main_data.dart';
import 'package:fahem_business/data/models/lawyers/lawyer_model.dart';
import 'package:fahem_business/data/models/legal_accountant/legal_account_model.dart';
import 'package:fahem_business/data/models/public_relations/public_relation_model.dart';
import 'package:fahem_business/presentation/features/lawyer/lawyer/controllers/lawyer_provider.dart';
import 'package:fahem_business/presentation/features/lawyer/lawyer_profile/controllers/lawyer_profile_provider.dart';
import 'package:fahem_business/presentation/features/legal_accountant/legal_accountant/controllers/legal_accountant_provider.dart';
import 'package:fahem_business/presentation/features/legal_accountant/legal_accountant_profile/controllers/legal_accountant_profile_provider.dart';
import 'package:fahem_business/presentation/features/main/controllers/main_provider.dart';
import 'package:fahem_business/presentation/features/main/widgets/main_item.dart';
import 'package:fahem_business/presentation/features/public_relation/public_relation/controllers/public_relation_provider.dart';
import 'package:fahem_business/presentation/features/public_relation/public_relation_profile/controllers/public_relation_profile_provider.dart';
import 'package:fahem_business/presentation/shared/absorb_pointer_widget.dart';
import 'package:fahem_business/presentation/shared/background.dart';
import 'package:fahem_business/presentation/shared/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late AppProvider appProvider;
  late MainProvider mainProvider;
  late int numberOfRows;
  String accountType = CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT_TYPE);

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    mainProvider = Provider.of<MainProvider>(context, listen: false);

    numberOfRows = (mainData().length / ConstantsManager.numberOfItemsInRow).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LawyerProvider>(
      builder: (context, _, __) {
        return Selector<MainProvider, bool>(
          selector: (context, provider) => provider.isLoading,
          builder: (context, isLoading, _) {
            return AbsorbPointerWidget(
              absorbing: isLoading,
              child: Selector<AppProvider, bool>(
                selector: (context, provider) => provider.isEnglish,
                builder: (context, isEnglish, _) {
                  return WillPopScope(
                    onWillPop: () => isLoading ? Future.value(false) : Dialogs.showBottomSheetConfirmation(context: context, message: Methods.getText(StringsManager.doYouWantToExitAnApp, appProvider.isEnglish).toCapitalized()),
                    child: Directionality(
                      textDirection: Methods.getDirection(appProvider.isEnglish),
                      child: Scaffold(
                        body: Background(
                          child: SafeArea(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.only(left: SizeManager.s16, right: SizeManager.s16, bottom: SizeManager.s16),
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () async => await mainProvider.onRefresh(context),
                                        child: Padding(
                                          padding: const EdgeInsets.all(SizeManager.s16),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(Methods.getText(StringsManager.clickToRefresh, appProvider.isEnglish)),
                                              const SizedBox(width: SizeManager.s5),
                                              const Icon(Icons.refresh, size: SizeManager.s14),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              Methods.getText(StringsManager.hello, appProvider.isEnglish).toTitleCase(),
                                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.black),
                                            ),
                                            Consumer<LawyerProfileProvider>(
                                              builder: (context, provider, _) {
                                                return Consumer<PublicRelationProfileProvider>(
                                                  builder: (context, provider, _) {
                                                    return Consumer<LegalAccountantProfileProvider>(
                                                      builder: (context, provider, _) {
                                                        return Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Flexible(
                                                              child: Text(
                                                                mainProvider.getNameFromAccount(context),
                                                                style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: SizeManager.s25, fontWeight: FontWeightManager.black),
                                                              ),
                                                            ),
                                                            if(mainProvider.getIsVerifiedFromAccount(context)) const Padding(
                                                              padding: EdgeInsets.only(top: SizeManager.s5),
                                                              child: Icon(Icons.verified, color: ColorsManager.green, size: SizeManager.s20),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: SizeManager.s5),
                                      Container(
                                        height: SizeManager.s35,
                                        decoration: BoxDecoration(
                                          color: ColorsManager.white,
                                          borderRadius: BorderRadius.circular(SizeManager.s10),
                                          border: Border.all(color: ColorsManager.grey300),
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () => appProvider.changeIsEnglish(!appProvider.isEnglish),
                                            borderRadius: BorderRadius.circular(SizeManager.s10),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: SizeManager.s5, horizontal: SizeManager.s10),
                                              child: Row(
                                                children: [
                                                  Image.asset(appProvider.isEnglish ? ImagesManager.ar : ImagesManager.en, width: SizeManager.s30, height: SizeManager.s30),
                                                  const SizedBox(width: SizeManager.s10),
                                                  Text(
                                                    Methods.getText(StringsManager.lang, !appProvider.isEnglish).toUpperCase(),
                                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeightManager.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: SizeManager.s10),
                                      Container(
                                        height: SizeManager.s35,
                                        decoration: BoxDecoration(
                                          color: ColorsManager.red700,
                                          borderRadius: BorderRadius.circular(SizeManager.s10),
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () => Dialogs.showBottomSheetConfirmation(context: context, message: Methods.getText(StringsManager.doYouWantToLogout, appProvider.isEnglish).toCapitalized()).then((value) {
                                              if(value) Methods.logout(context);
                                            }),
                                            borderRadius: BorderRadius.circular(SizeManager.s10),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: SizeManager.s5, horizontal: SizeManager.s10),
                                              child: Center(
                                                child: Text(
                                                  Methods.getText(StringsManager.logout, appProvider.isEnglish).toUpperCase(),
                                                  style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeightManager.black, color: ColorsManager.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: SizeManager.s16),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: SizeManager.s16, vertical: SizeManager.s10),
                                    decoration: BoxDecoration(
                                      color: mainProvider.getStatusColor(context).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(SizeManager.s10),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: mainProvider.getAccountStatus(context) == AccountStatus.acceptable ? AlignmentDirectional.center : AlignmentDirectional.centerStart,
                                            child: Text(
                                              '${Methods.getText(StringsManager.accountStatus, appProvider.isEnglish).toTitleCase()}: ${Methods.getText(
                                                mainProvider.getAccountStatus(context) == AccountStatus.pending
                                                    ? StringsManager.underReview
                                                    : mainProvider.getAccountStatus(context) == AccountStatus.acceptable
                                                    ? StringsManager.acceptable
                                                    : StringsManager.unacceptable,
                                                appProvider.isEnglish,
                                              ).toUpperCase()}',
                                              style: Theme.of(context).textTheme.displayLarge!.copyWith(color: mainProvider.getStatusColor(context), fontWeight: FontWeightManager.black),
                                            ),
                                          ),
                                        ),
                                        if(mainProvider.getAccountStatus(context) == AccountStatus.pending || mainProvider.getAccountStatus(context) == AccountStatus.unacceptable) Column(
                                          children: [
                                            const SizedBox(width: SizeManager.s10),
                                            if(accountType == AccountTypeEnum.lawyers.name) Selector<LawyerProvider, LawyerModel>(
                                              selector: (context, provider) => provider.lawyer,
                                              builder: (context, _, __) {
                                                return CustomButton(
                                                  buttonType: ButtonType.text,
                                                  onPressed: () => Navigator.pushNamed(context, Routes.lawyerIdentificationImagesRoute),
                                                  text: Methods.getText(
                                                    mainProvider.getIdentificationImagesLength(context) == 0 ? StringsManager.completeYourData : StringsManager.editData,
                                                    appProvider.isEnglish,
                                                  ).toTitleCase(),
                                                  buttonColor: mainProvider.getStatusColor(context),
                                                  width: null,
                                                  height: SizeManager.s40,
                                                );
                                              },
                                            ),
                                            if(accountType == AccountTypeEnum.publicRelations.name) Selector<PublicRelationProvider, PublicRelationModel>(
                                              selector: (context, provider) => provider.publicRelation,
                                              builder: (context, _, __) {
                                                return CustomButton(
                                                  buttonType: ButtonType.text,
                                                  onPressed: () => Navigator.pushNamed(context, Routes.publicRelationIdentificationImagesRoute),
                                                  text: Methods.getText(
                                                    mainProvider.getIdentificationImagesLength(context) == 0 ? StringsManager.completeYourData : StringsManager.editData,
                                                    appProvider.isEnglish,
                                                  ).toTitleCase(),
                                                  buttonColor: mainProvider.getStatusColor(context),
                                                  width: null,
                                                  height: SizeManager.s40,
                                                );
                                              },
                                            ),
                                            if(accountType == AccountTypeEnum.legalAccountants.name) Selector<LegalAccountantProvider, LegalAccountantModel>(
                                              selector: (context, provider) => provider.legalAccountant,
                                              builder: (context, _, __) {
                                                return CustomButton(
                                                  buttonType: ButtonType.text,
                                                  onPressed: () => Navigator.pushNamed(context, Routes.legalAccountantIdentificationImagesRoute),
                                                  text: Methods.getText(
                                                    mainProvider.getIdentificationImagesLength(context) == 0 ? StringsManager.completeYourData : StringsManager.editData,
                                                    appProvider.isEnglish,
                                                  ).toTitleCase(),
                                                  buttonColor: mainProvider.getStatusColor(context),
                                                  width: null,
                                                  height: SizeManager.s40,
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: SizeManager.s16),
                                  Column(
                                    children: List.generate(numberOfRows, (index1) {
                                      return Row(
                                        children: List.generate(ConstantsManager.numberOfItemsInRow, (index2) {
                                          int index = index1 * ConstantsManager.numberOfItemsInRow + index2;
                                          return mainData().length > index ? Expanded(
                                            child: Container(
                                              margin: const EdgeInsets.all(SizeManager.s5),
                                              child:  MainItem(mainModel: mainData()[index]),
                                            ),
                                          ) : Container();
                                        }),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
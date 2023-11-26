import 'dart:convert';
import 'package:fahem_business/core/resources/colors_manager.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/resources/values_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/cache_helper.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/data/data_source/static/governorates_data.dart';
import 'package:fahem_business/data/models/legal_accountant/legal_account_model.dart';
import 'package:fahem_business/presentation/features/legal_accountant/legal_accountant_profile/controllers/legal_accountant_profile_provider.dart';
import 'package:fahem_business/presentation/shared/absorb_pointer_widget.dart';
import 'package:fahem_business/presentation/shared/background.dart';
import 'package:fahem_business/presentation/shared/custom_button.dart';
import 'package:fahem_business/presentation/shared/my_header.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class LegalAccountantProfileScreen extends StatefulWidget {

  const LegalAccountantProfileScreen({Key? key}) : super(key: key);

  @override
  State<LegalAccountantProfileScreen> createState() => _LegalAccountantProfileScreenState();
}

class _LegalAccountantProfileScreenState extends State<LegalAccountantProfileScreen> {
  late AppProvider appProvider;
  late LegalAccountantProfileProvider legalAccountantProfileProvider;
  LegalAccountantModel accountModel = LegalAccountantModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT)));

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    legalAccountantProfileProvider = Provider.of<LegalAccountantProfileProvider>(context, listen: false);

    legalAccountantProfileProvider.imageNameFromDatabase = accountModel.personalImage;
    legalAccountantProfileProvider.setName(accountModel.name);
    legalAccountantProfileProvider.setEmailAddress(accountModel.emailAddress);
    legalAccountantProfileProvider.setPassword(accountModel.password);
    legalAccountantProfileProvider.setGovernmentModel(governoratesData.firstWhere((element) => element.nameAr == accountModel.governorate));
    legalAccountantProfileProvider.setAddress(accountModel.address);
    legalAccountantProfileProvider.setPhoneNumber(accountModel.phoneNumber);
    legalAccountantProfileProvider.setJobTitle(accountModel.jobTitle);
    legalAccountantProfileProvider.setInformation(accountModel.information);
    legalAccountantProfileProvider.setConsultationPrice(accountModel.consultationPrice.toString());
    legalAccountantProfileProvider.setTasks(accountModel.tasks);
    legalAccountantProfileProvider.imagesNamesFromDatabase = accountModel.images;
    legalAccountantProfileProvider.setPosition(Position.fromMap({'latitude': accountModel.latitude, 'longitude': accountModel.longitude}));
  }

  @override
  Widget build(BuildContext context) {
    return Selector<LegalAccountantProfileProvider, bool>(
      selector: (context, provider) => provider.isLoading,
      builder: (context, isLoading, _) {
        return Selector<AppProvider, bool>(
          selector: (context, provider) => provider.isEnglish,
          builder: (context, isEnglish, _) {
            return AbsorbPointerWidget(
              absorbing: isLoading,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: WillPopScope(
                  onWillPop: () => isLoading ? Future.value(false) : legalAccountantProfileProvider.onBackPressed(context),
                  child: Directionality(
                    textDirection: Methods.getDirection(appProvider.isEnglish),
                    child: Scaffold(
                      body: Background(
                        child: SafeArea(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Selector<LegalAccountantProfileProvider, int>(
                                selector: (context, provider) => provider.currentPage,
                                builder: (context, currentPage, child) {
                                  return Padding(
                                    padding: const EdgeInsets.all(SizeManager.s16),
                                    child: Column(
                                      children: [
                                        MyHeader(
                                          title: StringsManager.profile,
                                          onBackPressed: () => legalAccountantProfileProvider.onBackPressed(context),
                                        ),
                                        SizedBox(
                                          height: SizeManager.s15,
                                          child: Row(
                                            children: List.generate(legalAccountantProfileProvider.pages.length, (index) {
                                              return Expanded(
                                                child: Container(
                                                  margin: EdgeInsetsDirectional.fromSTEB(SizeManager.s0, SizeManager.s0, index == legalAccountantProfileProvider.pages.length-1 ? SizeManager.s10 : SizeManager.s5, SizeManager.s10),
                                                  height: SizeManager.s4,
                                                  decoration: BoxDecoration(
                                                    color: index <= currentPage ? ColorsManager.primaryColor : ColorsManager.grey,
                                                    borderRadius: BorderRadius.circular(SizeManager.s5),
                                                  ),
                                                ),
                                              );
                                            }),
                                          ),
                                        ),
                                        const SizedBox(height: SizeManager.s16),
                                        Expanded(
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(minWidth: constraints.maxWidth, minHeight: constraints.maxHeight-15-32),
                                            child: IntrinsicHeight(
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    child: legalAccountantProfileProvider.pages[currentPage],
                                                  ),
                                                  const SizedBox(height: SizeManager.s16),
                                                  CustomButton(
                                                    buttonType: ButtonType.text,
                                                    onPressed: () => legalAccountantProfileProvider.onNextClicked(context),
                                                    buttonColor: ColorsManager.primaryColor,
                                                    borderRadius: SizeManager.s10,
                                                    text: Methods.getText(currentPage == legalAccountantProfileProvider.pages.length-1 ? StringsManager.edit : StringsManager.next, appProvider.isEnglish).toUpperCase(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
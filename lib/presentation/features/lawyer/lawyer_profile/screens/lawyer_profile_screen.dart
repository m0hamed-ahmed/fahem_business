import 'dart:convert';
import 'package:fahem_business/core/resources/colors_manager.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/resources/values_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/cache_helper.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/data/data_source/static/governorates_data.dart';
import 'package:fahem_business/data/models/lawyers/lawyer_model.dart';
import 'package:fahem_business/presentation/features/lawyer/lawyer_profile/controllers/lawyer_profile_provider.dart';
import 'package:fahem_business/presentation/shared/absorb_pointer_widget.dart';
import 'package:fahem_business/presentation/shared/background.dart';
import 'package:fahem_business/presentation/shared/custom_button.dart';
import 'package:fahem_business/presentation/shared/my_header.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class LawyerProfileScreen extends StatefulWidget {

  const LawyerProfileScreen({Key? key}) : super(key: key);

  @override
  State<LawyerProfileScreen> createState() => _LawyerProfileScreenState();
}

class _LawyerProfileScreenState extends State<LawyerProfileScreen> {
  late AppProvider appProvider;
  late LawyerProfileProvider lawyerProfileProvider;
  LawyerModel accountModel = LawyerModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT)));

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    lawyerProfileProvider = Provider.of<LawyerProfileProvider>(context, listen: false);

    lawyerProfileProvider.imageNameFromDatabase = accountModel.personalImage;
    lawyerProfileProvider.setName(accountModel.name);
    lawyerProfileProvider.setEmailAddress(accountModel.emailAddress);
    lawyerProfileProvider.setPassword(accountModel.password);
    lawyerProfileProvider.setGovernmentModel(governoratesData.firstWhere((element) => element.nameAr == accountModel.governorate));
    lawyerProfileProvider.setAddress(accountModel.address);
    lawyerProfileProvider.setPhoneNumber(accountModel.phoneNumber);
    lawyerProfileProvider.setJobTitle(accountModel.jobTitle);
    lawyerProfileProvider.setCategoriesIds(accountModel.categoriesIds);
    lawyerProfileProvider.setInformation(accountModel.information);
    lawyerProfileProvider.setConsultationPrice(accountModel.consultationPrice.toString());
    lawyerProfileProvider.setTasks(accountModel.tasks);
    lawyerProfileProvider.imagesNamesFromDatabase = accountModel.images;
    lawyerProfileProvider.setPosition(Position.fromMap({'latitude': accountModel.latitude, 'longitude': accountModel.longitude}));
  }

  @override
  Widget build(BuildContext context) {
    return Selector<LawyerProfileProvider, bool>(
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
                  onWillPop: () => isLoading ? Future.value(false) : lawyerProfileProvider.onBackPressed(context),
                  child: Directionality(
                    textDirection: Methods.getDirection(appProvider.isEnglish),
                    child: Scaffold(
                      body: Background(
                        child: SafeArea(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Selector<LawyerProfileProvider, int>(
                                selector: (context, provider) => provider.currentPage,
                                builder: (context, currentPage, child) {
                                  return Padding(
                                    padding: const EdgeInsets.all(SizeManager.s16),
                                    child: Column(
                                      children: [
                                        MyHeader(
                                          title: StringsManager.profile,
                                          onBackPressed: () => lawyerProfileProvider.onBackPressed(context),
                                        ),
                                        SizedBox(
                                          height: SizeManager.s15,
                                          child: Row(
                                            children: List.generate(lawyerProfileProvider.pages.length, (index) {
                                              return Expanded(
                                                child: Container(
                                                  margin: EdgeInsetsDirectional.fromSTEB(SizeManager.s0, SizeManager.s0, index == lawyerProfileProvider.pages.length-1 ? SizeManager.s10 : SizeManager.s5, SizeManager.s10),
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
                                                    child: lawyerProfileProvider.pages[currentPage],
                                                  ),
                                                  const SizedBox(height: SizeManager.s16),
                                                  CustomButton(
                                                    buttonType: ButtonType.text,
                                                    onPressed: () => lawyerProfileProvider.onNextClicked(context),
                                                    buttonColor: ColorsManager.primaryColor,
                                                    borderRadius: SizeManager.s10,
                                                    text: Methods.getText(currentPage == lawyerProfileProvider.pages.length-1 ? StringsManager.edit : StringsManager.next, appProvider.isEnglish).toUpperCase(),
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
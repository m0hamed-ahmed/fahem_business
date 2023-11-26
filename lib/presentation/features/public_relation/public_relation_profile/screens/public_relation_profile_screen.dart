import 'dart:convert';
import 'package:fahem_business/core/resources/colors_manager.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/resources/values_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/cache_helper.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/data/data_source/static/governorates_data.dart';
import 'package:fahem_business/data/models/public_relations/public_relation_model.dart';
import 'package:fahem_business/presentation/features/public_relation/public_relation_profile/controllers/public_relation_profile_provider.dart';
import 'package:fahem_business/presentation/shared/absorb_pointer_widget.dart';
import 'package:fahem_business/presentation/shared/background.dart';
import 'package:fahem_business/presentation/shared/custom_button.dart';
import 'package:fahem_business/presentation/shared/my_header.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class PublicRelationProfileScreen extends StatefulWidget {

  const PublicRelationProfileScreen({Key? key}) : super(key: key);

  @override
  State<PublicRelationProfileScreen> createState() => _PublicRelationProfileScreenState();
}

class _PublicRelationProfileScreenState extends State<PublicRelationProfileScreen> {
  late AppProvider appProvider;
  late PublicRelationProfileProvider publicRelationProfileProvider;
  PublicRelationModel accountModel = PublicRelationModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT)));

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    publicRelationProfileProvider = Provider.of<PublicRelationProfileProvider>(context, listen: false);

    publicRelationProfileProvider.imageNameFromDatabase = accountModel.personalImage;
    publicRelationProfileProvider.setName(accountModel.name);
    publicRelationProfileProvider.setEmailAddress(accountModel.emailAddress);
    publicRelationProfileProvider.setPassword(accountModel.password);
    publicRelationProfileProvider.setGovernmentModel(governoratesData.firstWhere((element) => element.nameAr == accountModel.governorate));
    publicRelationProfileProvider.setAddress(accountModel.address);
    publicRelationProfileProvider.setPhoneNumber(accountModel.phoneNumber);
    publicRelationProfileProvider.setJobTitle(accountModel.jobTitle);
    publicRelationProfileProvider.setCategoriesIds(accountModel.categoriesIds);
    publicRelationProfileProvider.setInformation(accountModel.information);
    publicRelationProfileProvider.setConsultationPrice(accountModel.consultationPrice.toString());
    publicRelationProfileProvider.setTasks(accountModel.tasks);
    publicRelationProfileProvider.imagesNamesFromDatabase = accountModel.images;
    publicRelationProfileProvider.setPosition(Position.fromMap({'latitude': accountModel.latitude, 'longitude': accountModel.longitude}));
  }

  @override
  Widget build(BuildContext context) {
    return Selector<PublicRelationProfileProvider, bool>(
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
                  onWillPop: () => isLoading ? Future.value(false) : publicRelationProfileProvider.onBackPressed(context),
                  child: Directionality(
                    textDirection: Methods.getDirection(appProvider.isEnglish),
                    child: Scaffold(
                      body: Background(
                        child: SafeArea(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Selector<PublicRelationProfileProvider, int>(
                                selector: (context, provider) => provider.currentPage,
                                builder: (context, currentPage, child) {
                                  return Padding(
                                    padding: const EdgeInsets.all(SizeManager.s16),
                                    child: Column(
                                      children: [
                                        MyHeader(
                                          title: StringsManager.profile,
                                          onBackPressed: () => publicRelationProfileProvider.onBackPressed(context),
                                        ),
                                        SizedBox(
                                          height: SizeManager.s15,
                                          child: Row(
                                            children: List.generate(publicRelationProfileProvider.pages.length, (index) {
                                              return Expanded(
                                                child: Container(
                                                  margin: EdgeInsetsDirectional.fromSTEB(SizeManager.s0, SizeManager.s0, index == publicRelationProfileProvider.pages.length-1 ? SizeManager.s10 : SizeManager.s5, SizeManager.s10),
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
                                                    child: publicRelationProfileProvider.pages[currentPage],
                                                  ),
                                                  const SizedBox(height: SizeManager.s16),
                                                  CustomButton(
                                                    buttonType: ButtonType.text,
                                                    onPressed: () => publicRelationProfileProvider.onNextClicked(context),
                                                    buttonColor: ColorsManager.primaryColor,
                                                    borderRadius: SizeManager.s10,
                                                    text: Methods.getText(currentPage == publicRelationProfileProvider.pages.length-1 ? StringsManager.edit : StringsManager.next, appProvider.isEnglish).toUpperCase(),
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
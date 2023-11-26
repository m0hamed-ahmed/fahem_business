import 'dart:convert';
import 'dart:io';
import 'package:fahem_business/core/resources/colors_manager.dart';
import 'package:fahem_business/core/resources/fonts_manager.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/resources/values_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/cache_helper.dart';
import 'package:fahem_business/core/utils/enums.dart';
import 'package:fahem_business/core/utils/extensions.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/core/utils/validator.dart';
import 'package:fahem_business/data/models/jobs/job_model.dart';
import 'package:fahem_business/data/models/lawyers/lawyer_model.dart';
import 'package:fahem_business/data/models/legal_accountant/legal_account_model.dart';
import 'package:fahem_business/data/models/public_relations/public_relation_model.dart';
import 'package:fahem_business/presentation/features/jobs/jobs/controllers/add_job_provider.dart';
import 'package:fahem_business/presentation/shared/absorb_pointer_widget.dart';
import 'package:fahem_business/presentation/shared/background.dart';
import 'package:fahem_business/presentation/shared/custom_button.dart';
import 'package:fahem_business/presentation/shared/custom_text_form_field.dart';
import 'package:fahem_business/presentation/shared/my_header.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddJobScreen extends StatefulWidget {

  const AddJobScreen({Key? key}) : super(key: key);

  @override
  State<AddJobScreen> createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  late AppProvider appProvider;
  late AddJobProvider addJobProvider;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingControllerJobTitle = TextEditingController();
  final TextEditingController _textEditingControllerCompanyName = TextEditingController();
  final TextEditingController _textEditingControllerAboutCompany = TextEditingController();
  final TextEditingController _textEditingControllerMinSalary = TextEditingController();
  final TextEditingController _textEditingControllerMaxSalary = TextEditingController();
  final TextEditingController _textEditingControllerJobLocation = TextEditingController();
  final TextEditingController _textEditingControllerFeature = TextEditingController();
  final TextEditingController _textEditingControllerDetails = TextEditingController();

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    addJobProvider = Provider.of<AddJobProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<AddJobProvider, bool>(
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
                  onWillPop: () => isLoading ? Future.value(false) : addJobProvider.onBackPressed(),
                  child: Directionality(
                    textDirection: Methods.getDirection(appProvider.isEnglish),
                    child: Scaffold(
                      body: Background(
                        child: SafeArea(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(SizeManager.s16),
                            child: Form(
                              key: _formKey,
                              child: Selector<AddJobProvider,bool>(
                                selector: (context, provider) => provider.isButtonClicked,
                                builder: (context, isButtonClicked, _) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      MyHeader(
                                        title: StringsManager.addJob,
                                        onBackPressed: () {
                                          if(!isLoading) {
                                            addJobProvider.resetAllData();
                                            Navigator.pop(context);
                                          }
                                        },
                                      ),
                                      const SizedBox(height: SizeManager.s16),

                                      // image *
                                      Selector<AddJobProvider, XFile?>(
                                        selector: (context, provider) => provider.image,
                                        builder: (context, image, child) {
                                          return image == null ? Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CustomButton(
                                                buttonType: ButtonType.postSpacerIcon,
                                                onPressed: () async {
                                                  XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                                                  if(xFile != null) addJobProvider.changeImage(xFile);
                                                },
                                                text: Methods.getText(StringsManager.image, appProvider.isEnglish).toCapitalized(),
                                                height: SizeManager.s50,
                                                borderRadius: SizeManager.s15,
                                                buttonColor: ColorsManager.white,
                                                borderColor: isButtonClicked ? ColorsManager.red700 : ColorsManager.primaryColor,
                                                textColor: ColorsManager.primaryColor,
                                                textFontWeight: FontWeightManager.medium,
                                                iconData: Icons.camera_alt,
                                                iconColor: ColorsManager.primaryColor,
                                              ),
                                              if(isButtonClicked) Text(
                                                Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized(),
                                                style: Theme.of(context).textTheme.displaySmall!.copyWith(color: ColorsManager.red700),
                                              ),
                                            ],
                                          ) : InkWell(
                                            onTap: () async {
                                              FocusScope.of(context).unfocus();
                                              XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                                              if(xFile != null) addJobProvider.changeImage(xFile);
                                            },
                                            child: Stack(
                                              alignment: AlignmentDirectional.topEnd,
                                              children: [
                                                Container(
                                                  clipBehavior: Clip.antiAlias,
                                                  width: SizeManager.s100,
                                                  height: SizeManager.s100,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(SizeManager.s10),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(SizeManager.s10),
                                                    child: Image.file(File(image.path), width: SizeManager.s100, height: SizeManager.s100, fit: BoxFit.fill),
                                                  ),
                                                ),
                                                Container(
                                                  width: SizeManager.s25,
                                                  height: SizeManager.s25,
                                                  margin: const EdgeInsets.all(SizeManager.s5),
                                                  decoration: const BoxDecoration(
                                                    color: ColorsManager.black,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: IconButton(
                                                    icon: const Icon(Icons.clear, color: ColorsManager.white, size: SizeManager.s20),
                                                    visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                                    padding: const EdgeInsets.all(SizeManager.s0),
                                                    onPressed: () => addJobProvider.changeImage(null),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: SizeManager.s20),

                                      // jobTitle *
                                      CustomTextFormField(
                                        controller: _textEditingControllerJobTitle,
                                        textDirection: Methods.getDirection(appProvider.isEnglish),
                                        labelText: Methods.getText(StringsManager.jobTitle, appProvider.isEnglish).toCapitalized(),
                                        prefixIcon: const Icon(Icons.work_outline, color: ColorsManager.primaryColor),
                                        verticalPadding: SizeManager.s15,
                                        suffixIcon: IconButton(
                                          onPressed: () => _textEditingControllerJobTitle.clear(),
                                          icon: const Icon(Icons.clear, color: ColorsManager.primaryColor),
                                        ),
                                        validator: (val) {
                                          if(Validator.isEmpty(val!)) {return Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized();}
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: SizeManager.s20),

                                      // companyName *
                                      CustomTextFormField(
                                        controller: _textEditingControllerCompanyName,
                                        textDirection: Methods.getDirection(appProvider.isEnglish),
                                        labelText: Methods.getText(StringsManager.companyName, appProvider.isEnglish).toCapitalized(),
                                        prefixIcon: const Icon(Icons.edit, color: ColorsManager.primaryColor),
                                        verticalPadding: SizeManager.s15,
                                        suffixIcon: IconButton(
                                          onPressed: () => _textEditingControllerCompanyName.clear(),
                                          icon: const Icon(Icons.clear, color: ColorsManager.primaryColor),
                                        ),
                                        validator: (val) {
                                          if(Validator.isEmpty(val!)) {return Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized();}
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: SizeManager.s20),

                                      // aboutCompany *
                                      CustomTextFormField(
                                        controller: _textEditingControllerAboutCompany,
                                        textDirection: Methods.getDirection(appProvider.isEnglish),
                                        keyboardType: TextInputType.multiline,
                                        textInputAction: TextInputAction.newline,
                                        maxLines: 5,
                                        labelText: Methods.getText(StringsManager.aboutCompany, appProvider.isEnglish).toCapitalized(),
                                        prefixIcon: const Icon(Icons.info_outline, color: ColorsManager.primaryColor),
                                        verticalPadding: SizeManager.s15,
                                        suffixIcon: IconButton(
                                          onPressed: () => _textEditingControllerAboutCompany.clear(),
                                          icon: const Icon(Icons.clear, color: ColorsManager.primaryColor),
                                        ),
                                        validator: (val) {
                                          if(Validator.isEmpty(val!)) {return Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized();}
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: SizeManager.s20),

                                      // minSalary *
                                      CustomTextFormField(
                                        controller: _textEditingControllerMinSalary,
                                        keyboardType: TextInputType.number,
                                        labelText: Methods.getText(StringsManager.minSalary, appProvider.isEnglish).toCapitalized(),
                                        prefixIcon: const Icon(Icons.price_change_outlined, color: ColorsManager.primaryColor),
                                        verticalPadding: SizeManager.s15,
                                        suffixIcon: IconButton(
                                          onPressed: () => _textEditingControllerMinSalary.clear(),
                                          icon: const Icon(Icons.clear, color: ColorsManager.primaryColor),
                                        ),
                                        validator: (val) {
                                          if(Validator.isEmpty(val!)) {return Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized();}
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: SizeManager.s20),

                                      // maxSalary *
                                      CustomTextFormField(
                                        controller: _textEditingControllerMaxSalary,
                                        keyboardType: TextInputType.number,
                                        labelText: Methods.getText(StringsManager.maxSalary, appProvider.isEnglish).toCapitalized(),
                                        prefixIcon: const Icon(Icons.price_change_outlined, color: ColorsManager.primaryColor),
                                        verticalPadding: SizeManager.s15,
                                        suffixIcon: IconButton(
                                          onPressed: () => _textEditingControllerMaxSalary.clear(),
                                          icon: const Icon(Icons.clear, color: ColorsManager.primaryColor),
                                        ),
                                        validator: (val) {
                                          if(Validator.isEmpty(val!)) {return Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized();}
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: SizeManager.s20),

                                      // location *
                                      CustomTextFormField(
                                        controller: _textEditingControllerJobLocation,
                                        textDirection: Methods.getDirection(appProvider.isEnglish),
                                        labelText: Methods.getText(StringsManager.jobLocation, appProvider.isEnglish).toCapitalized(),
                                        prefixIcon: const Icon(Icons.location_on_outlined, color: ColorsManager.primaryColor),
                                        verticalPadding: SizeManager.s15,
                                        suffixIcon: IconButton(
                                          onPressed: () => _textEditingControllerJobLocation.clear(),
                                          icon: const Icon(Icons.clear, color: ColorsManager.primaryColor),
                                        ),
                                        validator: (val) {
                                          if(Validator.isEmpty(val!)) {return Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized();}
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: SizeManager.s20),

                                      // features *
                                      Selector<AddJobProvider, int>(
                                        selector: (context, provider) => provider.features.length,
                                        builder: (context, featuresLength, _) {
                                          return Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Container(
                                              padding: const EdgeInsets.all(SizeManager.s10),
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: ColorsManager.white,
                                                borderRadius: BorderRadius.circular(SizeManager.s10),
                                                border: Border.all(color: isButtonClicked && featuresLength == 0 ? ColorsManager.red700 : ColorsManager.primaryColor),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CustomTextFormField(
                                                    controller: _textEditingControllerFeature,
                                                    textDirection: TextDirection.rtl,
                                                    labelText: Methods.getText(StringsManager.features, appProvider.isEnglish).toCapitalized(),
                                                    verticalPadding: SizeManager.s15,
                                                    prefixIcon: const Icon(Icons.task_alt, color: ColorsManager.primaryColor),
                                                    suffixIcon: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        CustomButton(
                                                          buttonType: ButtonType.text,
                                                          onPressed: () {
                                                            addJobProvider.addInFeatures(_textEditingControllerFeature.text.trim());
                                                            _textEditingControllerFeature.clear();
                                                          },
                                                          text: Methods.getText(StringsManager.add, appProvider.isEnglish).toUpperCase(),
                                                          buttonColor: ColorsManager.primaryColor,
                                                          width: SizeManager.s50,
                                                          height: SizeManager.s35,
                                                        ),
                                                      ],
                                                    ),
                                                    validator: (val) {
                                                      if(featuresLength == 0) {return Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized();}
                                                      return null;
                                                    },
                                                  ),
                                                  const SizedBox(height: SizeManager.s10),
                                                  Wrap(
                                                    spacing: SizeManager.s5,
                                                    runSpacing: SizeManager.s5,
                                                    children: List.generate(addJobProvider.features.length, (index) {
                                                      return InkWell(
                                                        onTap: () => addJobProvider.removeFromFeatures(addJobProvider.features[index]),
                                                        child: Container(
                                                          padding: const EdgeInsets.all(SizeManager.s5),
                                                          decoration: BoxDecoration(
                                                            color: ColorsManager.primaryColor,
                                                            border: Border.all(color: ColorsManager.primaryColor),
                                                            borderRadius: BorderRadius.circular(SizeManager.s5),
                                                          ),
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Text(
                                                                addJobProvider.features[index],
                                                                style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorsManager.white),
                                                              ),
                                                              const SizedBox(width: SizeManager.s10),
                                                              const Icon(Icons.clear, size: SizeManager.s14, color: ColorsManager.white),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: SizeManager.s20),

                                      // details *
                                      CustomTextFormField(
                                        controller: _textEditingControllerDetails,
                                        textDirection: Methods.getDirection(appProvider.isEnglish),
                                        keyboardType: TextInputType.multiline,
                                        textInputAction: TextInputAction.newline,
                                        maxLines: 5,
                                        labelText: Methods.getText(StringsManager.details, appProvider.isEnglish).toCapitalized(),
                                        prefixIcon: const Icon(Icons.info_outline, color: ColorsManager.primaryColor),
                                        verticalPadding: SizeManager.s15,
                                        suffixIcon: IconButton(
                                          onPressed: () => _textEditingControllerDetails.clear(),
                                          icon: const Icon(Icons.clear, color: ColorsManager.primaryColor),
                                        ),
                                        validator: (val) {
                                          if(Validator.isEmpty(val!)) {return Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized();}
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: SizeManager.s20),

                                      // isAvailable *
                                      Selector<AddJobProvider, bool>(
                                        selector: (context, provider) => provider.isAvailable,
                                        builder: (context, isAvailable, child) {
                                          return CheckboxListTile(
                                            controlAffinity: ListTileControlAffinity.leading,
                                            value: isAvailable,
                                            onChanged: (val) => addJobProvider.changeIsAvailable(val!),
                                            title: Text(
                                              Methods.getText(StringsManager.availableJob, appProvider.isEnglish).toCapitalized(),
                                              style: Theme.of(context).textTheme.bodySmall,
                                            ),
                                            activeColor: ColorsManager.primaryColor,
                                            checkColor: ColorsManager.white,
                                            contentPadding: const EdgeInsets.all(SizeManager.s0),
                                            visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                                            dense: true,
                                          );
                                        },
                                      ),
                                      const SizedBox(height: SizeManager.s20),

                                      // Button
                                      CustomButton(
                                        buttonType: ButtonType.text,
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
                                          String accountType = CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT_TYPE);
                                          late int targetId;
                                          late String targetName;

                                          if(accountType == AccountTypeEnum.lawyers.name) {
                                            LawyerModel lawyerModel = LawyerModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT)));
                                            targetId = lawyerModel.lawyerId;
                                            targetName = lawyerModel.mainCategory;
                                          }
                                          else if(accountType == AccountTypeEnum.publicRelations.name) {
                                            PublicRelationModel publicRelationModel = PublicRelationModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT)));
                                            targetId = publicRelationModel.publicRelationId;
                                            targetName = publicRelationModel.mainCategory;
                                          }
                                          else if(accountType == AccountTypeEnum.legalAccountants.name) {
                                            LegalAccountantModel legalAccountantModel = LegalAccountantModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT)));
                                            targetId = legalAccountantModel.legalAccountantId;
                                            targetName = legalAccountantModel.mainCategory;
                                          }

                                          addJobProvider.changeIsButtonClicked(true);
                                          if(_formKey.currentState!.validate() && addJobProvider.isAllDataValid(context)) {
                                            JobModel jobModel = JobModel(
                                              jobId: 0,
                                              targetId: targetId,
                                              targetName: targetName,
                                              image: '',
                                              jobTitle: _textEditingControllerJobTitle.text.trim(),
                                              companyName: _textEditingControllerCompanyName.text.trim(),
                                              aboutCompany: _textEditingControllerAboutCompany.text.trim(),
                                              minSalary: int.parse(_textEditingControllerMinSalary.text.trim()),
                                              maxSalary: int.parse(_textEditingControllerMaxSalary.text.trim()),
                                              jobLocation: _textEditingControllerJobLocation.text.trim(),
                                              features: addJobProvider.features,
                                              details: _textEditingControllerDetails.text.trim(),
                                              isAvailable: addJobProvider.isAvailable,
                                              createdAt: DateTime.now(),
                                            );
                                            addJobProvider.insertJob(context: context, jobModel: jobModel);
                                          }
                                        },
                                        buttonColor: ColorsManager.primaryColor,
                                        borderRadius: SizeManager.s10,
                                        text: Methods.getText(StringsManager.add, appProvider.isEnglish).toUpperCase(),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
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

  @override
  void dispose() {
    _textEditingControllerJobTitle.dispose();
    _textEditingControllerCompanyName.dispose();
    _textEditingControllerAboutCompany.dispose();
    _textEditingControllerMinSalary.dispose();
    _textEditingControllerMaxSalary.dispose();
    _textEditingControllerJobLocation.dispose();
    _textEditingControllerFeature.dispose();
    _textEditingControllerDetails.dispose();
    super.dispose();
  }
}
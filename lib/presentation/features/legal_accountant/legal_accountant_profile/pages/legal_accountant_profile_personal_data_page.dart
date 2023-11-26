import 'dart:io';
import 'package:fahem_business/core/network/api_constants.dart';
import 'package:fahem_business/core/resources/colors_manager.dart';
import 'package:fahem_business/core/resources/fonts_manager.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/resources/values_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/extensions.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/core/utils/validator.dart';
import 'package:fahem_business/data/data_source/static/governorates_data.dart';
import 'package:fahem_business/data/models/static/government_model.dart';
import 'package:fahem_business/presentation/features/legal_accountant/legal_accountant_profile/controllers/legal_accountant_profile_provider.dart';
import 'package:fahem_business/presentation/shared/cached_network_image_widget.dart';
import 'package:fahem_business/presentation/shared/custom_text_form_field.dart';
import 'package:fahem_business/presentation/shared/drop_down_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class LegalAccountantProfilePersonalDataPage extends StatefulWidget {
  
  const LegalAccountantProfilePersonalDataPage({Key? key}) : super(key: key);

  @override
  State<LegalAccountantProfilePersonalDataPage> createState() => _LegalAccountantProfilePersonalDataPageState();
}

class _LegalAccountantProfilePersonalDataPageState extends State<LegalAccountantProfilePersonalDataPage> {
  late AppProvider appProvider;
  late LegalAccountantProfileProvider legalAccountantProfileProvider;
  final TextEditingController _textEditingControllerName = TextEditingController();
  final TextEditingController _textEditingControllerEmailAddress = TextEditingController();
  final TextEditingController _textEditingControllerPassword = TextEditingController();
  final TextEditingController _textEditingControllerAddress = TextEditingController();
  final TextEditingController _textEditingControllerPhoneNumber = TextEditingController();

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    legalAccountantProfileProvider = Provider.of<LegalAccountantProfileProvider>(context, listen: false);

    _textEditingControllerName.text = legalAccountantProfileProvider.name ?? '';
    _textEditingControllerEmailAddress.text = legalAccountantProfileProvider.emailAddress ?? '';
    _textEditingControllerPassword.text = legalAccountantProfileProvider.password ?? '';
    _textEditingControllerAddress.text = legalAccountantProfileProvider.address ?? '';
    _textEditingControllerPhoneNumber.text = legalAccountantProfileProvider.phoneNumber ?? '';
  }
  
  @override
  Widget build(BuildContext context) {
    return Selector<AppProvider, bool>(
      selector: (context, provider) => provider.isEnglish,
      builder: (context, isEnglish, _) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Methods.getText(StringsManager.personalData, appProvider.isEnglish).toTitleCase(),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: SizeManager.s30, fontWeight: FontWeightManager.black),
              ),
              const SizedBox(height: SizeManager.s20),

              // Personal Image *
              Selector<LegalAccountantProfileProvider, XFile?>(
                selector: (context, provider) => provider.image,
                builder: (context, image, child) {
                  return Center(
                    child: GestureDetector(
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if(xFile != null) legalAccountantProfileProvider.changeImage(xFile);
                      },
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        width: SizeManager.s100,
                        height: SizeManager.s100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(SizeManager.s50),
                        ),
                        child: image == null
                            ? CachedNetworkImageWidget(image: ApiConstants.fileUrl(fileName: '${ApiConstants.legalAccountantsDirectory}/${legalAccountantProfileProvider.imageNameFromDatabase}'))
                            : Image.file(File(image.path), fit: BoxFit.fill),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: SizeManager.s20),

              // Name *
              CustomTextFormField(
                controller: _textEditingControllerName,
                textDirection: Methods.getDirection(appProvider.isEnglish),
                labelText: Methods.getText(StringsManager.name, appProvider.isEnglish).toCapitalized(),
                prefixIcon: const Icon(Icons.person_outline, color: ColorsManager.primaryColor),
                suffixIcon: IconButton(
                  onPressed: () => _textEditingControllerName.clear(),
                  icon: const Icon(Icons.clear, color: ColorsManager.primaryColor),
                ),
                onChanged: (val) => legalAccountantProfileProvider.setName(val),
                validator: (val) {
                  if(Validator.isEmpty(val!)) {return Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized();}
                  return null;
                },
              ),
              const SizedBox(height: SizeManager.s20),

              // Email Address *
              CustomTextFormField(
                controller: _textEditingControllerEmailAddress,
                keyboardType: TextInputType.emailAddress,
                labelText: Methods.getText(StringsManager.emailAddress, appProvider.isEnglish).toCapitalized(),
                prefixIcon: const Icon(Icons.email_outlined, color: ColorsManager.primaryColor),
                suffixIcon: IconButton(
                  onPressed: () => _textEditingControllerEmailAddress.clear(),
                  icon: const Icon(Icons.clear, color: ColorsManager.primaryColor),
                ),
                onChanged: (val) => legalAccountantProfileProvider.setEmailAddress(val),
                validator: (val) {
                  if(Validator.isEmpty(val!)) {return Methods.getText(StringsManager.required, appProvider.isEnglish);}
                  else if(!Validator.isEmailAddressValid(val)) {return Methods.getText(StringsManager.pleaseEnterAValidEmailAddress, appProvider.isEnglish);}
                  return null;
                },
              ),
              const SizedBox(height: SizeManager.s20),

              // Password *
              Selector<LegalAccountantProfileProvider, bool>(
                selector: (context, provider) => provider.isShowPassword,
                builder: (context, isShowPassword, child) {
                  return CustomTextFormField(
                    controller: _textEditingControllerPassword,
                    keyboardType: TextInputType.visiblePassword,
                    labelText: Methods.getText(StringsManager.password, appProvider.isEnglish).toCapitalized(),
                    obscureText: !isShowPassword,
                    prefixIcon: const Icon(Icons.lock_outline, color: ColorsManager.primaryColor),
                    suffixIcon: IconButton(
                      onPressed: () => legalAccountantProfileProvider.changeIsShowPassword(),
                      icon: Icon(isShowPassword ? Icons.visibility_off : Icons.visibility, color: ColorsManager.primaryColor),
                    ),
                    onChanged: (val) => legalAccountantProfileProvider.setPassword(val),
                    validator: (val) {
                      if(Validator.isEmpty(val!)) {return Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized();}
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: SizeManager.s20),

              // Governorate *
              Selector<LegalAccountantProfileProvider, GovernmentModel?>(
                selector: (context, provider) => provider.governmentModel,
                builder: (context, governmentModel, _) {
                  return DropDownWidget(
                    hint: StringsManager.chooseGovernment,
                    isRequired: false,
                    currentValue: governmentModel,
                    valuesObject: List.generate(governoratesData.length, (index) => governoratesData[index]),
                    valuesText: List.generate(governoratesData.length, (index) => appProvider.isEnglish ? governoratesData[index].nameEn : governoratesData[index].nameAr),
                    onChanged: (val) => legalAccountantProfileProvider.changeGovernmentModel(val as GovernmentModel),
                    color: ColorsManager.white,
                  );
                },
              ),
              const SizedBox(height: SizeManager.s20),

              // Address *
              CustomTextFormField(
                controller: _textEditingControllerAddress,
                textDirection: Methods.getDirection(appProvider.isEnglish),
                labelText: Methods.getText(StringsManager.address, appProvider.isEnglish).toCapitalized(),
                prefixIcon: const Icon(Icons.location_city, color: ColorsManager.primaryColor),
                suffixIcon: IconButton(
                  onPressed: () => _textEditingControllerAddress.clear(),
                  icon: const Icon(Icons.clear, color: ColorsManager.primaryColor),
                ),
                onChanged: (val) => legalAccountantProfileProvider.setAddress(val),
                validator: (val) {
                  if(Validator.isEmpty(val!)) {return Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized();}
                  return null;
                },
              ),
              const SizedBox(height: SizeManager.s20),

              // Phone Number *
              CustomTextFormField(
                controller: _textEditingControllerPhoneNumber,
                keyboardType: TextInputType.phone,
                maxLength: 11,
                labelText: Methods.getText(StringsManager.phoneNumber, appProvider.isEnglish).toCapitalized(),
                prefixIcon: const Icon(Icons.phone, color: ColorsManager.primaryColor),
                suffixIcon: IconButton(
                  onPressed: () => _textEditingControllerPhoneNumber.clear(),
                  icon: const Icon(Icons.clear, color: ColorsManager.primaryColor),
                ),

                onChanged: (val) => legalAccountantProfileProvider.setPhoneNumber(val),
                validator: (val) {
                  if(Validator.isEmpty(val!)) {return Methods.getText(StringsManager.required, appProvider.isEnglish);}
                  else if(!Validator.isPhoneNumberValid(val)) {return Methods.getText(StringsManager.phoneNumberIsIncorrect, appProvider.isEnglish);}
                  return null;
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _textEditingControllerEmailAddress.dispose();
    _textEditingControllerPassword.dispose();
    _textEditingControllerName.dispose();
    _textEditingControllerAddress.dispose();
    _textEditingControllerPhoneNumber.dispose();
    super.dispose();
  }
}
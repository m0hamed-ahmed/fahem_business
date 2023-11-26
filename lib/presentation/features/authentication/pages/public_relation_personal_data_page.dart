import 'dart:io';
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
import 'package:fahem_business/presentation/features/authentication/controllers/register_public_relation_provider.dart';
import 'package:fahem_business/presentation/shared/custom_button.dart';
import 'package:fahem_business/presentation/shared/custom_text_form_field.dart';
import 'package:fahem_business/presentation/shared/drop_down_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PublicRelationPersonalDataPage extends StatefulWidget {
  
  const PublicRelationPersonalDataPage({Key? key}) : super(key: key);

  @override
  State<PublicRelationPersonalDataPage> createState() => _PublicRelationPersonalDataPageState();
}

class _PublicRelationPersonalDataPageState extends State<PublicRelationPersonalDataPage> {
  late AppProvider appProvider;
  late RegisterPublicRelationProvider registerPublicRelationProvider;
  final TextEditingController _textEditingControllerName = TextEditingController();
  final TextEditingController _textEditingControllerEmailAddress = TextEditingController();
  final TextEditingController _textEditingControllerPassword = TextEditingController();
  final TextEditingController _textEditingControllerAddress = TextEditingController();
  final TextEditingController _textEditingControllerPhoneNumber = TextEditingController();

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    registerPublicRelationProvider = Provider.of<RegisterPublicRelationProvider>(context, listen: false);

    _textEditingControllerName.text = registerPublicRelationProvider.name ?? '';
    _textEditingControllerEmailAddress.text = registerPublicRelationProvider.emailAddress ?? '';
    _textEditingControllerPassword.text = registerPublicRelationProvider.password ?? '';
    _textEditingControllerAddress.text = registerPublicRelationProvider.address ?? '';
    _textEditingControllerPhoneNumber.text = registerPublicRelationProvider.phoneNumber ?? '';
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
              Selector<RegisterPublicRelationProvider, XFile?>(
                selector: (context, provider) => provider.image,
                builder: (context, image, child) {
                  return image == null ? CustomButton(
                    buttonType: ButtonType.postSpacerIcon,
                    onPressed: () async {
                      XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if(xFile != null) registerPublicRelationProvider.changeImage(xFile);
                    },
                    text: Methods.getText(StringsManager.personalImage, appProvider.isEnglish).toCapitalized(),
                    height: SizeManager.s50,
                    borderRadius: SizeManager.s15,
                    buttonColor: ColorsManager.white,
                    borderColor: ColorsManager.primaryColor,
                    textColor: ColorsManager.primaryColor,
                    textFontWeight: FontWeightManager.medium,
                    iconData: Icons.camera_alt,
                    iconColor: ColorsManager.primaryColor,
                  ) : InkWell(
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if(xFile != null) registerPublicRelationProvider.changeImage(xFile);
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
                            onPressed: () => registerPublicRelationProvider.changeImage(null),
                          ),
                        ),
                      ],
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
                onChanged: (val) => registerPublicRelationProvider.setName(val),
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
                onChanged: (val) => registerPublicRelationProvider.setEmailAddress(val),
                validator: (val) {
                  if(Validator.isEmpty(val!)) {return Methods.getText(StringsManager.required, appProvider.isEnglish);}
                  else if(!Validator.isEmailAddressValid(val)) {return Methods.getText(StringsManager.pleaseEnterAValidEmailAddress, appProvider.isEnglish);}
                  return null;
                },
              ),
              const SizedBox(height: SizeManager.s20),

              // Password *
              Selector<RegisterPublicRelationProvider, bool>(
                selector: (context, provider) => provider.isShowPassword,
                builder: (context, isShowPassword, child) {
                  return CustomTextFormField(
                    controller: _textEditingControllerPassword,
                    keyboardType: TextInputType.visiblePassword,
                    labelText: Methods.getText(StringsManager.password, appProvider.isEnglish).toCapitalized(),
                    obscureText: !isShowPassword,
                    prefixIcon: const Icon(Icons.lock_outline, color: ColorsManager.primaryColor),
                    suffixIcon: IconButton(
                      onPressed: () => registerPublicRelationProvider.changeIsShowPassword(),
                      icon: Icon(isShowPassword ? Icons.visibility_off : Icons.visibility, color: ColorsManager.primaryColor),
                    ),
                    onChanged: (val) => registerPublicRelationProvider.setPassword(val),
                    validator: (val) {
                      if(Validator.isEmpty(val!)) {return Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized();}
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: SizeManager.s20),

              // Governorate *
              Selector<RegisterPublicRelationProvider, GovernmentModel?>(
                selector: (context, provider) => provider.governmentModel,
                builder: (context, governmentModel, _) {
                  return DropDownWidget(
                    hint: StringsManager.chooseGovernment,
                    isRequired: false,
                    currentValue: governmentModel,
                    valuesObject: List.generate(governoratesData.length, (index) => governoratesData[index]),
                    valuesText: List.generate(governoratesData.length, (index) => appProvider.isEnglish ? governoratesData[index].nameEn : governoratesData[index].nameAr),
                    onChanged: (val) => registerPublicRelationProvider.changeGovernmentModel(val as GovernmentModel),
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
                onChanged: (val) => registerPublicRelationProvider.setAddress(val),
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
                onChanged: (val) => registerPublicRelationProvider.setPhoneNumber(val),
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
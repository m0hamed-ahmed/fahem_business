import 'dart:io';
import 'package:fahem_business/core/resources/colors_manager.dart';
import 'package:fahem_business/core/resources/fonts_manager.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/resources/values_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/extensions.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/core/utils/validator.dart';
import 'package:fahem_business/presentation/features/authentication/controllers/register_legal_account_provider.dart';
import 'package:fahem_business/presentation/shared/absorb_pointer_widget.dart';
import 'package:fahem_business/presentation/shared/custom_button.dart';
import 'package:fahem_business/presentation/shared/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class LegalAccountantAccountDataPage extends StatefulWidget {

  const LegalAccountantAccountDataPage({Key? key}) : super(key: key);

  @override
  State<LegalAccountantAccountDataPage> createState() => _LegalAccountantAccountDataPageState();
}

class _LegalAccountantAccountDataPageState extends State<LegalAccountantAccountDataPage> {
  late AppProvider appProvider;
  late RegisterLegalAccountantProvider registerLegalAccountantProvider;
  final TextEditingController _textEditingControllerJobTitle = TextEditingController();
  final TextEditingController _textEditingControllerInformation = TextEditingController();
  final TextEditingController _textEditingControllerConsultationPrice = TextEditingController();
  final TextEditingController _textEditingControllerTask = TextEditingController();

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    registerLegalAccountantProvider = Provider.of<RegisterLegalAccountantProvider>(context, listen: false);

    _textEditingControllerJobTitle.text = registerLegalAccountantProvider.jobTitle ?? '';
    _textEditingControllerInformation.text = registerLegalAccountantProvider.information ?? '';
    _textEditingControllerConsultationPrice.text = registerLegalAccountantProvider.consultationPrice ?? '';
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
                Methods.getText(StringsManager.accountData, appProvider.isEnglish).toTitleCase(),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: SizeManager.s30, fontWeight: FontWeightManager.black),
              ),
              const SizedBox(height: SizeManager.s20),

              // Job Title *
              CustomTextFormField(
                controller: _textEditingControllerJobTitle,
                textDirection: Methods.getDirection(appProvider.isEnglish),
                labelText: Methods.getText(StringsManager.jobTitle, appProvider.isEnglish).toCapitalized(),
                prefixIcon: const Icon(Icons.work_outline, color: ColorsManager.primaryColor),
                suffixIcon: IconButton(
                  onPressed: () => _textEditingControllerJobTitle.clear(),
                  icon: const Icon(Icons.clear, color: ColorsManager.primaryColor),
                ),
                onChanged: (val) => registerLegalAccountantProvider.setJobTitle(val),
                validator: (val) {
                  if(Validator.isEmpty(val!)) {return Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized();}
                  return null;
                },
              ),
              const SizedBox(height: SizeManager.s20),

              // Information *
              CustomTextFormField(
                controller: _textEditingControllerInformation,
                textDirection: Methods.getDirection(appProvider.isEnglish),
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                maxLines: 5,
                verticalPadding: SizeManager.s15,
                labelText: Methods.getText(StringsManager.informationAboutYou, appProvider.isEnglish).toCapitalized(),
                prefixIcon: const Icon(Icons.info_outline, color: ColorsManager.primaryColor),
                suffixIcon: IconButton(
                  onPressed: () => _textEditingControllerInformation.clear(),
                  icon: const Icon(Icons.clear, color: ColorsManager.primaryColor),
                ),
                onChanged: (val) => registerLegalAccountantProvider.setInformation(val),
                validator: (val) {
                  if(Validator.isEmpty(val!)) {return Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized();}
                  return null;
                },
              ),
              const SizedBox(height: SizeManager.s20),

              // Consultation Price *
              CustomTextFormField(
                controller: _textEditingControllerConsultationPrice,
                keyboardType: TextInputType.number,
                labelText: Methods.getText(StringsManager.consultationPrice, appProvider.isEnglish).toCapitalized(),
                prefixIcon: const Icon(Icons.price_change_outlined, color: ColorsManager.primaryColor),
                suffixIcon: IconButton(
                  onPressed: () => _textEditingControllerConsultationPrice.clear(),
                  icon: const Icon(Icons.clear, color: ColorsManager.primaryColor),
                ),
                onChanged: (val) => registerLegalAccountantProvider.setConsultationPrice(val),
                validator: (val) {
                  if(Validator.isEmpty(val!)) {return Methods.getText(StringsManager.required, appProvider.isEnglish);}
                  else if(!Validator.isIntegerNumber(val)) {return Methods.getText(StringsManager.pleaseEnterAValidEmailAddress, appProvider.isEnglish);}
                  return null;
                },
              ),
              const SizedBox(height: SizeManager.s20),

              // Tasks *
              Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  padding: const EdgeInsets.all(SizeManager.s10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ColorsManager.white,
                    borderRadius: BorderRadius.circular(SizeManager.s10),
                    border: Border.all(color: ColorsManager.primaryColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextFormField(
                        controller: _textEditingControllerTask,
                        textDirection: TextDirection.rtl,
                        labelText: Methods.getText(StringsManager.tasks, appProvider.isEnglish).toCapitalized(),
                        prefixIcon: const Icon(Icons.task_alt, color: ColorsManager.primaryColor),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomButton(
                              buttonType: ButtonType.text,
                              onPressed: () {
                                registerLegalAccountantProvider.addInTasks(_textEditingControllerTask.text.trim());
                                _textEditingControllerTask.clear();
                              },
                              text: Methods.getText(StringsManager.add, appProvider.isEnglish).toUpperCase(),
                              buttonColor: ColorsManager.primaryColor,
                              width: SizeManager.s50,
                              height: SizeManager.s35,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: SizeManager.s10),
                      Selector<RegisterLegalAccountantProvider, int>(
                        selector: (context, provider) => provider.tasks.length,
                        builder: (context, tasksLength, _) {
                          return Wrap(
                            spacing: SizeManager.s5,
                            runSpacing: SizeManager.s5,
                            children: List.generate(registerLegalAccountantProvider.tasks.length, (index) {
                              return InkWell(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  registerLegalAccountantProvider.removeFromTasks(registerLegalAccountantProvider.tasks[index]);
                                },
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
                                        registerLegalAccountantProvider.tasks[index],
                                        style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorsManager.white),
                                      ),
                                      const SizedBox(width: SizeManager.s10),
                                      const Icon(Icons.clear, size: SizeManager.s14, color: ColorsManager.white),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: SizeManager.s20),

              // Images
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(SizeManager.s10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ColorsManager.white,
                      borderRadius: BorderRadius.circular(SizeManager.s10),
                      border: Border.all(color: ColorsManager.primaryColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomButton(
                          buttonType: ButtonType.postSpacerIcon,
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                            if(xFile != null) {
                              registerLegalAccountantProvider.addInImages(xFile);
                            }
                          },
                          text: Methods.getText(StringsManager.clickToAddAImage, appProvider.isEnglish).toCapitalized(),
                          height: SizeManager.s50,
                          borderRadius: SizeManager.s15,
                          buttonColor: ColorsManager.white,
                          borderColor: ColorsManager.primaryColor,
                          textColor: ColorsManager.primaryColor,
                          textFontWeight: FontWeightManager.medium,
                          iconData: Icons.camera_alt,
                          iconColor: ColorsManager.primaryColor,
                        ),
                        const SizedBox(height: SizeManager.s10),
                        Selector<RegisterLegalAccountantProvider, int>(
                          selector: (context, provider) => provider.images.length,
                          builder: (context, imagesLength, _) {
                            return Wrap(
                              spacing: SizeManager.s5,
                              runSpacing: SizeManager.s5,
                              children: List.generate(imagesLength, (index) {
                                return Stack(
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
                                        child: Image.file(File(registerLegalAccountantProvider.images[index].path), width: SizeManager.s100, height: SizeManager.s100, fit: BoxFit.fill),
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
                                        onPressed: () => registerLegalAccountantProvider.removeFromImages(index),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  PositionedDirectional(
                    top: -8,
                    start: 45,
                    child: Text(
                      Methods.getText(StringsManager.images, appProvider.isEnglish).toCapitalized(),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: SizeManager.s10),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: SizeManager.s20),

              // Latitude & Longitude *
              Selector<RegisterLegalAccountantProvider, Position?>(
                selector: (context, provider) => provider.position,
                builder: (context, position, _) {
                  return Selector<RegisterLegalAccountantProvider, bool>(
                    selector: (context, provider) => provider.isDetectLocationClicked,
                    builder: (context, isDetectLocationClicked, _) {
                      return AbsorbPointerWidget(
                        absorbing: isDetectLocationClicked && position == null,
                        child: CustomButton(
                          buttonType: ButtonType.postSpacerIcon,
                          onPressed: position != null ? () {} : () async {
                            FocusScope.of(context).unfocus();
                            registerLegalAccountantProvider.changeIsDetectLocationClicked(true);
                            await Methods.checkPermissionAndGetCurrentPosition(context).then((position) {
                              registerLegalAccountantProvider.changeIsDetectLocationClicked(false);
                              registerLegalAccountantProvider.changePosition(position);
                            });
                          },
                          text: position == null
                              ? Methods.getText(StringsManager.detectLocation, appProvider.isEnglish).toCapitalized()
                              : '${position.latitude} , ${position.longitude}',
                          height: SizeManager.s50,
                          borderRadius: SizeManager.s15,
                          buttonColor: ColorsManager.white,
                          borderColor: ColorsManager.primaryColor,
                          textColor: ColorsManager.primaryColor,
                          textFontWeight: FontWeightManager.medium,
                          iconData: Icons.location_on,
                          iconColor: ColorsManager.primaryColor,
                        ),
                      );
                    },
                  );
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
    _textEditingControllerJobTitle.dispose();
    _textEditingControllerInformation.dispose();
    _textEditingControllerConsultationPrice.dispose();
    _textEditingControllerTask.dispose();
    super.dispose();
  }
}
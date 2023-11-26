import 'dart:convert';
import 'dart:io';
import 'package:fahem_business/core/network/api_constants.dart';
import 'package:fahem_business/core/resources/colors_manager.dart';
import 'package:fahem_business/core/resources/fonts_manager.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/resources/values_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/cache_helper.dart';
import 'package:fahem_business/core/utils/extensions.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/data/models/public_relations/public_relation_model.dart';
import 'package:fahem_business/presentation/features/public_relation/public_relation_identification_images/controllers/public_relation_identification_images_provider.dart';
import 'package:fahem_business/presentation/shared/absorb_pointer_widget.dart';
import 'package:fahem_business/presentation/shared/background.dart';
import 'package:fahem_business/presentation/shared/cached_network_image_widget.dart';
import 'package:fahem_business/presentation/shared/custom_button.dart';
import 'package:fahem_business/presentation/shared/my_header.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PublicRelationIdentificationImagesScreen extends StatefulWidget {

  const PublicRelationIdentificationImagesScreen({Key? key}) : super(key: key);

  @override
  State<PublicRelationIdentificationImagesScreen> createState() => _PublicRelationIdentificationImagesScreenState();
}

class _PublicRelationIdentificationImagesScreenState extends State<PublicRelationIdentificationImagesScreen> {
  late AppProvider appProvider;
  late PublicRelationIdentificationImagesProvider publicRelationIdentificationImagesProvider;
  late PublicRelationModel publicRelationModel;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    publicRelationIdentificationImagesProvider = Provider.of<PublicRelationIdentificationImagesProvider>(context, listen: false);

    publicRelationModel = PublicRelationModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT)));
    publicRelationIdentificationImagesProvider.setImagesNamesFromDatabase(publicRelationModel.identificationImages);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<PublicRelationIdentificationImagesProvider, bool>(
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
                  onWillPop: () => Future.value(!isLoading),
                  child: Directionality(
                    textDirection: Methods.getDirection(appProvider.isEnglish),
                    child: Scaffold(
                      body: Background(
                        child: SafeArea(
                          child:  Selector<PublicRelationIdentificationImagesProvider, int>(
                            selector: (context, provider) => provider.images.length,
                            builder: (context, imagesLength, _) {
                              return Selector<PublicRelationIdentificationImagesProvider, int>(
                                selector: (context, provider) => provider.imagesNamesFromDatabase.length,
                                builder: (context, imagesNamesFromDatabaseLength, _) {
                                  return SingleChildScrollView(
                                    padding: const EdgeInsets.all(SizeManager.s16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const MyHeader(title: StringsManager.completeYourData),
                                        const SizedBox(height: SizeManager.s20),

                                        Text(
                                          Methods.getText(StringsManager.addTheNationalIdAndTheCommercialRegisterToConfirmAndReviewTheAccountStatus, appProvider.isEnglish).toTitleCase(),
                                          style: Theme.of(context).textTheme.bodyLarge,
                                        ),
                                        const SizedBox(height: SizeManager.s20),

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
                                                      XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                                                      if(xFile != null) {
                                                        publicRelationIdentificationImagesProvider.addInImages(xFile);
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
                                                  Wrap(
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
                                                              child: Image.file(File(publicRelationIdentificationImagesProvider.images[index].path), width: SizeManager.s100, height: SizeManager.s100, fit: BoxFit.fill),
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
                                                              onPressed: () => publicRelationIdentificationImagesProvider.removeFromImages(index),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }),
                                                  ),
                                                  const SizedBox(height: SizeManager.s10),
                                                  Wrap(
                                                    spacing: SizeManager.s5,
                                                    runSpacing: SizeManager.s5,
                                                    children: List.generate(imagesNamesFromDatabaseLength, (index) {
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
                                                              child: CachedNetworkImageWidget(image: ApiConstants.fileUrl(fileName: '${ApiConstants.publicRelationsIdentificationDirectory}/${publicRelationIdentificationImagesProvider.imagesNamesFromDatabase[index]}')),
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
                                                              onPressed: () => publicRelationIdentificationImagesProvider.removeFromImagesNamesFromDatabase(index),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }),
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
                                        CustomButton(
                                          buttonType: ButtonType.text,
                                          onPressed: () => publicRelationIdentificationImagesProvider.editIdentificationImages(context: context, publicRelationId: publicRelationModel.publicRelationId),
                                          buttonColor: ColorsManager.primaryColor,
                                          borderRadius: SizeManager.s10,
                                          text: Methods.getText(StringsManager.save, appProvider.isEnglish).toUpperCase(),
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
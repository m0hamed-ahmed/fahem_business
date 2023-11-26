import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/core/network/api_constants.dart';
import 'package:fahem_business/core/network/firebase_constants.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/services/notification_service.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/cache_helper.dart';
import 'package:fahem_business/core/utils/dialogs.dart';
import 'package:fahem_business/core/utils/enums.dart';
import 'package:fahem_business/core/utils/extensions.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/core/utils/upload_file_provider.dart';
import 'package:fahem_business/data/models/legal_accountant/legal_account_model.dart';
import 'package:fahem_business/domain/usecases/legal_accountant_identification_images/edit_legal_accountant_identification_images_usecase.dart';
import 'package:fahem_business/domain/usecases/shared/upload_file_usecase.dart';
import 'package:fahem_business/presentation/features/legal_accountant/legal_accountant/controllers/legal_accountant_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class LegalAccountantIdentificationImagesProvider with ChangeNotifier {
  final EditLegalAccountantIdentificationImagesUseCase _editLegalAccountantIdentificationImagesUseCase;

  LegalAccountantIdentificationImagesProvider(this._editLegalAccountantIdentificationImagesUseCase);

  Future<Either<Failure, LegalAccountantModel>> editLegalAccountantIdentificationImagesImpl(EditLegalAccountantIdentificationImagesParameters parameters) async {
    return await _editLegalAccountantIdentificationImagesUseCase.call(parameters);
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  changeIsLoading(bool isLoading) {_isLoading = isLoading; notifyListeners();}

  List<XFile> _images = [];
  List<XFile> get images => _images;
  setImages(List<XFile> images) => _images = images;
  addInImages(XFile image) {
    bool isFoundInList = _images.any((element) => element.name == image.name);
    if(!isFoundInList) {
      _images.add(image);
      notifyListeners();
    }
  }
  removeFromImages(int index) {
    _images.removeAt(index);
    notifyListeners();
  }
  List<String> _imagesNamesFromDatabase = [];
  List<String> get imagesNamesFromDatabase => _imagesNamesFromDatabase;
  setImagesNamesFromDatabase(List<String> imagesNamesFromDatabase) => _imagesNamesFromDatabase = imagesNamesFromDatabase;
  removeFromImagesNamesFromDatabase(int index) {
    imagesNamesFromDatabase.removeAt(index);
    notifyListeners();
  }

  Future<void> editIdentificationImages({required BuildContext context, required int legalAccountantId}) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    UploadFileProvider uploadFileProvider = Provider.of<UploadFileProvider>(context, listen: false);
    LegalAccountantProvider legalAccountantProvider = Provider.of<LegalAccountantProvider>(context, listen: false);

    changeIsLoading(true);

    for(int i=0; i<_images.length; i++) {
      // Upload Image
      UploadFileParameters uploadFileParameters = UploadFileParameters(
        file: File(_images[i].path),
        directory: ApiConstants.legalAccountantsIdentificationDirectory,
      );
      Either<Failure, String> response = await uploadFileProvider.uploadFileImpl(uploadFileParameters);
      response.fold((failure) async {
        changeIsLoading(false);
        Dialogs.failureOccurred(context, failure);
      }, (image) async {
        imagesNamesFromDatabase.add(image);
      });
    }

    // Edit LegalAccountant Identification Images
    EditLegalAccountantIdentificationImagesParameters parameters = EditLegalAccountantIdentificationImagesParameters(
      legalAccountantId: legalAccountantId,
      identificationImages: imagesNamesFromDatabase,
    );
    Either<Failure, LegalAccountantModel> response = await editLegalAccountantIdentificationImagesImpl(parameters);
    response.fold((failure) async {
      changeIsLoading(false);
      Dialogs.failureOccurred(context, failure);
    }, (legalAccountant) {
      changeIsLoading(false);
      CacheHelper.setData(key: PREFERENCES_KEY_ACCOUNT, value: json.encode(LegalAccountantModel.toMap(legalAccountant)));
      setImages([]);
      setImagesNamesFromDatabase(legalAccountant.identificationImages);
      legalAccountantProvider.changeLegalAccountant(legalAccountant);
      Dialogs.showBottomSheetMessage(
        context: context,
        message: Methods.getText(StringsManager.modifiedSuccessfully, appProvider.isEnglish).toTitleCase(),
        showMessage: ShowMessage.success,
      ).then((value) {
        NotificationService.pushNotification(
          topic: FirebaseConstants.fahemAdminTopic,
          title: 'قام ${legalAccountant.name} باضافة صور اثبات الهوية',
          body: 'قم بمراجعة حسابه الان',
        );
      });
    });
  }
}
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
import 'package:fahem_business/data/models/lawyers/lawyer_model.dart';
import 'package:fahem_business/domain/usecases/lawyer_identification_images/edit_lawyer_identification_images_usecase.dart';
import 'package:fahem_business/domain/usecases/shared/upload_file_usecase.dart';
import 'package:fahem_business/presentation/features/lawyer/lawyer/controllers/lawyer_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class LawyerIdentificationImagesProvider with ChangeNotifier {
  final EditLawyerIdentificationImagesUseCase _editLawyerIdentificationImagesUseCase;

  LawyerIdentificationImagesProvider(this._editLawyerIdentificationImagesUseCase);

  Future<Either<Failure, LawyerModel>> editLawyerIdentificationImagesImpl(EditLawyerIdentificationImagesParameters parameters) async {
    return await _editLawyerIdentificationImagesUseCase.call(parameters);
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  changeIsLoading(bool isLoading) {_isLoading = isLoading; notifyListeners();}

  // XFile? _nationalId;
  // XFile? get nationalId => _nationalId;
  // setNationalId(XFile? nationalId) => _nationalId = nationalId;
  // changeNationalId(XFile? nationalId) {_nationalId = nationalId; notifyListeners();}
  //
  // XFile? _commercialRegister;
  // XFile? get commercialRegister => _commercialRegister;
  // setCommercialRegister(XFile? commercialRegister) => _commercialRegister = commercialRegister;
  // changeCommercialRegister(XFile? commercialRegister) {_commercialRegister = commercialRegister; notifyListeners();}

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

  Future<void> editIdentificationImages({required BuildContext context, required int lawyerId}) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    UploadFileProvider uploadFileProvider = Provider.of<UploadFileProvider>(context, listen: false);
    LawyerProvider lawyerProvider = Provider.of<LawyerProvider>(context, listen: false);

    changeIsLoading(true);

    for(int i=0; i<_images.length; i++) {
      // Upload Image
      UploadFileParameters uploadFileParameters = UploadFileParameters(
        file: File(_images[i].path),
        directory: ApiConstants.lawyersIdentificationDirectory,
      );
      Either<Failure, String> response = await uploadFileProvider.uploadFileImpl(uploadFileParameters);
      response.fold((failure) async {
        changeIsLoading(false);
        Dialogs.failureOccurred(context, failure);
      }, (image) async {
        imagesNamesFromDatabase.add(image);
      });
    }

    // Edit Lawyer Identification Images
    EditLawyerIdentificationImagesParameters parameters = EditLawyerIdentificationImagesParameters(
      lawyerId: lawyerId,
      identificationImages: imagesNamesFromDatabase,
    );
    Either<Failure, LawyerModel> response = await editLawyerIdentificationImagesImpl(parameters);
    response.fold((failure) async {
      changeIsLoading(false);
      Dialogs.failureOccurred(context, failure);
    }, (lawyer) {
      changeIsLoading(false);
      CacheHelper.setData(key: PREFERENCES_KEY_ACCOUNT, value: json.encode(LawyerModel.toMap(lawyer)));
      setImages([]);
      setImagesNamesFromDatabase(lawyer.identificationImages);
      lawyerProvider.changeLawyer(lawyer);
      Dialogs.showBottomSheetMessage(
        context: context,
        message: Methods.getText(StringsManager.modifiedSuccessfully, appProvider.isEnglish).toTitleCase(),
        showMessage: ShowMessage.success,
      ).then((value) {
        NotificationService.pushNotification(
          topic: FirebaseConstants.fahemAdminTopic,
          title: 'قام ${lawyer.name} باضافة صور اثبات الهوية',
          body: 'قم بمراجعة حسابه الان',
        );
      });
    });
  }
}
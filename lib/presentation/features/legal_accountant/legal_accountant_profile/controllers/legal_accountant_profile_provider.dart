import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/core/network/api_constants.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/cache_helper.dart';
import 'package:fahem_business/core/utils/dialogs.dart';
import 'package:fahem_business/core/utils/enums.dart';
import 'package:fahem_business/core/utils/extensions.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/core/utils/upload_file_provider.dart';
import 'package:fahem_business/core/utils/validator.dart';
import 'package:fahem_business/data/models/legal_accountant/legal_account_model.dart';
import 'package:fahem_business/data/models/static/government_model.dart';
import 'package:fahem_business/domain/usecases/legal_accountants/edit_legal_accountant_usecase.dart';
import 'package:fahem_business/domain/usecases/shared/upload_file_usecase.dart';
import 'package:fahem_business/presentation/features/legal_accountant/legal_accountant/controllers/legal_accountant_provider.dart';
import 'package:fahem_business/presentation/features/legal_accountant/legal_accountant_profile/pages/legal_accountant_profile_account_data_page.dart';
import 'package:fahem_business/presentation/features/legal_accountant/legal_accountant_profile/pages/legal_accountant_profile_personal_data_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class LegalAccountantProfileProvider with ChangeNotifier {
  final EditLegalAccountantUseCase _editLegalAccountantUseCase;

  LegalAccountantProfileProvider(this._editLegalAccountantUseCase);

  Future<Either<Failure, LegalAccountantModel>> editLegalAccountantImpl(EditLegalAccountantParameters parameters) async {
    return await _editLegalAccountantUseCase.call(parameters);
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  changeIsLoading(bool isLoading) {_isLoading = isLoading; notifyListeners();}

  int _currentPage = 0;
  int get currentPage => _currentPage;
  setCurrentPage(int currentPage) => _currentPage = currentPage;
  changeCurrentPage(int currentPage) {_currentPage = currentPage; notifyListeners();}

  final List<Widget> _pages = const [
    LegalAccountantProfilePersonalDataPage(),
    LegalAccountantProfileAccountDataPage(),
  ];
  List<Widget> get pages => _pages;

  bool _isShowPassword = false;
  bool get isShowPassword => _isShowPassword;
  setIsShowPassword(bool isShowPassword) => _isShowPassword = isShowPassword;
  changeIsShowPassword() {_isShowPassword = !_isShowPassword; notifyListeners();}

  XFile? _image;
  XFile? get image => _image;
  setImage(XFile? image) => _image = image;
  changeImage(XFile? image) {_image = image; notifyListeners();}

  String imageNameFromDatabase = '';

  String? _name;
  String? get name => _name;
  setName(String? name) => _name = name;
  changeName(String? name) {_name = name; notifyListeners();}

  String? _emailAddress;
  String? get emailAddress => _emailAddress;
  setEmailAddress(String? emailAddress) => _emailAddress = emailAddress;
  changeEmailAddress(String? emailAddress) {_emailAddress = emailAddress; notifyListeners();}

  String? _password;
  String? get password => _password;
  setPassword(String? password) => _password = password;
  changePassword(String? password) {_password = password; notifyListeners();}

  GovernmentModel? _governmentModel;
  GovernmentModel? get governmentModel => _governmentModel;
  setGovernmentModel(GovernmentModel? governmentModel) => _governmentModel = governmentModel;
  changeGovernmentModel(GovernmentModel? governmentModel) {_governmentModel = governmentModel; notifyListeners();}

  String? _address;
  String? get address => _address;
  setAddress(String? address) => _address = address;
  changeAddress(String? address) {_address = address; notifyListeners();}

  String? _phoneNumber;
  String? get phoneNumber => _phoneNumber;
  setPhoneNumber(String? phoneNumber) => _phoneNumber = phoneNumber;
  changePhoneNumber(String? phoneNumber) {_phoneNumber = phoneNumber; notifyListeners();}

  String? _jobTitle;
  String? get jobTitle => _jobTitle;
  setJobTitle(String? jobTitle) => _jobTitle = jobTitle;
  changeJobTitle(String? jobTitle) {_jobTitle = jobTitle; notifyListeners();}

  String? _information;
  String? get information => _information;
  setInformation(String? information) => _information = information;
  changeInformation(String? information) {_information = information; notifyListeners();}

  String? _consultationPrice;
  String? get consultationPrice => _consultationPrice;
  setConsultationPrice(String? consultationPrice) => _consultationPrice = consultationPrice;
  changeConsultationPrice(String? consultationPrice) {_consultationPrice = consultationPrice; notifyListeners();}

  List<String> _tasks = [];
  List<String> get tasks => _tasks;
  setTasks(List<String> tasks) => _tasks = tasks;
  changeTasks(List<String> tasks) {_tasks = tasks; notifyListeners();}
  addInTasks(String task) {
    if(!_tasks.contains(task) && task.isNotEmpty) {
      _tasks.add(task);
      notifyListeners();
    }
  }
  removeFromTasks(String task) {
    _tasks.removeWhere((element) => element == task);
    notifyListeners();
  }

  List<XFile> _images = [];
  List<XFile> get images => _images;
  setImages(List<XFile> images) => _images = images;
  changeImages(List<XFile> images) {_images = images; notifyListeners();}
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
  List<String> imagesNamesFromDatabase = [];
  removeFromImagesNamesFromDatabase(int index) {
    imagesNamesFromDatabase.removeAt(index);
    notifyListeners();
  }

  Position? _position;
  Position? get position => _position;
  setPosition(Position? position) => _position = position;
  changePosition(Position? position) {_position = position; notifyListeners();}

  void onNextClicked(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if(_isAllDataValid(context)) {
      if(_currentPage == _pages.length-1) {
        editLegalAccountant(context: context);
      }
      else if(_currentPage < _pages.length-1) {
        changeCurrentPage(++_currentPage);
      }
    }
  }

  bool _isAllDataValid (BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    if(_currentPage == 0) {
      if(_name == null) {
        Dialogs.showBottomSheetMessage(context: context, message: Methods.getText(StringsManager.nameRequired, appProvider.isEnglish).toCapitalized());
        return false;
      }
      else if(_emailAddress == null) {
        Dialogs.showBottomSheetMessage(context: context, message: Methods.getText(StringsManager.emailAddressRequired, appProvider.isEnglish).toCapitalized());
        return false;
      }
      else if(!Validator.isEmailAddressValid(_emailAddress!)) {
        Dialogs.showBottomSheetMessage(context: context, message: Methods.getText(StringsManager.pleaseEnterAValidEmailAddress, appProvider.isEnglish).toCapitalized());
        return false;
      }
      else if(_password == null) {
        Dialogs.showBottomSheetMessage(context: context, message: Methods.getText(StringsManager.passwordRequired, appProvider.isEnglish).toCapitalized());
        return false;
      }
      else if(_password!.length < 6) {
        Dialogs.showBottomSheetMessage(context: context, message: Methods.getText(StringsManager.passwordMustNotBeLessThan6Characters, appProvider.isEnglish).toCapitalized());
        return false;
      }
      else if(_governmentModel == null) {
        Dialogs.showBottomSheetMessage(context: context, message: Methods.getText(StringsManager.governmentRequired, appProvider.isEnglish).toCapitalized());
        return false;
      }
      else if(_address == null) {
        Dialogs.showBottomSheetMessage(context: context, message: Methods.getText(StringsManager.addressRequired, appProvider.isEnglish).toCapitalized());
        return false;
      }
      else if(_phoneNumber == null) {
        Dialogs.showBottomSheetMessage(context: context, message: Methods.getText(StringsManager.phoneNumberRequired, appProvider.isEnglish).toCapitalized());
        return false;
      }
      else if(!Validator.isPhoneNumberValid(_phoneNumber!)) {
        Dialogs.showBottomSheetMessage(context: context, message: Methods.getText(StringsManager.phoneNumberIsIncorrect, appProvider.isEnglish).toCapitalized());
        return false;
      }
    }
    else if(_currentPage == 1) {
      if(_jobTitle == null) {
        Dialogs.showBottomSheetMessage(context: context, message: Methods.getText(StringsManager.jobTitleRequired, appProvider.isEnglish).toCapitalized());
        return false;
      }
      else if(_information == null) {
        Dialogs.showBottomSheetMessage(context: context, message: Methods.getText(StringsManager.informationRequired, appProvider.isEnglish).toCapitalized());
        return false;
      }
      else if(_consultationPrice == null) {
        Dialogs.showBottomSheetMessage(context: context, message: Methods.getText(StringsManager.consultationPriceRequired, appProvider.isEnglish).toCapitalized());
        return false;
      }
      else if(!Validator.isIntegerNumber(_consultationPrice!)) {
        Dialogs.showBottomSheetMessage(context: context, message: Methods.getText(StringsManager.theConsultationPriceMustBeAnIntegerNumber, appProvider.isEnglish).toCapitalized());
        return false;
      }
      else if(_tasks.isEmpty) {
        Dialogs.showBottomSheetMessage(context: context, message: Methods.getText(StringsManager.tasksRequired, appProvider.isEnglish).toCapitalized());
        return false;
      }
      else if(_position == null) {
        Dialogs.showBottomSheetMessage(context: context, message: Methods.getText(StringsManager.locationRequired, appProvider.isEnglish).toCapitalized());
        return false;
      }
    }
    return true;
  }

  void onPreviousClicked(BuildContext context) {
    if(_currentPage == 0) {
      Navigator.pop(context);
    }
    else if(_currentPage > 0) {
      changeCurrentPage(--_currentPage);
    }
  }

  Future<bool> onBackPressed(BuildContext context) async {
    if(_currentPage == 0) {
      Navigator.pop(context);
    }
    else if(_currentPage > 0) {
      changeCurrentPage(--_currentPage);
      return await Future.value(false);
    }
    return await Future.value(true);
  }

  void resetAllData() {
    setCurrentPage(0);
    setIsShowPassword(false);
    setImage(null);
    setName(null);
    setEmailAddress(null);
    setPassword(null);
    setGovernmentModel(null);
    setAddress(null);
    setPhoneNumber(null);
    setJobTitle(null);
    setInformation(null);
    setConsultationPrice(null);
    setTasks([]);
    setImages([]);
    setPosition(null);
  }

  Future<void> editLegalAccountant({required BuildContext context}) async {
    LegalAccountantModel accountModel = LegalAccountantModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT)));

    LegalAccountantModel legalAccountantModel = LegalAccountantModel(
      legalAccountantId: accountModel.legalAccountantId,
      name: _name!,
      emailAddress: _emailAddress!,
      password: _password!,
      mainCategory: accountModel.mainCategory,
      personalImage: accountModel.personalImage,
      jobTitle: _jobTitle!,
      address: _address!,
      information: _information!,
      phoneNumber: _phoneNumber!,
      consultationPrice: int.parse(_consultationPrice!),
      tasks: _tasks,
      features: accountModel.features,
      images: imagesNamesFromDatabase,
      latitude: _position!.latitude,
      longitude: _position!.longitude,
      governorate: _governmentModel!.nameAr,
      accountStatus: accountModel.accountStatus,
      isVerified: accountModel.isVerified,
      isBookingByAppointment: accountModel.isBookingByAppointment,
      availablePeriods: accountModel.availablePeriods,
      identificationImages: accountModel.identificationImages,
      rating: accountModel.rating,
      createdAt: accountModel.createdAt,
    );

    if(_image == null && _images.isEmpty) {
      _editLegalAccountantWithoutImageAndWithoutImages(context, legalAccountantModel);
    }
    else if(_image != null && _images.isNotEmpty) {
      _editLegalAccountantWithImageAndWithImages(context, legalAccountantModel);
    }
    else if(_image == null && _images.isNotEmpty) {
      _editLegalAccountantWithoutImageAndWithImages(context, legalAccountantModel);
    }
    else if(_image != null && _images.isEmpty) {
      _editLegalAccountantWithImageAndWithoutImages(context, legalAccountantModel);
    }
  }

  Future<void> _editLegalAccountantWithoutImageAndWithoutImages(BuildContext context, LegalAccountantModel legalAccountantModel) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    LegalAccountantProvider legalAccountantProvider = Provider.of<LegalAccountantProvider>(context, listen: false);

    changeIsLoading(true);

    // Edit LegalAccountant
    EditLegalAccountantParameters parameters = EditLegalAccountantParameters(
      legalAccountantModel: legalAccountantModel,
    );
    Either<Failure, LegalAccountantModel> response = await editLegalAccountantImpl(parameters);
    response.fold((failure) async {
      changeIsLoading(false);
      Dialogs.failureOccurred(context, failure);
    }, (legalAccountant) {
      changeIsLoading(false);
      CacheHelper.setData(key: PREFERENCES_KEY_ACCOUNT, value: json.encode(LegalAccountantModel.toMap(legalAccountant)));
      legalAccountantProvider.changeLegalAccountant(legalAccountant);
      Dialogs.showBottomSheetMessage(context: context, message: Methods.getText(StringsManager.modifiedSuccessfully, appProvider.isEnglish).toTitleCase(), showMessage: ShowMessage.success);
    });
  }

  Future<void> _editLegalAccountantWithImageAndWithImages(BuildContext context, LegalAccountantModel legalAccountantModel) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    UploadFileProvider uploadFileProvider = Provider.of<UploadFileProvider>(context, listen: false);
    LegalAccountantProvider legalAccountantProvider = Provider.of<LegalAccountantProvider>(context, listen: false);

    changeIsLoading(true);

    // Upload Image
    UploadFileParameters uploadFileParameters = UploadFileParameters(
      file: File(_image!.path),
      directory: ApiConstants.legalAccountantsDirectory,
    );
    Either<Failure, String> response = await uploadFileProvider.uploadFileImpl(uploadFileParameters);
    response.fold((failure) async {
      changeIsLoading(false);
      Dialogs.failureOccurred(context, failure);
    }, (image) async {
      legalAccountantModel.personalImage = image;

      for(int i=0; i<_images.length; i++) {
        // Upload Image
        UploadFileParameters uploadFileParameters = UploadFileParameters(
          file: File(_images[i].path),
          directory: ApiConstants.legalAccountantsGalleryDirectory,
        );
        Either<Failure, String> response = await uploadFileProvider.uploadFileImpl(uploadFileParameters);
        response.fold((failure) async {
          changeIsLoading(false);
          Dialogs.failureOccurred(context, failure);
        }, (image) async {
          legalAccountantModel.images.add(image);
        });
      }

      // Edit LegalAccountant
      EditLegalAccountantParameters parameters = EditLegalAccountantParameters(
        legalAccountantModel: legalAccountantModel,
      );
      Either<Failure, LegalAccountantModel> response = await editLegalAccountantImpl(parameters);
      response.fold((failure) async {
        changeIsLoading(false);
        Dialogs.failureOccurred(context, failure);
      }, (legalAccountant) {
        changeIsLoading(false);
        CacheHelper.setData(key: PREFERENCES_KEY_ACCOUNT, value: json.encode(LegalAccountantModel.toMap(legalAccountant)));
        legalAccountantProvider.changeLegalAccountant(legalAccountant);
        imageNameFromDatabase = image;
        changeImage(null);
        imagesNamesFromDatabase = legalAccountantModel.images;
        changeImages([]);
        Dialogs.showBottomSheetMessage(context: context, message: Methods.getText(StringsManager.modifiedSuccessfully, appProvider.isEnglish).toTitleCase(), showMessage: ShowMessage.success);
      });
    });
  }

  Future<void> _editLegalAccountantWithoutImageAndWithImages(BuildContext context, LegalAccountantModel legalAccountantModel) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    UploadFileProvider uploadFileProvider = Provider.of<UploadFileProvider>(context, listen: false);
    LegalAccountantProvider legalAccountantProvider = Provider.of<LegalAccountantProvider>(context, listen: false);

    changeIsLoading(true);

    for(int i=0; i<_images.length; i++) {
      // Upload Image
      UploadFileParameters uploadFileParameters = UploadFileParameters(
        file: File(_images[i].path),
        directory: ApiConstants.legalAccountantsGalleryDirectory,
      );
      Either<Failure, String> response = await uploadFileProvider.uploadFileImpl(uploadFileParameters);
      response.fold((failure) async {
        changeIsLoading(false);
        Dialogs.failureOccurred(context, failure);
      }, (image) async {
        legalAccountantModel.images.add(image);
      });
    }

    // Edit LegalAccountant
    EditLegalAccountantParameters parameters = EditLegalAccountantParameters(
      legalAccountantModel: legalAccountantModel,
    );
    Either<Failure, LegalAccountantModel> response = await editLegalAccountantImpl(parameters);
    response.fold((failure) async {
      changeIsLoading(false);
      Dialogs.failureOccurred(context, failure);
    }, (legalAccountant) {
      changeIsLoading(false);
      CacheHelper.setData(key: PREFERENCES_KEY_ACCOUNT, value: json.encode(LegalAccountantModel.toMap(legalAccountant)));
      legalAccountantProvider.changeLegalAccountant(legalAccountant);
      imagesNamesFromDatabase = legalAccountantModel.images;
      changeImages([]);
      Dialogs.showBottomSheetMessage(context: context, message: Methods.getText(StringsManager.modifiedSuccessfully, appProvider.isEnglish).toTitleCase(), showMessage: ShowMessage.success);
    });
  }

  Future<void> _editLegalAccountantWithImageAndWithoutImages(BuildContext context, LegalAccountantModel legalAccountantModel) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    UploadFileProvider uploadFileProvider = Provider.of<UploadFileProvider>(context, listen: false);
    LegalAccountantProvider legalAccountantProvider = Provider.of<LegalAccountantProvider>(context, listen: false);

    changeIsLoading(true);

    // Upload Image
    UploadFileParameters uploadFileParameters = UploadFileParameters(
      file: File(_image!.path),
      directory: ApiConstants.legalAccountantsDirectory,
    );
    Either<Failure, String> response = await uploadFileProvider.uploadFileImpl(uploadFileParameters);
    response.fold((failure) async {
      changeIsLoading(false);
      Dialogs.failureOccurred(context, failure);
    }, (image) async {
      // Edit LegalAccountant
      legalAccountantModel.personalImage = image;
      EditLegalAccountantParameters parameters = EditLegalAccountantParameters(
        legalAccountantModel: legalAccountantModel,
      );
      Either<Failure, LegalAccountantModel> response = await editLegalAccountantImpl(parameters);
      response.fold((failure) async {
        changeIsLoading(false);
        Dialogs.failureOccurred(context, failure);
      }, (legalAccountant) {
        changeIsLoading(false);
        CacheHelper.setData(key: PREFERENCES_KEY_ACCOUNT, value: json.encode(LegalAccountantModel.toMap(legalAccountant)));
        legalAccountantProvider.changeLegalAccountant(legalAccountant);
        imageNameFromDatabase = image;
        changeImage(null);
        Dialogs.showBottomSheetMessage(context: context, message: Methods.getText(StringsManager.modifiedSuccessfully, appProvider.isEnglish).toTitleCase(), showMessage: ShowMessage.success);
      });
    });
  }
}
import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/core/network/api_constants.dart';
import 'package:fahem_business/core/network/firebase_constants.dart';
import 'package:fahem_business/core/resources/constants_manager.dart';
import 'package:fahem_business/core/resources/routes_manager.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/services/notification_service.dart';
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
import 'package:fahem_business/domain/usecases/legal_accountants/insert_legal_accountant_usecase.dart';
import 'package:fahem_business/domain/usecases/legal_accountants/is_all_legal_accountant_data_valid_usecase.dart';
import 'package:fahem_business/domain/usecases/shared/upload_file_usecase.dart';
import 'package:fahem_business/presentation/features/authentication/pages/legal_accountant_account_data_page.dart';
import 'package:fahem_business/presentation/features/authentication/pages/legal_accountant_personal_data_page.dart';
import 'package:fahem_business/presentation/features/legal_accountant/legal_accountant/controllers/legal_accountant_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RegisterLegalAccountantProvider with ChangeNotifier {

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  changeIsLoading(bool isLoading) {_isLoading = isLoading; notifyListeners();}

  int _currentPage = 0;
  int get currentPage => _currentPage;
  setCurrentPage(int currentPage) => _currentPage = currentPage;
  changeCurrentPage(int currentPage) {_currentPage = currentPage; notifyListeners();}

  final List<Widget> _pages = const [
    LegalAccountantPersonalDataPage(),
    LegalAccountantAccountDataPage(),
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

  Position? _position;
  Position? get position => _position;
  setPosition(Position? position) => _position = position;
  changePosition(Position? position) {_position = position; notifyListeners();}

  bool _isDetectLocationClicked = false;
  bool get isDetectLocationClicked => _isDetectLocationClicked;
  setIsDetectLocationClicked(bool isDetectLocationClicked) => _isDetectLocationClicked = isDetectLocationClicked;
  changeIsDetectLocationClicked(bool isDetectLocationClicked) {_isDetectLocationClicked = isDetectLocationClicked; notifyListeners();}

  void onNextClicked(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if(_isAllDataValid(context)) {
      if(_currentPage == _pages.length-1) {
        insertLegalAccountant(context: context);
      }
      else if(_currentPage < _pages.length-1) {
        changeCurrentPage(++_currentPage);
      }
    }
  }

  bool _isAllDataValid (BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    if(_currentPage == 0) {
      if(_image == null) {
        Dialogs.showBottomSheetMessage(context: context, message: Methods.getText(StringsManager.personalImageRequired, appProvider.isEnglish).toCapitalized());
        return false;
      }
      else if(_name == null) {
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
    setIsDetectLocationClicked(false);
  }

  Future<void> insertLegalAccountant({required BuildContext context}) async {
    LegalAccountantProvider legalAccountantProvider = Provider.of<LegalAccountantProvider>(context, listen: false);

    changeIsLoading(true);

    // Is All LegalAccountant Data Valid
    IsAllLegalAccountantDataValidParameters parameters = IsAllLegalAccountantDataValidParameters(
      emailAddress: _emailAddress!,
      password: _password!,
      phoneNumber: _phoneNumber!,
    );
    Either<Failure, bool> response = await legalAccountantProvider.isAllLegalAccountantDataValidImpl(parameters);
    response.fold((failure) async {
      changeIsLoading(false);
      Dialogs.failureOccurred(context, failure);
    }, (isAllDataValid) async {
      UploadFileProvider uploadFileProvider = Provider.of<UploadFileProvider>(context, listen: false);

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
        LegalAccountantModel legalAccountantModel = LegalAccountantModel(
          legalAccountantId: 0,
          name: _name!,
          emailAddress: _emailAddress!,
          password: _password!,
          mainCategory: 'legal_accountants',
          personalImage: image,
          jobTitle: _jobTitle!,
          address: _address!,
          information: _information!,
          phoneNumber: _phoneNumber!,
          consultationPrice: int.parse(_consultationPrice!),
          tasks: _tasks,
          features: [],
          images: [],
          latitude: _position!.latitude,
          longitude: _position!.longitude,
          governorate: _governmentModel!.nameAr,
          accountStatus: AccountStatus.pending,
          isVerified: false,
          isBookingByAppointment: false,
          availablePeriods: [],
          identificationImages: [],
          rating: 0,
          createdAt: DateTime.now(),
        );
        if(_images.isEmpty) {await insertLegalAccountantWithoutImages(context: context, legalAccountantModel: legalAccountantModel);}
        else {await insertLegalAccountantWithImages(context: context, legalAccountantModel: legalAccountantModel);}
      });
    });
  }

  Future<void> insertLegalAccountantWithoutImages({required BuildContext context, required LegalAccountantModel legalAccountantModel}) async {
    LegalAccountantProvider legalAccountantProvider = Provider.of<LegalAccountantProvider>(context, listen: false);

    // Insert LegalAccountant
    InsertLegalAccountantParameters parameters = InsertLegalAccountantParameters(
      legalAccountantModel: legalAccountantModel,
    );
    Either<Failure, LegalAccountantModel> response = await legalAccountantProvider.insertLegalAccountantImpl(parameters);
    response.fold((failure) async {
      changeIsLoading(false);
      Dialogs.failureOccurred(context, failure);
    }, (legalAccountant) async {
      await NotificationService.subscribeToTopic(FirebaseConstants.fahemBusinessTopic).then((value) async {
        await NotificationService.subscribeToTopic('${legalAccountant.legalAccountantId}${ConstantsManager.fahemBusinessLegalAccountantsKeyword}').then((value) {
          NotificationService.createLocalNotification(title: 'اهلا ${legalAccountant.name}', body: 'مرحبا بك فى فاهم نحن سعداء بتواجدك معنا');
          changeIsLoading(false);
          CacheHelper.setData(key: PREFERENCES_KEY_IS_LOGGED, value: true);
          CacheHelper.setData(key: PREFERENCES_KEY_ACCOUNT_TYPE, value: AccountTypeEnum.legalAccountants.name);
          CacheHelper.setData(key: PREFERENCES_KEY_ACCOUNT, value: json.encode(LegalAccountantModel.toMap(legalAccountant)));
          legalAccountantProvider.changeLegalAccountant(legalAccountant);
          resetAllData();
          Navigator.pushReplacementNamed(context, Routes.splashRoute);
        }).catchError((error) {
          changeIsLoading(false);
        });
      }).catchError((error) {
        changeIsLoading(false);
      });
    });
  }

  Future<void> insertLegalAccountantWithImages({required BuildContext context, required LegalAccountantModel legalAccountantModel}) async {
    UploadFileProvider uploadFileProvider = Provider.of<UploadFileProvider>(context, listen: false);
    LegalAccountantProvider legalAccountantProvider = Provider.of<LegalAccountantProvider>(context, listen: false);

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

    // Insert Legal Accountant
    InsertLegalAccountantParameters parameters = InsertLegalAccountantParameters(
      legalAccountantModel: legalAccountantModel,
    );
    Either<Failure, LegalAccountantModel> response = await legalAccountantProvider.insertLegalAccountantImpl(parameters);
    response.fold((failure) async {
      changeIsLoading(false);
      Dialogs.failureOccurred(context, failure);
    }, (legalAccountant) async {
      await NotificationService.subscribeToTopic(FirebaseConstants.fahemBusinessTopic).then((value) async {
        await NotificationService.subscribeToTopic('${legalAccountant.legalAccountantId}${ConstantsManager.fahemBusinessLegalAccountantsKeyword}').then((value) {
          NotificationService.createLocalNotification(title: 'اهلا ${legalAccountant.name}', body: 'مرحبا بك فى فاهم نحن سعداء بتواجدك معنا');
          changeIsLoading(false);
          CacheHelper.setData(key: PREFERENCES_KEY_IS_LOGGED, value: true);
          CacheHelper.setData(key: PREFERENCES_KEY_ACCOUNT_TYPE, value: AccountTypeEnum.legalAccountants.name);
          CacheHelper.setData(key: PREFERENCES_KEY_ACCOUNT, value: json.encode(LegalAccountantModel.toMap(legalAccountant)));
          legalAccountantProvider.changeLegalAccountant(legalAccountant);
          resetAllData();
          Navigator.pushReplacementNamed(context, Routes.splashRoute);
        }).catchError((error) {
          changeIsLoading(false);
        });
      }).catchError((error) {
        changeIsLoading(false);
      });
    });
  }
}
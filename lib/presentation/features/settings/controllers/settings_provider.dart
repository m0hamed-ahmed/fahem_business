import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/cache_helper.dart';
import 'package:fahem_business/core/utils/dialogs.dart';
import 'package:fahem_business/core/utils/enums.dart';
import 'package:fahem_business/core/utils/extensions.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/data/models/lawyers/lawyer_model.dart';
import 'package:fahem_business/data/models/legal_accountant/legal_account_model.dart';
import 'package:fahem_business/data/models/public_relations/public_relation_model.dart';
import 'package:fahem_business/domain/usecases/lawyers/edit_lawyer_booking_by_appointment_usecase.dart';
import 'package:fahem_business/domain/usecases/legal_accountants/edit_legal_accountant_booking_by_appointment_usecase.dart';
import 'package:fahem_business/domain/usecases/public_relations/edit_public_relation_booking_by_appointment_usecase.dart';
import 'package:fahem_business/presentation/features/lawyer/lawyer/controllers/lawyer_provider.dart';
import 'package:fahem_business/presentation/features/legal_accountant/legal_accountant/controllers/legal_accountant_provider.dart';
import 'package:fahem_business/presentation/features/public_relation/public_relation/controllers/public_relation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsProvider with ChangeNotifier {
  final EditLawyerBookingByAppointmentUseCase _editLawyerBookingByAppointmentUseCase;
  final EditPublicRelationBookingByAppointmentUseCase _editPublicRelationBookingByAppointmentUseCase;
  final EditLegalAccountantBookingByAppointmentUseCase _editLegalAccountantBookingByAppointmentUseCase;

  SettingsProvider(
    this._editLawyerBookingByAppointmentUseCase,
    this._editPublicRelationBookingByAppointmentUseCase,
    this._editLegalAccountantBookingByAppointmentUseCase,
  );

  Future<Either<Failure, LawyerModel>> _editLawyerBookingByAppointmentImpl(EditLawyerBookingByAppointmentParameters parameters) async {
    return await _editLawyerBookingByAppointmentUseCase.call(parameters);
  }

  Future<Either<Failure, PublicRelationModel>> _editPublicRelationBookingByAppointmentImpl(EditPublicRelationBookingByAppointmentParameters parameters) async {
    return await _editPublicRelationBookingByAppointmentUseCase.call(parameters);
  }

  Future<Either<Failure, LegalAccountantModel>> _editLegalAccountantBookingByAppointmentImpl(EditLegalAccountantBookingByAppointmentParameters parameters) async {
    return await _editLegalAccountantBookingByAppointmentUseCase.call(parameters);
  }

  bool _isButtonClicked = false;
  bool get isButtonClicked => _isButtonClicked;
  setIsButtonClicked(bool isButtonClicked) => _isButtonClicked = isButtonClicked;
  changeIsButtonClicked(bool isButtonClicked) {_isButtonClicked = isButtonClicked; notifyListeners();}

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  changeIsLoading(bool isLoading) {_isLoading = isLoading; notifyListeners();}

  bool _isBookingByAppointment = false;
  bool get isBookingByAppointment => _isBookingByAppointment;
  setIsBookingByAppointment(bool isBookingByAppointment) => _isBookingByAppointment = isBookingByAppointment;
  changeIsBookingByAppointment(bool isBookingByAppointment) {_isBookingByAppointment = isBookingByAppointment; notifyListeners();}

  List<String> _selectedPeriods = [];
  List<String> get selectedPeriods => _selectedPeriods;
  setSelectedPeriods(List<String> selectedPeriods) => _selectedPeriods = selectedPeriods;
  toggleSelectedPeriod(String periodId) {
    if(_selectedPeriods.contains(periodId)) {
      _selectedPeriods.removeWhere((element) => element == periodId);
    }
    else {
      _selectedPeriods.add(periodId);
    }
    notifyListeners();
  }

  void resetAllData() {
    setIsButtonClicked(false);
  }

  bool isAllDataValid() {
    if(_isBookingByAppointment && _selectedPeriods.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> onPressedSaveBookingByAppointment(BuildContext context) async {
    String accountType = CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT_TYPE);
    String accountCached = CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT);

    if(accountType == AccountTypeEnum.lawyers.name) {
      LawyerModel lawyerModel = LawyerModel.fromJson(json.decode(accountCached));
      EditLawyerBookingByAppointmentParameters editLawyerBookingByAppointmentParameters = EditLawyerBookingByAppointmentParameters(
        lawyerId: lawyerModel.lawyerId,
        isBookingByAppointment: _isBookingByAppointment,
        availablePeriods: _isBookingByAppointment ? _selectedPeriods : [],
      );
      _editLawyerBookingByAppointment(context: context, parameters: editLawyerBookingByAppointmentParameters);
    }
    else if(accountType == AccountTypeEnum.publicRelations.name) {
      PublicRelationModel publicRelationModel = PublicRelationModel.fromJson(json.decode(accountCached));
      EditPublicRelationBookingByAppointmentParameters editPublicRelationBookingByAppointmentParameters = EditPublicRelationBookingByAppointmentParameters(
        publicRelationId: publicRelationModel.publicRelationId,
        isBookingByAppointment: _isBookingByAppointment,
        availablePeriods: _isBookingByAppointment ? _selectedPeriods : [],
      );
      _editPublicRelationBookingByAppointment(context: context, parameters: editPublicRelationBookingByAppointmentParameters);
    }
    else {
      LegalAccountantModel legalAccountantModel = LegalAccountantModel.fromJson(json.decode(accountCached));
      EditLegalAccountantBookingByAppointmentParameters editLegalAccountantBookingByAppointmentParameters = EditLegalAccountantBookingByAppointmentParameters(
        legalAccountantId: legalAccountantModel.legalAccountantId,
        isBookingByAppointment: _isBookingByAppointment,
        availablePeriods: _isBookingByAppointment ? _selectedPeriods : [],
      );
      _editLegalAccountantBookingByAppointment(context: context, parameters: editLegalAccountantBookingByAppointmentParameters);
    }
  }

  Future<void> _editLawyerBookingByAppointment({required BuildContext context, required EditLawyerBookingByAppointmentParameters parameters}) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    LawyerProvider lawyerProvider = Provider.of<LawyerProvider>(context, listen: false);

    changeIsLoading(true);

    // Edit Lawyer Booking By Appointment
    Either<Failure, LawyerModel> response = await _editLawyerBookingByAppointmentImpl(parameters);
    response.fold((failure) async {
      changeIsLoading(false);
      Dialogs.failureOccurred(context, failure);
    }, (lawyer) {
      changeIsLoading(false);
      CacheHelper.setData(key: PREFERENCES_KEY_ACCOUNT, value: json.encode(LawyerModel.toMap(lawyer)));
      lawyerProvider.changeLawyer(lawyer);
      Dialogs.showBottomSheetMessage(context: context, message: Methods.getText(StringsManager.modifiedSuccessfully, appProvider.isEnglish).toTitleCase(), showMessage: ShowMessage.success);
    });
  }

  Future<void> _editPublicRelationBookingByAppointment({required BuildContext context, required EditPublicRelationBookingByAppointmentParameters parameters}) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    PublicRelationProvider publicRelationProvider = Provider.of<PublicRelationProvider>(context, listen: false);

    changeIsLoading(true);

    // Edit PublicRelation Booking By Appointment
    Either<Failure, PublicRelationModel> response = await _editPublicRelationBookingByAppointmentImpl(parameters);
    response.fold((failure) async {
      changeIsLoading(false);
      Dialogs.failureOccurred(context, failure);
    }, (publicRelation) {
      changeIsLoading(false);
      CacheHelper.setData(key: PREFERENCES_KEY_ACCOUNT, value: json.encode(PublicRelationModel.toMap(publicRelation)));
      publicRelationProvider.changePublicRelation(publicRelation);
      Dialogs.showBottomSheetMessage(context: context, message: Methods.getText(StringsManager.modifiedSuccessfully, appProvider.isEnglish).toTitleCase(), showMessage: ShowMessage.success);
    });
  }

  Future<void> _editLegalAccountantBookingByAppointment({required BuildContext context, required EditLegalAccountantBookingByAppointmentParameters parameters}) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    LegalAccountantProvider legalAccountantProvider = Provider.of<LegalAccountantProvider>(context, listen: false);

    changeIsLoading(true);

    // Edit LegalAccountant Booking By Appointment
    Either<Failure, LegalAccountantModel> response = await _editLegalAccountantBookingByAppointmentImpl(parameters);
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
}
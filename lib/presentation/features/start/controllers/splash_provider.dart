import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/core/resources/constants_manager.dart';
import 'package:fahem_business/core/resources/routes_manager.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/utils/cache_helper.dart';
import 'package:fahem_business/core/utils/dialogs.dart';
import 'package:fahem_business/core/utils/enums.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/data/models/employment_applications/employment_application_model.dart';
import 'package:fahem_business/data/models/lawyers/lawyer_model.dart';
import 'package:fahem_business/data/models/legal_accountant/legal_account_model.dart';
import 'package:fahem_business/data/models/legal_accountants_reviews/legal_account_review_model.dart';
import 'package:fahem_business/data/models/public_relations/public_relation_model.dart';
import 'package:fahem_business/data/models/transactions/transaction_model.dart';
import 'package:fahem_business/data/models/jobs/job_model.dart';
import 'package:fahem_business/data/models/lawyers_reviews/lawyer_review_model.dart';
import 'package:fahem_business/data/models/public_relations_reviews/public_relation_review_model.dart';
import 'package:fahem_business/data/models/version/version_model.dart';
import 'package:fahem_business/domain/usecases/booking_appointments/get_booking_appointments_for_target__usecase.dart';
import 'package:fahem_business/domain/usecases/employment_applications/get_employment_applications_for_target_usecase.dart';
import 'package:fahem_business/domain/usecases/instant_consultations/get_all_instant_consultations_for_lawyer_usecase.dart';
import 'package:fahem_business/domain/usecases/jobs/get_jobs_for_target_usecase.dart';
import 'package:fahem_business/domain/usecases/lawyers/get_lawyer_usecase.dart';
import 'package:fahem_business/domain/usecases/lawyers_reviews/get_lawyers_reviews_for_one_usecase.dart';
import 'package:fahem_business/domain/usecases/legal_accountants/get_legal_accountant_usecase.dart';
import 'package:fahem_business/domain/usecases/legal_accountants_reviews/get_legal_accountants_reviews_for_one_usecase.dart';
import 'package:fahem_business/domain/usecases/public_relations/get_public_relation_usecase.dart';
import 'package:fahem_business/domain/usecases/public_relations_reviews/get_public_relations_reviews_for_one_usecase.dart';
import 'package:fahem_business/domain/usecases/transaction_type_show_numbers/get_transaction_type_show_numbers_for_target_usecase.dart';
import 'package:fahem_business/presentation/features/start/controllers/version_provider.dart';
import 'package:fahem_business/presentation/features/transactions/booking_appointments/controllers/booking_appointments_provider.dart';
import 'package:fahem_business/presentation/features/jobs/employment_applications/controllers/employment_applications_provider.dart';
import 'package:fahem_business/presentation/features/transactions/instant_consultations/controllers/instant_consultations_provider.dart';
import 'package:fahem_business/presentation/features/jobs/jobs/controllers/jobs_provider.dart';
import 'package:fahem_business/presentation/features/lawyer/lawyer/controllers/lawyer_provider.dart';
import 'package:fahem_business/presentation/features/lawyer/lawyer_reviews/controllers/lawyer_reviews_provider.dart';
import 'package:fahem_business/presentation/features/legal_accountant/legal_accountant/controllers/legal_accountant_provider.dart';
import 'package:fahem_business/presentation/features/legal_accountant/legal_accountant_reviews/controllers/legal_accountant_reviews_provider.dart';
import 'package:fahem_business/presentation/features/public_relation/public_relation/controllers/public_relation_provider.dart';
import 'package:fahem_business/presentation/features/public_relation/public_relation_reviews/controllers/public_relation_reviews_provider.dart';
import 'package:fahem_business/presentation/features/transactions/request_the_phone_number/controllers/request_the_phone_number_provider.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class SplashProvider with ChangeNotifier {

  bool _isGetDataDone = false;
  setIsGetDataDone(bool isGetDataDone) => _isGetDataDone = isGetDataDone;

  bool _isErrorOccurred = false;
  bool get isErrorOccurred => _isErrorOccurred;
  changeIsErrorOccurred(bool isErrorOccurred) {_isErrorOccurred = isErrorOccurred; notifyListeners();}

  Timer? _loadingTimer;
  setLoadingTimer(Timer? loadingTimer) => _loadingTimer = loadingTimer;

  int _loadingCount = 0;
  int get loadingCount => _loadingCount;
  changeLoadingCount(int loadingCount) {_loadingCount = loadingCount; notifyListeners();}

  void _startLoading() {
    _loadingTimer ??= Timer.periodic(const Duration(milliseconds: ConstantsManager.splashLoadingDuration), (timer) {
      changeLoadingCount(++_loadingCount);
    });
  }

  void _cancelLoading() {
    _loadingTimer?.cancel();
    setLoadingTimer(null);
  }

  Future<void> getVersionAndGetData(BuildContext context) async {
    if(Platform.isAndroid) {
      await _getVersion(context);
    }
    else {
      await getData(context: context);
    }
  }

  Future<void> _getVersion(BuildContext context) async {
    VersionProvider versionProvider = Provider.of<VersionProvider>(context, listen: false);

    Either<Failure, VersionModel> response = await versionProvider.getVersionImpl();
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (versionModel) async {
      if(versionModel.isReview) {
        await getData(context: context);
      }
      else {
        await _isAppNeedToUpdate(versionModel).then((value) async {
          if(value) {
            await _updateApp(context, versionModel.isMustUpdate ? true : false);
          }
          else {
            await getData(context: context);
          }
        });
      }
    });
  }

  Future<bool> _isAppNeedToUpdate(VersionModel versionModel) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version != versionModel.version;
  }

  Future<void> _updateApp(BuildContext context, bool isMustUpdate) async {
    if(isMustUpdate) {
      _removeDataFromCache();
    }

    await Dialogs.showUpdateDialog(context, StringsManager.update, StringsManager.updateMsg, isMustUpdate: isMustUpdate).then((value) async {
      if(value) {
        await Methods.openUrl(ConstantsManager.fahemBusinessPlayStoreUrl).then((value) {
          Navigator.pop(context);
        });
      }
      else {
        if(!isMustUpdate) {
          await getData(context: context);
        }
      }
    });
  }

  Future<void> _removeDataFromCache() async {
    CacheHelper.removeData(key: PREFERENCES_KEY_IS_LOGGED);
    CacheHelper.removeData(key: PREFERENCES_KEY_ACCOUNT_TYPE);
    CacheHelper.removeData(key: PREFERENCES_KEY_ACCOUNT);
  }

  static void _getAccountDataFromCache(BuildContext context, String accountType) {
    if(accountType == AccountTypeEnum.lawyers.name) {
      LawyerProvider lawyerProvider = Provider.of<LawyerProvider>(context, listen: false);
      LawyerModel lawyerModel = LawyerModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT)));
      lawyerProvider.setLawyer(lawyerModel);
    }
    else if(accountType == AccountTypeEnum.publicRelations.name) {
      PublicRelationProvider publicRelationProvider = Provider.of<PublicRelationProvider>(context, listen: false);
      PublicRelationModel publicRelationModel = PublicRelationModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT)));
      publicRelationProvider.setPublicRelation(publicRelationModel);
    }
    else if(accountType == AccountTypeEnum.legalAccountants.name) {
      LegalAccountantProvider legalAccountantProvider = Provider.of<LegalAccountantProvider>(context, listen: false);
      LegalAccountantModel legalAccountantModel = LegalAccountantModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT)));
      legalAccountantProvider.setLegalAccountant(legalAccountantModel);
    }
  }

  Future<void> getData({required BuildContext context, bool isSwipeRefresh = false}) async {
    String accountType = CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT_TYPE);
    _getAccountDataFromCache(context, accountType);
    if(!isSwipeRefresh) _startLoading();
    await Future.wait([
      if(accountType == AccountTypeEnum.lawyers.name) _getLawyer(context),
      if(accountType == AccountTypeEnum.publicRelations.name) _getPublicRelation(context),
      if(accountType == AccountTypeEnum.legalAccountants.name) _getLegalAccountant(context),
      _getEmploymentApplicationsForTarget(context),
      _getJobsForTarget(context),
      _getBookingAppointmentsForTarget(context),
      _getRequestThePhoneNumberForTarget(context),
      if(accountType == AccountTypeEnum.lawyers.name) _getLawyerReviewsForOne(context),
      if(accountType == AccountTypeEnum.publicRelations.name) _getPublicRelationsReviewsForOne(context),
      if(accountType == AccountTypeEnum.legalAccountants.name) _getLegalAccountantReviewsForOne(context),
      if(accountType == AccountTypeEnum.lawyers.name) _getAllInstantConsultationsForLawyer(context),
    ]).then((value) async {
      if(!isSwipeRefresh) {
        Future.delayed(const Duration(seconds: ConstantsManager.splashScreenDuration)).then((value) {
          setIsGetDataDone(true);
          _cancelLoading();
          if(_isGetDataDone && !_isErrorOccurred) {
            Navigator.pushNamedAndRemoveUntil(context, Routes.mainRoute, (route) => false);
          }
        });
      }
    });
  }

  Future<void> _getLawyer(BuildContext context) async {
    LawyerProvider lawyerProvider = Provider.of<LawyerProvider>(context, listen: false);
    LawyerModel lawyerModel = LawyerModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT)));

    GetLawyerParameters parameters = GetLawyerParameters(
      lawyerId: lawyerModel.lawyerId,
    );
    Either<Failure, LawyerModel> response = await lawyerProvider.getLawyerImpl(parameters);
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (lawyer) async {
      CacheHelper.setData(key: PREFERENCES_KEY_ACCOUNT, value: json.encode(LawyerModel.toMap(lawyer)));
      lawyerProvider.setLawyer(lawyer);
    });
  }

  Future<void> _getPublicRelation(BuildContext context) async {
    PublicRelationProvider publicRelationProvider = Provider.of<PublicRelationProvider>(context, listen: false);
    PublicRelationModel publicRelationModel = PublicRelationModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT)));

    GetPublicRelationParameters parameters = GetPublicRelationParameters(
      publicRelationId: publicRelationModel.publicRelationId,
    );
    Either<Failure, PublicRelationModel> response = await publicRelationProvider.getPublicRelationImpl(parameters);
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (publicRelation) async {
      CacheHelper.setData(key: PREFERENCES_KEY_ACCOUNT, value: json.encode(PublicRelationModel.toMap(publicRelation)));
      publicRelationProvider.setPublicRelation(publicRelation);
    });
  }

  Future<void> _getLegalAccountant(BuildContext context) async {
    LegalAccountantProvider legalAccountantProvider = Provider.of<LegalAccountantProvider>(context, listen: false);
    LegalAccountantModel legalAccountantModel = LegalAccountantModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT)));

    GetLegalAccountantParameters parameters = GetLegalAccountantParameters(
      legalAccountantId: legalAccountantModel.legalAccountantId,
    );
    Either<Failure, LegalAccountantModel> response = await legalAccountantProvider.getLegalAccountantImpl(parameters);
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (legalAccountant) async {
      CacheHelper.setData(key: PREFERENCES_KEY_ACCOUNT, value: json.encode(LegalAccountantModel.toMap(legalAccountant)));
      legalAccountantProvider.setLegalAccountant(legalAccountant);
    });
  }

  Future<void> _getEmploymentApplicationsForTarget(BuildContext context) async {
    String accountType = CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT_TYPE);
    EmploymentApplicationsProvider employmentApplicationsProvider = Provider.of<EmploymentApplicationsProvider>(context, listen: false);
    late GetEmploymentApplicationsForTargetParameters parameters;

    if(accountType == AccountTypeEnum.lawyers.name) {
      LawyerModel lawyerModel = LawyerModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT)));
      parameters = GetEmploymentApplicationsForTargetParameters(
        targetId: lawyerModel.lawyerId,
        targetName: lawyerModel.mainCategory,
      );
    }
    else if(accountType == AccountTypeEnum.publicRelations.name) {
      PublicRelationModel publicRelationModel = PublicRelationModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT)));
      parameters = GetEmploymentApplicationsForTargetParameters(
        targetId: publicRelationModel.publicRelationId,
        targetName: publicRelationModel.mainCategory,
      );
    }
    else if(accountType == AccountTypeEnum.legalAccountants.name) {
      LegalAccountantModel legalAccountantModel = LegalAccountantModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT)));
      parameters = GetEmploymentApplicationsForTargetParameters(
        targetId: legalAccountantModel.legalAccountantId,
        targetName: legalAccountantModel.mainCategory,
      );
    }

    Either<Failure, List<EmploymentApplicationModel>> response = await employmentApplicationsProvider.getEmploymentApplicationsForTargetImpl(parameters);
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (employmentApplications) async {
      employmentApplicationsProvider.setEmploymentApplications(employmentApplications);
    });
  }

  Future<void> _getJobsForTarget(BuildContext context) async {
    String accountType = CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT_TYPE);
    JobsProvider jobsProvider = Provider.of<JobsProvider>(context, listen: false);
    late GetJobsForTargetParameters parameters;

    if(accountType == AccountTypeEnum.lawyers.name) {
      LawyerModel lawyerModel = LawyerModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT)));
      parameters = GetJobsForTargetParameters(
        targetId: lawyerModel.lawyerId,
        targetName: lawyerModel.mainCategory,
      );
    }
    else if(accountType == AccountTypeEnum.publicRelations.name) {
      PublicRelationModel publicRelationModel = PublicRelationModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT)));
      parameters = GetJobsForTargetParameters(
        targetId: publicRelationModel.publicRelationId,
        targetName: publicRelationModel.mainCategory,
      );
    }
    else if(accountType == AccountTypeEnum.legalAccountants.name) {
      LegalAccountantModel legalAccountantModel = LegalAccountantModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT)));
      parameters = GetJobsForTargetParameters(
        targetId: legalAccountantModel.legalAccountantId,
        targetName: legalAccountantModel.mainCategory,
      );
    }

    Either<Failure, List<JobModel>> response = await jobsProvider.getJobsForTargetImpl(parameters);
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (jobs) async {
      jobsProvider.setJobs(jobs);
    });
  }

  Future<void> _getLawyerReviewsForOne(BuildContext context) async {
    LawyerReviewsProvider lawyerReviewsProvider = Provider.of<LawyerReviewsProvider>(context, listen: false);
    LawyerModel lawyerModel = LawyerModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT)));

    GetLawyerReviewsForOneParameters parameters = GetLawyerReviewsForOneParameters(
      lawyerId: lawyerModel.lawyerId,
    );
    Either<Failure, List<LawyerReviewModel>> response = await lawyerReviewsProvider.getLawyerReviewsForOneImpl(parameters);
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (lawyersReviews) async {
      lawyerReviewsProvider.setLawyersReviews(lawyersReviews);
    });
  }

  Future<void> _getPublicRelationsReviewsForOne(BuildContext context) async {
    PublicRelationReviewsProvider publicRelationReviewsProvider = Provider.of<PublicRelationReviewsProvider>(context, listen: false);
    PublicRelationModel publicRelationModel = PublicRelationModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT)));

    GetPublicRelationsReviewsForOneParameters parameters = GetPublicRelationsReviewsForOneParameters(
      publicRelationId: publicRelationModel.publicRelationId,
    );
    Either<Failure, List<PublicRelationReviewModel>> response = await publicRelationReviewsProvider.getPublicRelationsReviewsForOneImpl(parameters);
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (publicRelationsReviews) async {
      publicRelationReviewsProvider.setPublicRelationsReviews(publicRelationsReviews);
    });
  }

  Future<void> _getLegalAccountantReviewsForOne(BuildContext context) async {
    LegalAccountantReviewsProvider legalAccountantReviewsProvider = Provider.of<LegalAccountantReviewsProvider>(context, listen: false);
    LegalAccountantModel legalAccountantModel = LegalAccountantModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT)));

    GetLegalAccountantReviewsForOneParameters parameters = GetLegalAccountantReviewsForOneParameters(
      legalAccountantId: legalAccountantModel.legalAccountantId,
    );
    Either<Failure, List<LegalAccountantReviewModel>> response = await legalAccountantReviewsProvider.getLegalAccountantReviewsForOneImpl(parameters);
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (legalAccountantsReviews) async {
      legalAccountantReviewsProvider.setLegalAccountantsReviews(legalAccountantsReviews);
    });
  }

  Future<void> _getAllInstantConsultationsForLawyer(BuildContext context) async {
    InstantConsultationsProvider instantConsultationsProvider = Provider.of<InstantConsultationsProvider>(context, listen: false);

    LawyerModel lawyerModel = LawyerModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT)));
    GetAllInstantConsultationsForLawyerParameters parameters = GetAllInstantConsultationsForLawyerParameters(
      lawyerId: lawyerModel.lawyerId,
    );
    Either<Failure, List<TransactionModel>> response = await instantConsultationsProvider.getAllInstantConsultationsForLawyerImpl(parameters);
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (instantConsultations) async {
      instantConsultationsProvider.setInstantConsultations(instantConsultations);
    });
  }

  Future<void> _getBookingAppointmentsForTarget(BuildContext context) async {
    String accountType = CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT_TYPE);
    BookingAppointmentsProvider bookingAppointmentsProvider = Provider.of<BookingAppointmentsProvider>(context, listen: false);
    late GetBookingAppointmentsForTargetParameters parameters;

    if(accountType == AccountTypeEnum.lawyers.name) {
      LawyerModel lawyerModel = LawyerModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT)));
      parameters = GetBookingAppointmentsForTargetParameters(
        targetId: lawyerModel.lawyerId,
        transactionType: TransactionType.appointmentBookingWithLawyer.name,
      );
    }
    else if(accountType == AccountTypeEnum.publicRelations.name) {
      PublicRelationModel publicRelationModel = PublicRelationModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT)));
      parameters = GetBookingAppointmentsForTargetParameters(
        targetId: publicRelationModel.publicRelationId,
        transactionType: TransactionType.appointmentBookingWithPublicRelation.name,
      );
    }
    else if(accountType == AccountTypeEnum.legalAccountants.name) {
      LegalAccountantModel legalAccountantModel = LegalAccountantModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT)));
      parameters = GetBookingAppointmentsForTargetParameters(
        targetId: legalAccountantModel.legalAccountantId,
        transactionType: TransactionType.appointmentBookingWithLegalAccountant.name,
      );
    }

    Either<Failure, List<TransactionModel>> response = await bookingAppointmentsProvider.getBookingAppointmentsForTargetImpl(parameters);
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (bookingAppointments) async {
      bookingAppointmentsProvider.setBookingAppointments(bookingAppointments);
    });
  }

  Future<void> _getRequestThePhoneNumberForTarget(BuildContext context) async {
    String accountType = CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT_TYPE);
    RequestThePhoneNumberProvider requestThePhoneNumberProvider = Provider.of<RequestThePhoneNumberProvider>(context, listen: false);
    late GetRequestThePhoneNumberForTargetParameters parameters;

    if(accountType == AccountTypeEnum.lawyers.name) {
      LawyerModel lawyerModel = LawyerModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT)));
      parameters = GetRequestThePhoneNumberForTargetParameters(
        targetId: lawyerModel.lawyerId,
        transactionType: TransactionType.showLawyerNumber.name,
      );
    }
    else if(accountType == AccountTypeEnum.publicRelations.name) {
      PublicRelationModel publicRelationModel = PublicRelationModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT)));
      parameters = GetRequestThePhoneNumberForTargetParameters(
        targetId: publicRelationModel.publicRelationId,
        transactionType: TransactionType.showPublicRelationNumber.name,
      );
    }
    else if(accountType == AccountTypeEnum.legalAccountants.name) {
      LegalAccountantModel legalAccountantModel = LegalAccountantModel.fromJson(json.decode(CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT)));
      parameters = GetRequestThePhoneNumberForTargetParameters(
        targetId: legalAccountantModel.legalAccountantId,
        transactionType: TransactionType.showLegalAccountantNumber.name,
      );
    }

    Either<Failure, List<TransactionModel>> response = await requestThePhoneNumberProvider.getRequestThePhoneNumberForTargetImpl(parameters);
    response.fold((failure) async {
      changeIsErrorOccurred(true);
      Dialogs.failureOccurred(context, failure);
    }, (requestThePhoneNumber) async {
      requestThePhoneNumberProvider.setRequestThePhoneNumber(requestThePhoneNumber);
    });
  }

  Future<void> onPressedTryAgain(BuildContext context) async {
    changeIsErrorOccurred(false);
    await getData(context: context);
  }
}
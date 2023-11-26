import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/exceptions.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/core/network/network_info.dart';
import 'package:fahem_business/data/data_source/remote/remote_data_source.dart';
import 'package:fahem_business/data/models/employment_applications/employment_application_model.dart';
import 'package:fahem_business/data/models/instant_consultations_comments/instant_consultation_comment_model.dart';
import 'package:fahem_business/data/models/legal_accountant/legal_account_model.dart';
import 'package:fahem_business/data/models/legal_accountants_reviews/legal_account_review_model.dart';
import 'package:fahem_business/data/models/transactions/transaction_model.dart';
import 'package:fahem_business/data/models/jobs/job_model.dart';
import 'package:fahem_business/data/models/lawyers/lawyer_model.dart';
import 'package:fahem_business/data/models/lawyers_reviews/lawyer_review_model.dart';
import 'package:fahem_business/data/models/lawyers_categories/lawyer_category_model.dart';
import 'package:fahem_business/data/models/public_relations/public_relation_model.dart';
import 'package:fahem_business/data/models/public_relations_reviews/public_relation_review_model.dart';
import 'package:fahem_business/data/models/public_relations_categories/public_relation_category_model.dart';
import 'package:fahem_business/data/models/version/version_model.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/booking_appointments/get_booking_appointments_for_target__usecase.dart';
import 'package:fahem_business/domain/usecases/employment_applications/get_employment_applications_for_target_usecase.dart';
import 'package:fahem_business/domain/usecases/instant_consultations/get_all_instant_consultations_for_lawyer_usecase.dart';
import 'package:fahem_business/domain/usecases/instant_consultations_comments/insert_instant_consultation_comment_usecase.dart';
import 'package:fahem_business/domain/usecases/jobs/delete_job_usecase.dart';
import 'package:fahem_business/domain/usecases/jobs/edit_job_usecase.dart';
import 'package:fahem_business/domain/usecases/jobs/get_jobs_for_target_usecase.dart';
import 'package:fahem_business/domain/usecases/jobs/insert_job_usecase.dart';
import 'package:fahem_business/domain/usecases/lawyer_identification_images/edit_lawyer_identification_images_usecase.dart';
import 'package:fahem_business/domain/usecases/lawyers/check_and_get_lawyer_usecase.dart';
import 'package:fahem_business/domain/usecases/lawyers/delete_lawyer_usecase.dart';
import 'package:fahem_business/domain/usecases/lawyers/edit_lawyer_booking_by_appointment_usecase.dart';
import 'package:fahem_business/domain/usecases/lawyers/edit_lawyer_usecase.dart';
import 'package:fahem_business/domain/usecases/lawyers/edit_subscription_of_fahem_services_usecase.dart';
import 'package:fahem_business/domain/usecases/lawyers/insert_lawyer_usecase.dart';
import 'package:fahem_business/domain/usecases/lawyers_reviews/get_lawyers_reviews_for_one_usecase.dart';
import 'package:fahem_business/domain/usecases/legal_accountant_identification_images/edit_legal_accountant_identification_images_usecase.dart';
import 'package:fahem_business/domain/usecases/legal_accountants/check_and_get_legal_accountant_usecase.dart';
import 'package:fahem_business/domain/usecases/legal_accountants/delete_legal_accountant_usecase.dart';
import 'package:fahem_business/domain/usecases/legal_accountants/edit_legal_accountant_booking_by_appointment_usecase.dart';
import 'package:fahem_business/domain/usecases/legal_accountants/edit_legal_accountant_usecase.dart';
import 'package:fahem_business/domain/usecases/legal_accountants/insert_legal_accountant_usecase.dart';
import 'package:fahem_business/domain/usecases/legal_accountants_reviews/get_legal_accountants_reviews_for_one_usecase.dart';
import 'package:fahem_business/domain/usecases/public_relation_identification_images/edit_public_relation_identification_images_usecase.dart';
import 'package:fahem_business/domain/usecases/public_relations/check_and_get_public_relation_usecase.dart';
import 'package:fahem_business/domain/usecases/public_relations/delete_public_relation_usecase.dart';
import 'package:fahem_business/domain/usecases/public_relations/edit_public_relation_booking_by_appointment_usecase.dart';
import 'package:fahem_business/domain/usecases/public_relations/edit_public_relation_usecase.dart';
import 'package:fahem_business/domain/usecases/public_relations/insert_public_relation_usecase.dart';
import 'package:fahem_business/domain/usecases/public_relations_reviews/get_public_relations_reviews_for_one_usecase.dart';
import 'package:fahem_business/domain/usecases/shared/upload_file_usecase.dart';
import 'package:fahem_business/domain/usecases/transaction_type_show_numbers/get_transaction_type_show_numbers_for_target_usecase.dart';
import 'package:flutter/material.dart';

class Repository extends BaseRepository {
  final BaseRemoteDataSource _baseRemoteDataSource;
  final BaseNetworkInfo _baseNetworkInfo;

  Repository(this._baseRemoteDataSource, this._baseNetworkInfo);

  @override
  Future<Either<Failure, VersionModel>> getVersion() async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getVersion();
        debugPrint('getVersion');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<EmploymentApplicationModel>>> getEmploymentApplicationsForTarget(GetEmploymentApplicationsForTargetParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getEmploymentApplicationsForTarget(parameters);
        debugPrint('getEmploymentApplicationsForTarget: ${result.length}');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<JobModel>>> getJobsForTarget(GetJobsForTargetParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getJobsForTarget(parameters);
        debugPrint('getJobsForTarget: ${result.length}');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, JobModel>> insertJob(InsertJobParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.insertJob(parameters);
        debugPrint('insertJob');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, JobModel>> editJob(EditJobParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.editJob(parameters);
        debugPrint('editJob');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteJob(DeleteJobParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.deleteJob(parameters);
        debugPrint('deleteJob');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, LawyerModel>> checkAndGetLawyer(CheckAndGetLawyerParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.checkAndGetLawyer(parameters);
        debugPrint('checkAndGetLawyer');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, LawyerModel>> getLawyer(parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getLawyer(parameters);
        debugPrint('getLawyer');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> isAllLawyerDataValid(parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.isAllLawyerDataValid(parameters);
        debugPrint('isAllLawyerDataValid');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, LawyerModel>> insertLawyer(InsertLawyerParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.insertLawyer(parameters);
        debugPrint('insertLawyer');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, LawyerModel>> editLawyer(EditLawyerParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.editLawyer(parameters);
        debugPrint('editLawyer');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, LawyerModel>> editSubscriptionOfFahemServices(EditSubscriptionOfFahemServicesParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.editSubscriptionOfFahemServices(parameters);
        debugPrint('editSubscriptionOfFahemServices');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteLawyer(DeleteLawyerParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.deleteLawyer(parameters);
        debugPrint('deleteLawyer');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<LawyerCategoryModel>>> getAllLawyersCategories() async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getAllLawyersCategories();
        debugPrint('getAllLawyersCategories: ${result.length}');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<LawyerReviewModel>>> getLawyerReviewsForOne(GetLawyerReviewsForOneParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getLawyerReviewsForOne(parameters);
        debugPrint('getLawyerReviewsForOne: ${result.length}');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, PublicRelationModel>> checkAndGetPublicRelation(CheckAndGetPublicRelationParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.checkAndGetPublicRelation(parameters);
        debugPrint('checkAndGetPublicRelation');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, PublicRelationModel>> getPublicRelation(parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getPublicRelation(parameters);
        debugPrint('getPublicRelation');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> isAllPublicRelationDataValid(parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.isAllPublicRelationDataValid(parameters);
        debugPrint('isAllPublicRelationDataValid');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, PublicRelationModel>> insertPublicRelation(InsertPublicRelationParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.insertPublicRelation(parameters);
        debugPrint('insertPublicRelation');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, PublicRelationModel>> editPublicRelation(EditPublicRelationParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.editPublicRelation(parameters);
        debugPrint('editPublicRelation');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deletePublicRelation(DeletePublicRelationParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.deletePublicRelation(parameters);
        debugPrint('deletePublicRelation');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<PublicRelationCategoryModel>>> getAllPublicRelationsCategories() async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getAllPublicRelationsCategories();
        debugPrint('getAllPublicRelationsCategories: ${result.length}');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<PublicRelationReviewModel>>> getPublicRelationsReviewsForOne(GetPublicRelationsReviewsForOneParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getPublicRelationsReviewsForOne(parameters);
        debugPrint('getPublicRelationsReviewsForOne: ${result.length}');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, LegalAccountantModel>> checkAndGetLegalAccountant(CheckAndGetLegalAccountantParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.checkAndGetLegalAccountant(parameters);
        debugPrint('checkAndGetLegalAccountant');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, LegalAccountantModel>> getLegalAccountant(parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getLegalAccountant(parameters);
        debugPrint('getLegalAccountant');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> isAllLegalAccountantDataValid(parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.isAllLegalAccountantDataValid(parameters);
        debugPrint('isAllLegalAccountantDataValid');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, LegalAccountantModel>> insertLegalAccountant(InsertLegalAccountantParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.insertLegalAccountant(parameters);
        debugPrint('insertLegalAccountant');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, LegalAccountantModel>> editLegalAccountant(EditLegalAccountantParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.editLegalAccountant(parameters);
        debugPrint('editLegalAccountant');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteLegalAccountant(DeleteLegalAccountantParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.deleteLegalAccountant(parameters);
        debugPrint('deleteLegalAccountant');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<LegalAccountantReviewModel>>> getLegalAccountantReviewsForOne(GetLegalAccountantReviewsForOneParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getLegalAccountantReviewsForOne(parameters);
        debugPrint('getLegalAccountantReviewsForOne: ${result.length}');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<TransactionModel>>> getAllInstantConsultationsForLawyer(GetAllInstantConsultationsForLawyerParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getAllInstantConsultationsForLawyer(parameters);
        debugPrint('getAllInstantConsultationsForLawyer: ${result.length}');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<TransactionModel>>> getBookingAppointmentsForTarget(GetBookingAppointmentsForTargetParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getBookingAppointmentsForTarget(parameters);
        debugPrint('getBookingAppointmentsForTarget: ${result.length}');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<TransactionModel>>> getRequestThePhoneNumberForTarget(GetRequestThePhoneNumberForTargetParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.getRequestThePhoneNumberForTarget(parameters);
        debugPrint('getRequestThePhoneNumberForTarget: ${result.length}');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, InstantConsultationCommentModel>> insertInstantConsultationComment(InsertInstantConsultationCommentParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.insertInstantConsultationComment(parameters);
        debugPrint('insertInstantConsultationComment');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, LawyerModel>> editLawyerIdentificationImages(EditLawyerIdentificationImagesParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.editLawyerIdentificationImages(parameters);
        debugPrint('editLawyerIdentificationImages');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, PublicRelationModel>> editPublicRelationIdentificationImages(EditPublicRelationIdentificationImagesParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.editPublicRelationIdentificationImages(parameters);
        debugPrint('editPublicRelationIdentificationImages');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, LegalAccountantModel>> editLegalAccountantIdentificationImages(EditLegalAccountantIdentificationImagesParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.editLegalAccountantIdentificationImages(parameters);
        debugPrint('editLegalAccountantIdentificationImages');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, LawyerModel>> editLawyerBookingByAppointment(EditLawyerBookingByAppointmentParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.editLawyerBookingByAppointment(parameters);
        debugPrint('editLawyerBookingByAppointment');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, PublicRelationModel>> editPublicRelationBookingByAppointment(EditPublicRelationBookingByAppointmentParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.editPublicRelationBookingByAppointment(parameters);
        debugPrint('editPublicRelationBookingByAppointment');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, LegalAccountantModel>> editLegalAccountantBookingByAppointment(EditLegalAccountantBookingByAppointmentParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.editLegalAccountantBookingByAppointment(parameters);
        debugPrint('editLegalAccountantBookingByAppointment');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadFile(UploadFileParameters parameters) async {
    if(await _baseNetworkInfo.isConnected) {
      try {
        var result = await _baseRemoteDataSource.uploadFile(parameters);
        debugPrint('uploadFile');
        return Right(result);
      }
      on ServerException catch(error) {
        return Left(ServerFailure(messageAr: error.messageAr, messageEn: error.messageEn));
      }
    }
    else {
      return Left(LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
    }
  }
}
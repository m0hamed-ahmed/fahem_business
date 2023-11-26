import 'dart:convert';
import 'package:fahem_business/core/error/exceptions.dart';
import 'package:fahem_business/core/network/api_constants.dart';
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
import 'package:fahem_business/domain/usecases/lawyers/get_lawyer_usecase.dart';
import 'package:fahem_business/domain/usecases/lawyers/insert_lawyer_usecase.dart';
import 'package:fahem_business/domain/usecases/lawyers/is_all_lawyer_data_valid_usecase.dart';
import 'package:fahem_business/domain/usecases/lawyers_reviews/get_lawyers_reviews_for_one_usecase.dart';
import 'package:fahem_business/domain/usecases/legal_accountant_identification_images/edit_legal_accountant_identification_images_usecase.dart';
import 'package:fahem_business/domain/usecases/legal_accountants/check_and_get_legal_accountant_usecase.dart';
import 'package:fahem_business/domain/usecases/legal_accountants/delete_legal_accountant_usecase.dart';
import 'package:fahem_business/domain/usecases/legal_accountants/edit_legal_accountant_booking_by_appointment_usecase.dart';
import 'package:fahem_business/domain/usecases/legal_accountants/edit_legal_accountant_usecase.dart';
import 'package:fahem_business/domain/usecases/legal_accountants/get_legal_accountant_usecase.dart';
import 'package:fahem_business/domain/usecases/legal_accountants/insert_legal_accountant_usecase.dart';
import 'package:fahem_business/domain/usecases/legal_accountants/is_all_legal_accountant_data_valid_usecase.dart';
import 'package:fahem_business/domain/usecases/legal_accountants_reviews/get_legal_accountants_reviews_for_one_usecase.dart';
import 'package:fahem_business/domain/usecases/public_relation_identification_images/edit_public_relation_identification_images_usecase.dart';
import 'package:fahem_business/domain/usecases/public_relations/check_and_get_public_relation_usecase.dart';
import 'package:fahem_business/domain/usecases/public_relations/delete_public_relation_usecase.dart';
import 'package:fahem_business/domain/usecases/public_relations/edit_public_relation_booking_by_appointment_usecase.dart';
import 'package:fahem_business/domain/usecases/public_relations/edit_public_relation_usecase.dart';
import 'package:fahem_business/domain/usecases/public_relations/get_public_relation_usecase.dart';
import 'package:fahem_business/domain/usecases/public_relations/insert_public_relation_usecase.dart';
import 'package:fahem_business/domain/usecases/public_relations/is_all_public_relation_data_valid_usecase.dart';
import 'package:fahem_business/domain/usecases/public_relations_reviews/get_public_relations_reviews_for_one_usecase.dart';
import 'package:fahem_business/domain/usecases/shared/upload_file_usecase.dart';
import 'package:fahem_business/domain/usecases/transaction_type_show_numbers/get_transaction_type_show_numbers_for_target_usecase.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

abstract class BaseRemoteDataSource {
  Future<VersionModel> getVersion();
  Future<List<TransactionModel>> getBookingAppointmentsForTarget(GetBookingAppointmentsForTargetParameters parameters);
  Future<List<EmploymentApplicationModel>> getEmploymentApplicationsForTarget(GetEmploymentApplicationsForTargetParameters parameters);
  Future<List<TransactionModel>> getAllInstantConsultationsForLawyer(GetAllInstantConsultationsForLawyerParameters parameters);
  Future<InstantConsultationCommentModel> insertInstantConsultationComment(InsertInstantConsultationCommentParameters parameters);
  Future<List<JobModel>> getJobsForTarget(GetJobsForTargetParameters parameters);
  Future<JobModel> insertJob(InsertJobParameters parameters);
  Future<JobModel> editJob(EditJobParameters parameters);
  Future<void> deleteJob(DeleteJobParameters parameters);
  Future<LawyerModel> checkAndGetLawyer(CheckAndGetLawyerParameters parameters);
  Future<LawyerModel> getLawyer(GetLawyerParameters parameters);
  Future<bool> isAllLawyerDataValid(IsAllLawyerDataValidParameters parameters);
  Future<LawyerModel> insertLawyer(InsertLawyerParameters parameters);
  Future<LawyerModel> editLawyer(EditLawyerParameters parameters);
  Future<LawyerModel> editSubscriptionOfFahemServices(EditSubscriptionOfFahemServicesParameters parameters);
  Future<void> deleteLawyer(DeleteLawyerParameters parameters);
  Future<List<LawyerCategoryModel>> getAllLawyersCategories();
  Future<List<LawyerReviewModel>> getLawyerReviewsForOne(GetLawyerReviewsForOneParameters parameters);
  Future<LegalAccountantModel> checkAndGetLegalAccountant(CheckAndGetLegalAccountantParameters parameters);
  Future<LegalAccountantModel> getLegalAccountant(GetLegalAccountantParameters parameters);
  Future<bool> isAllLegalAccountantDataValid(IsAllLegalAccountantDataValidParameters parameters);
  Future<LegalAccountantModel> insertLegalAccountant(InsertLegalAccountantParameters parameters);
  Future<LegalAccountantModel> editLegalAccountant(EditLegalAccountantParameters parameters);
  Future<void> deleteLegalAccountant(DeleteLegalAccountantParameters parameters);
  Future<List<LegalAccountantReviewModel>> getLegalAccountantReviewsForOne(GetLegalAccountantReviewsForOneParameters parameters);
  Future<PublicRelationModel> checkAndGetPublicRelation(CheckAndGetPublicRelationParameters parameters);
  Future<PublicRelationModel> getPublicRelation(GetPublicRelationParameters parameters);
  Future<bool> isAllPublicRelationDataValid(IsAllPublicRelationDataValidParameters parameters);
  Future<PublicRelationModel> insertPublicRelation(InsertPublicRelationParameters parameters);
  Future<PublicRelationModel> editPublicRelation(EditPublicRelationParameters parameters);
  Future<void> deletePublicRelation(DeletePublicRelationParameters parameters);
  Future<List<PublicRelationCategoryModel>> getAllPublicRelationsCategories();
  Future<List<PublicRelationReviewModel>> getPublicRelationsReviewsForOne(GetPublicRelationsReviewsForOneParameters parameters);
  Future<List<TransactionModel>> getRequestThePhoneNumberForTarget(GetRequestThePhoneNumberForTargetParameters parameters);
  Future<LawyerModel> editLawyerIdentificationImages(EditLawyerIdentificationImagesParameters parameters);
  Future<PublicRelationModel> editPublicRelationIdentificationImages(EditPublicRelationIdentificationImagesParameters parameters);
  Future<LegalAccountantModel> editLegalAccountantIdentificationImages(EditLegalAccountantIdentificationImagesParameters parameters);
  Future<LawyerModel> editLawyerBookingByAppointment(EditLawyerBookingByAppointmentParameters parameters);
  Future<PublicRelationModel> editPublicRelationBookingByAppointment(EditPublicRelationBookingByAppointmentParameters parameters);
  Future<LegalAccountantModel> editLegalAccountantBookingByAppointment(EditLegalAccountantBookingByAppointmentParameters parameters);
  Future<String> uploadFile(UploadFileParameters parameters);
}

class RemoteDataSource extends BaseRemoteDataSource {

  @override
  Future<VersionModel> getVersion() async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.appField: 'fahemBusiness',
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.getVersionEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return VersionModel.fromJson(jsonData['version']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getVersion: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getVersion: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<List<TransactionModel>> getBookingAppointmentsForTarget(GetBookingAppointmentsForTargetParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.targetIdField: parameters.targetId.toString(),
        ApiConstants.transactionTypeField: parameters.transactionType.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.getBookingAppointmentsForTargetEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return TransactionModel.fromJsonList(jsonData['bookingAppointments']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getBookingAppointmentsForTarget: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getBookingAppointmentsForTarget: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<List<EmploymentApplicationModel>> getEmploymentApplicationsForTarget(GetEmploymentApplicationsForTargetParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.targetIdField: parameters.targetId.toString(),
        ApiConstants.targetNameField: parameters.targetName.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.getEmploymentApplicationsForTargetEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return EmploymentApplicationModel.fromJsonList(jsonData['employmentApplications']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getEmploymentApplicationsForTarget: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getEmploymentApplicationsForTarget: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<List<TransactionModel>> getAllInstantConsultationsForLawyer(GetAllInstantConsultationsForLawyerParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.lawyerIdField: parameters.lawyerId.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.getAllInstantConsultationsForLawyerEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return TransactionModel.fromJsonList(jsonData['instantConsultations']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getAllInstantConsultationsForLawyer: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getAllInstantConsultationsForLawyer: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<InstantConsultationCommentModel> insertInstantConsultationComment(InsertInstantConsultationCommentParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.transactionIdField: parameters.instantConsultationCommentModel.transactionId.toString(),
        ApiConstants.lawyerIdField: parameters.instantConsultationCommentModel.lawyerId.toString(),
        ApiConstants.commentField: parameters.instantConsultationCommentModel.comment.toString(),
        ApiConstants.commentStatusField: parameters.instantConsultationCommentModel.commentStatus.name.toString(),
        ApiConstants.createdAtField: parameters.instantConsultationCommentModel.createdAt.millisecondsSinceEpoch.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.insertInstantConsultationCommentEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return InstantConsultationCommentModel.fromJson(jsonData['instantConsultationComment']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('insertInstantConsultationComment: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('insertInstantConsultationComment: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<List<JobModel>> getJobsForTarget(GetJobsForTargetParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.targetIdField: parameters.targetId.toString(),
        ApiConstants.targetNameField: parameters.targetName.toString(),
      };

      http.Response response = await http.post(
          Uri.parse(ApiConstants.getJobsForTargetEndPoint),
          body: body
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return JobModel.fromJsonList(jsonData['jobs']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getJobsForTarget: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getJobsForTarget: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<JobModel> insertJob(InsertJobParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.targetIdField: parameters.jobModel.targetId.toString(),
        ApiConstants.targetNameField: parameters.jobModel.targetName.toString(),
        ApiConstants.imageField: parameters.jobModel.image.toString(),
        ApiConstants.jobTitleField: parameters.jobModel.jobTitle.toString(),
        ApiConstants.companyNameField: parameters.jobModel.companyName.toString(),
        ApiConstants.aboutCompanyField: parameters.jobModel.aboutCompany.toString(),
        ApiConstants.minSalaryField: parameters.jobModel.minSalary.toString(),
        ApiConstants.maxSalaryField: parameters.jobModel.maxSalary.toString(),
        ApiConstants.jobLocationField: parameters.jobModel.jobLocation.toString(),
        ApiConstants.featuresField: parameters.jobModel.features.join('--'),
        ApiConstants.detailsField: parameters.jobModel.details.toString(),
        ApiConstants.isAvailableField: parameters.jobModel.isAvailable.toString(),
        ApiConstants.createdAtField: parameters.jobModel.createdAt.millisecondsSinceEpoch.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.insertJobEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return JobModel.fromJson(jsonData['job']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('insertJob: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('insertJob: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<JobModel> editJob(EditJobParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.jobIdField: parameters.jobModel.jobId.toString(),
        ApiConstants.targetIdField: parameters.jobModel.targetId.toString(),
        ApiConstants.targetNameField: parameters.jobModel.targetName.toString(),
        ApiConstants.imageField: parameters.jobModel.image.toString(),
        ApiConstants.jobTitleField: parameters.jobModel.jobTitle.toString(),
        ApiConstants.companyNameField: parameters.jobModel.companyName.toString(),
        ApiConstants.aboutCompanyField: parameters.jobModel.aboutCompany.toString(),
        ApiConstants.minSalaryField: parameters.jobModel.minSalary.toString(),
        ApiConstants.maxSalaryField: parameters.jobModel.maxSalary.toString(),
        ApiConstants.jobLocationField: parameters.jobModel.jobLocation.toString(),
        ApiConstants.featuresField: parameters.jobModel.features.join('--'),
        ApiConstants.detailsField: parameters.jobModel.details.toString(),
        ApiConstants.isAvailableField: parameters.jobModel.isAvailable.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.editJobEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return JobModel.fromJson(jsonData['job']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('editJob: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('editJob: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<void> deleteJob(DeleteJobParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.jobIdField: parameters.jobId.toString(),
        ApiConstants.targetIdField: parameters.targetId.toString(),
        ApiConstants.targetNameField: parameters.targetName.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.deleteJobEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {}
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('deleteJob: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('deleteJob: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<LawyerModel> checkAndGetLawyer(CheckAndGetLawyerParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.emailAddressField: parameters.emailAddress.toString(),
        ApiConstants.passwordField: parameters.password.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.checkAndGetLawyerEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return LawyerModel.fromJson(jsonData['lawyer']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('checkAndGetLawyer: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('checkAndGetLawyer: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<LawyerModel> getLawyer(GetLawyerParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.lawyerIdField: parameters.lawyerId.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.getLawyerEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return LawyerModel.fromJson(jsonData['lawyer']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getLawyer: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getLawyer: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<bool> isAllLawyerDataValid(IsAllLawyerDataValidParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.emailAddressField: parameters.emailAddress.toString(),
        ApiConstants.passwordField: parameters.password.toString(),
        ApiConstants.phoneNumberField: parameters.phoneNumber.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.isAllLawyerDataValidEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return jsonData['isAllDataValid'];
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('isAllLawyerDataValid: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('isAllLawyerDataValid: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<LawyerModel> insertLawyer(InsertLawyerParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.nameField: parameters.lawyerModel.name.toString(),
        ApiConstants.emailAddressField: parameters.lawyerModel.emailAddress.toString(),
        ApiConstants.passwordField: parameters.lawyerModel.password.toString(),
        ApiConstants.categoriesIdsField: parameters.lawyerModel.categoriesIds.join('--'),
        ApiConstants.personalImageField: parameters.lawyerModel.personalImage.toString(),
        ApiConstants.jobTitleField: parameters.lawyerModel.jobTitle.toString(),
        ApiConstants.addressField: parameters.lawyerModel.address.toString(),
        ApiConstants.informationField: parameters.lawyerModel.information.toString(),
        ApiConstants.phoneNumberField: parameters.lawyerModel.phoneNumber.toString(),
        ApiConstants.consultationPriceField: parameters.lawyerModel.consultationPrice.toString(),
        ApiConstants.tasksField: parameters.lawyerModel.tasks.join('--'),
        ApiConstants.imagesField: parameters.lawyerModel.images.join('--'),
        ApiConstants.latitudeField: parameters.lawyerModel.latitude.toString(),
        ApiConstants.longitudeField: parameters.lawyerModel.longitude.toString(),
        ApiConstants.governorateField: parameters.lawyerModel.governorate.toString(),
        ApiConstants.accountStatusField: parameters.lawyerModel.accountStatus.name.toString(),
        ApiConstants.isBookingByAppointmentField: parameters.lawyerModel.isBookingByAppointment.toString(),
        ApiConstants.availablePeriodsField: parameters.lawyerModel.availablePeriods.join('--'),
        ApiConstants.identificationImagesField: parameters.lawyerModel.identificationImages.join('--'),
        ApiConstants.isSubscriberToInstantLawyerServiceField: parameters.lawyerModel.isSubscriberToInstantLawyerService.toString(),
        ApiConstants.isSubscriberToInstantConsultationServiceField: parameters.lawyerModel.isSubscriberToInstantConsultationService.toString(),
        ApiConstants.isSubscriberToSecretConsultationServiceField: parameters.lawyerModel.isSubscriberToSecretConsultationService.toString(),
        ApiConstants.isSubscriberToEstablishingCompaniesServiceField: parameters.lawyerModel.isSubscriberToEstablishingCompaniesService.toString(),
        ApiConstants.isSubscriberToRealEstateLegalAdviceServiceField: parameters.lawyerModel.isSubscriberToRealEstateLegalAdviceService.toString(),
        ApiConstants.isSubscriberToInvestmentLegalAdviceServiceField: parameters.lawyerModel.isSubscriberToInvestmentLegalAdviceService.toString(),
        ApiConstants.isSubscriberToTrademarkRegistrationAndIntellectualProtectionServField: parameters.lawyerModel.isSubscriberToTrademarkRegistrationAndIntellectualProtectionServ.toString(),
        ApiConstants.isSubscriberToDebtCollectionServiceField: parameters.lawyerModel.isSubscriberToDebtCollectionService.toString(),
        ApiConstants.createdAtField: parameters.lawyerModel.createdAt.millisecondsSinceEpoch.toString(),
      };
      http.Response response = await http.post(
        Uri.parse(ApiConstants.insertLawyerEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return LawyerModel.fromJson(jsonData['lawyer']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('insertLawyer: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('insertLawyer: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<LawyerModel> editLawyer(EditLawyerParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.lawyerIdField: parameters.lawyerModel.lawyerId.toString(),
        ApiConstants.nameField: parameters.lawyerModel.name.toString(),
        ApiConstants.emailAddressField: parameters.lawyerModel.emailAddress.toString(),
        ApiConstants.passwordField: parameters.lawyerModel.password.toString(),
        ApiConstants.categoriesIdsField: parameters.lawyerModel.categoriesIds.join('--'),
        ApiConstants.personalImageField: parameters.lawyerModel.personalImage.toString(),
        ApiConstants.jobTitleField: parameters.lawyerModel.jobTitle.toString(),
        ApiConstants.addressField: parameters.lawyerModel.address.toString(),
        ApiConstants.informationField: parameters.lawyerModel.information.toString(),
        ApiConstants.phoneNumberField: parameters.lawyerModel.phoneNumber.toString(),
        ApiConstants.consultationPriceField: parameters.lawyerModel.consultationPrice.toString(),
        ApiConstants.tasksField: parameters.lawyerModel.tasks.join('--'),
        ApiConstants.imagesField: parameters.lawyerModel.images.join('--'),
        ApiConstants.latitudeField: parameters.lawyerModel.latitude.toString(),
        ApiConstants.longitudeField: parameters.lawyerModel.longitude.toString(),
        ApiConstants.governorateField: parameters.lawyerModel.governorate.toString(),
        ApiConstants.accountStatusField: parameters.lawyerModel.accountStatus.name.toString(),
        ApiConstants.isBookingByAppointmentField: parameters.lawyerModel.isBookingByAppointment.toString(),
        ApiConstants.availablePeriodsField: parameters.lawyerModel.availablePeriods.join('--'),
        ApiConstants.identificationImagesField: parameters.lawyerModel.identificationImages.join('--'),
        ApiConstants.isSubscriberToInstantLawyerServiceField: parameters.lawyerModel.isSubscriberToInstantLawyerService.toString(),
        ApiConstants.isSubscriberToInstantConsultationServiceField: parameters.lawyerModel.isSubscriberToInstantConsultationService.toString(),
        ApiConstants.isSubscriberToSecretConsultationServiceField: parameters.lawyerModel.isSubscriberToSecretConsultationService.toString(),
        ApiConstants.isSubscriberToEstablishingCompaniesServiceField: parameters.lawyerModel.isSubscriberToEstablishingCompaniesService.toString(),
        ApiConstants.isSubscriberToRealEstateLegalAdviceServiceField: parameters.lawyerModel.isSubscriberToRealEstateLegalAdviceService.toString(),
        ApiConstants.isSubscriberToInvestmentLegalAdviceServiceField: parameters.lawyerModel.isSubscriberToInvestmentLegalAdviceService.toString(),
        ApiConstants.isSubscriberToTrademarkRegistrationAndIntellectualProtectionServField: parameters.lawyerModel.isSubscriberToTrademarkRegistrationAndIntellectualProtectionServ.toString(),
        ApiConstants.isSubscriberToDebtCollectionServiceField: parameters.lawyerModel.isSubscriberToDebtCollectionService.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.editLawyerEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return LawyerModel.fromJson(jsonData['lawyer']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('editLawyer: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('editLawyer: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<LawyerModel> editSubscriptionOfFahemServices(EditSubscriptionOfFahemServicesParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.lawyerIdField: parameters.lawyerId.toString(),
        ApiConstants.isSubscriberToInstantLawyerServiceField: parameters.isSubscriberToInstantLawyerService.toString(),
        ApiConstants.isSubscriberToInstantConsultationServiceField: parameters.isSubscriberToInstantConsultationService.toString(),
        ApiConstants.isSubscriberToSecretConsultationServiceField: parameters.isSubscriberToSecretConsultationService.toString(),
        ApiConstants.isSubscriberToEstablishingCompaniesServiceField: parameters.isSubscriberToEstablishingCompaniesService.toString(),
        ApiConstants.isSubscriberToRealEstateLegalAdviceServiceField: parameters.isSubscriberToRealEstateLegalAdviceService.toString(),
        ApiConstants.isSubscriberToInvestmentLegalAdviceServiceField: parameters.isSubscriberToInvestmentLegalAdviceService.toString(),
        ApiConstants.isSubscriberToTrademarkRegistrationAndIntellectualProtectionServField: parameters.isSubscriberToTrademarkRegistrationAndIntellectualProtectionServ.toString(),
        ApiConstants.isSubscriberToDebtCollectionServiceField: parameters.isSubscriberToDebtCollectionService.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.editSubscriptionOfFahemServicesEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return LawyerModel.fromJson(jsonData['lawyer']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('editSubscriptionOfFahemServices: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('editSubscriptionOfFahemServices: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<void> deleteLawyer(DeleteLawyerParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.lawyerIdField: parameters.lawyerId.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.deleteLawyerEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {}
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('deleteLawyer: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('deleteLawyer: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<List<LawyerCategoryModel>> getAllLawyersCategories() async {
    try {
      http.Response response = await http.get(
        Uri.parse(ApiConstants.getAllLawyersCategoriesEndPoint),
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return LawyerCategoryModel.fromJsonList(jsonData['lawyersCategories']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getAllLawyersCategories: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getAllLawyersCategories: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<List<LawyerReviewModel>> getLawyerReviewsForOne(GetLawyerReviewsForOneParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.lawyerIdField: parameters.lawyerId.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.getLawyerReviewsForOneEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return LawyerReviewModel.fromJsonList(jsonData['lawyersReviews']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getLawyerReviewsForOne: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getLawyerReviewsForOne: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<LegalAccountantModel> checkAndGetLegalAccountant(CheckAndGetLegalAccountantParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.emailAddressField: parameters.emailAddress.toString(),
        ApiConstants.passwordField: parameters.password.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.checkAndGetLegalAccountantEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return LegalAccountantModel.fromJson(jsonData['legalAccountant']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('checkAndGetLegalAccountant: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('checkAndGetLegalAccountant: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<LegalAccountantModel> getLegalAccountant(GetLegalAccountantParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.legalAccountantIdField: parameters.legalAccountantId.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.getLegalAccountantEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return LegalAccountantModel.fromJson(jsonData['legalAccountant']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getLegalAccountant: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getLegalAccountant: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<bool> isAllLegalAccountantDataValid(IsAllLegalAccountantDataValidParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.emailAddressField: parameters.emailAddress.toString(),
        ApiConstants.passwordField: parameters.password.toString(),
        ApiConstants.phoneNumberField: parameters.phoneNumber.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.isAllLegalAccountantDataValidEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return jsonData['isAllDataValid'];
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('isAllLegalAccountantDataValid: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('isAllLegalAccountantDataValid: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<LegalAccountantModel> insertLegalAccountant(InsertLegalAccountantParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.nameField: parameters.legalAccountantModel.name.toString(),
        ApiConstants.emailAddressField: parameters.legalAccountantModel.emailAddress.toString(),
        ApiConstants.passwordField: parameters.legalAccountantModel.password.toString(),
        ApiConstants.personalImageField: parameters.legalAccountantModel.personalImage.toString(),
        ApiConstants.jobTitleField: parameters.legalAccountantModel.jobTitle.toString(),
        ApiConstants.addressField: parameters.legalAccountantModel.address.toString(),
        ApiConstants.informationField: parameters.legalAccountantModel.information.toString(),
        ApiConstants.phoneNumberField: parameters.legalAccountantModel.phoneNumber.toString(),
        ApiConstants.consultationPriceField: parameters.legalAccountantModel.consultationPrice.toString(),
        ApiConstants.tasksField: parameters.legalAccountantModel.tasks.join('--'),
        ApiConstants.imagesField: parameters.legalAccountantModel.images.join('--'),
        ApiConstants.latitudeField: parameters.legalAccountantModel.latitude.toString(),
        ApiConstants.longitudeField: parameters.legalAccountantModel.longitude.toString(),
        ApiConstants.governorateField: parameters.legalAccountantModel.governorate.toString(),
        ApiConstants.accountStatusField: parameters.legalAccountantModel.accountStatus.name.toString(),
        ApiConstants.isBookingByAppointmentField: parameters.legalAccountantModel.isBookingByAppointment.toString(),
        ApiConstants.availablePeriodsField: parameters.legalAccountantModel.availablePeriods.join('--'),
        ApiConstants.identificationImagesField: parameters.legalAccountantModel.identificationImages.join('--'),
        ApiConstants.createdAtField: parameters.legalAccountantModel.createdAt.millisecondsSinceEpoch.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.insertLegalAccountantEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return LegalAccountantModel.fromJson(jsonData['legalAccountant']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('insertLegalAccountant: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('insertLegalAccountant: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<LegalAccountantModel> editLegalAccountant(EditLegalAccountantParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.legalAccountantIdField: parameters.legalAccountantModel.legalAccountantId.toString(),
        ApiConstants.nameField: parameters.legalAccountantModel.name.toString(),
        ApiConstants.emailAddressField: parameters.legalAccountantModel.emailAddress.toString(),
        ApiConstants.passwordField: parameters.legalAccountantModel.password.toString(),
        ApiConstants.personalImageField: parameters.legalAccountantModel.personalImage.toString(),
        ApiConstants.jobTitleField: parameters.legalAccountantModel.jobTitle.toString(),
        ApiConstants.addressField: parameters.legalAccountantModel.address.toString(),
        ApiConstants.informationField: parameters.legalAccountantModel.information.toString(),
        ApiConstants.phoneNumberField: parameters.legalAccountantModel.phoneNumber.toString(),
        ApiConstants.consultationPriceField: parameters.legalAccountantModel.consultationPrice.toString(),
        ApiConstants.tasksField: parameters.legalAccountantModel.tasks.join('--'),
        ApiConstants.imagesField: parameters.legalAccountantModel.images.join('--'),
        ApiConstants.latitudeField: parameters.legalAccountantModel.latitude.toString(),
        ApiConstants.longitudeField: parameters.legalAccountantModel.longitude.toString(),
        ApiConstants.governorateField: parameters.legalAccountantModel.governorate.toString(),
        ApiConstants.accountStatusField: parameters.legalAccountantModel.accountStatus.name.toString(),
        ApiConstants.isBookingByAppointmentField: parameters.legalAccountantModel.isBookingByAppointment.toString(),
        ApiConstants.availablePeriodsField: parameters.legalAccountantModel.availablePeriods.join('--'),
        ApiConstants.identificationImagesField: parameters.legalAccountantModel.identificationImages.join('--'),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.editLegalAccountantEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return LegalAccountantModel.fromJson(jsonData['legalAccountant']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('editLegalAccountant: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('editLegalAccountant: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<void> deleteLegalAccountant(DeleteLegalAccountantParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.legalAccountantIdField: parameters.legalAccountantId.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.deleteLegalAccountantEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {}
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('deleteLegalAccountant: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('deleteLegalAccountant: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<List<LegalAccountantReviewModel>> getLegalAccountantReviewsForOne(GetLegalAccountantReviewsForOneParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.legalAccountantIdField: parameters.legalAccountantId.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.getLegalAccountantReviewsForOneEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return LegalAccountantReviewModel.fromJsonList(jsonData['legalAccountantsReviews']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getLegalAccountantReviewsForOne: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getLegalAccountantReviewsForOne: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<PublicRelationModel> checkAndGetPublicRelation(CheckAndGetPublicRelationParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.emailAddressField: parameters.emailAddress.toString(),
        ApiConstants.passwordField: parameters.password.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.checkAndGetPublicRelationEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return PublicRelationModel.fromJson(jsonData['publicRelation']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('checkAndGetPublicRelation: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('checkAndGetPublicRelation: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<PublicRelationModel> getPublicRelation(GetPublicRelationParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.publicRelationIdField: parameters.publicRelationId.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.getPublicRelationEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return PublicRelationModel.fromJson(jsonData['publicRelation']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getPublicRelation: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getPublicRelation: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<bool> isAllPublicRelationDataValid(IsAllPublicRelationDataValidParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.emailAddressField: parameters.emailAddress.toString(),
        ApiConstants.passwordField: parameters.password.toString(),
        ApiConstants.phoneNumberField: parameters.phoneNumber.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.isAllPublicRelationDataValidEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return jsonData['isAllDataValid'];
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('isAllPublicRelationDataValid: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('isAllPublicRelationDataValid: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<PublicRelationModel> insertPublicRelation(InsertPublicRelationParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.nameField: parameters.publicRelationModel.name.toString(),
        ApiConstants.emailAddressField: parameters.publicRelationModel.emailAddress.toString(),
        ApiConstants.passwordField: parameters.publicRelationModel.password.toString(),
        ApiConstants.categoriesIdsField: parameters.publicRelationModel.categoriesIds.join('--'),
        ApiConstants.personalImageField: parameters.publicRelationModel.personalImage.toString(),
        ApiConstants.jobTitleField: parameters.publicRelationModel.jobTitle.toString(),
        ApiConstants.addressField: parameters.publicRelationModel.address.toString(),
        ApiConstants.informationField: parameters.publicRelationModel.information.toString(),
        ApiConstants.phoneNumberField: parameters.publicRelationModel.phoneNumber.toString(),
        ApiConstants.consultationPriceField: parameters.publicRelationModel.consultationPrice.toString(),
        ApiConstants.tasksField: parameters.publicRelationModel.tasks.join('--'),
        ApiConstants.imagesField: parameters.publicRelationModel.images.join('--'),
        ApiConstants.latitudeField: parameters.publicRelationModel.latitude.toString(),
        ApiConstants.longitudeField: parameters.publicRelationModel.longitude.toString(),
        ApiConstants.governorateField: parameters.publicRelationModel.governorate.toString(),
        ApiConstants.accountStatusField: parameters.publicRelationModel.accountStatus.name.toString(),
        ApiConstants.isBookingByAppointmentField: parameters.publicRelationModel.isBookingByAppointment.toString(),
        ApiConstants.availablePeriodsField: parameters.publicRelationModel.availablePeriods.join('--'),
        ApiConstants.identificationImagesField: parameters.publicRelationModel.identificationImages.join('--'),
        ApiConstants.createdAtField: parameters.publicRelationModel.createdAt.millisecondsSinceEpoch.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.insertPublicRelationEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return PublicRelationModel.fromJson(jsonData['publicRelation']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('insertPublicRelation: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('insertPublicRelation: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<PublicRelationModel> editPublicRelation(EditPublicRelationParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.publicRelationIdField: parameters.publicRelationModel.publicRelationId.toString(),
        ApiConstants.nameField: parameters.publicRelationModel.name.toString(),
        ApiConstants.emailAddressField: parameters.publicRelationModel.emailAddress.toString(),
        ApiConstants.passwordField: parameters.publicRelationModel.password.toString(),
        ApiConstants.categoriesIdsField: parameters.publicRelationModel.categoriesIds.join('--'),
        ApiConstants.personalImageField: parameters.publicRelationModel.personalImage.toString(),
        ApiConstants.jobTitleField: parameters.publicRelationModel.jobTitle.toString(),
        ApiConstants.addressField: parameters.publicRelationModel.address.toString(),
        ApiConstants.informationField: parameters.publicRelationModel.information.toString(),
        ApiConstants.phoneNumberField: parameters.publicRelationModel.phoneNumber.toString(),
        ApiConstants.consultationPriceField: parameters.publicRelationModel.consultationPrice.toString(),
        ApiConstants.tasksField: parameters.publicRelationModel.tasks.join('--'),
        ApiConstants.imagesField: parameters.publicRelationModel.images.join('--'),
        ApiConstants.latitudeField: parameters.publicRelationModel.latitude.toString(),
        ApiConstants.longitudeField: parameters.publicRelationModel.longitude.toString(),
        ApiConstants.governorateField: parameters.publicRelationModel.governorate.toString(),
        ApiConstants.accountStatusField: parameters.publicRelationModel.accountStatus.name.toString(),
        ApiConstants.isBookingByAppointmentField: parameters.publicRelationModel.isBookingByAppointment.toString(),
        ApiConstants.availablePeriodsField: parameters.publicRelationModel.availablePeriods.join('--'),
        ApiConstants.identificationImagesField: parameters.publicRelationModel.identificationImages.join('--'),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.editPublicRelationEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return PublicRelationModel.fromJson(jsonData['publicRelation']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('editPublicRelation: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('editPublicRelation: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<void> deletePublicRelation(DeletePublicRelationParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.publicRelationIdField: parameters.publicRelationId.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.deletePublicRelationEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {}
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('deletePublicRelation: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('deletePublicRelation: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<List<PublicRelationCategoryModel>> getAllPublicRelationsCategories() async {
    try {
      http.Response response = await http.get(
        Uri.parse(ApiConstants.getAllPublicRelationsCategoriesEndPoint),
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return PublicRelationCategoryModel.fromJsonList(jsonData['publicRelationsCategories']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getAllPublicRelationsCategories: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getAllPublicRelationsCategories: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<List<PublicRelationReviewModel>> getPublicRelationsReviewsForOne(GetPublicRelationsReviewsForOneParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.publicRelationIdField: parameters.publicRelationId.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.getPublicRelationReviewsForOneEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return PublicRelationReviewModel.fromJsonList(jsonData['publicRelationsReviews']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getPublicRelationsReviewsForOne: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getPublicRelationsReviewsForOne: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<List<TransactionModel>> getRequestThePhoneNumberForTarget(GetRequestThePhoneNumberForTargetParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.targetIdField: parameters.targetId.toString(),
        ApiConstants.transactionTypeField: parameters.transactionType.toString(),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.getRequestThePhoneNumberForTargetEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return TransactionModel.fromJsonList(jsonData['transactionTypeShowNumbers']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('getRequestThePhoneNumberForTarget: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('getRequestThePhoneNumberForTarget: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<LawyerModel> editLawyerIdentificationImages(EditLawyerIdentificationImagesParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.lawyerIdField: parameters.lawyerId.toString(),
        ApiConstants.identificationImagesField: parameters.identificationImages.join('--'),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.editLawyerIdentificationImagesEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return LawyerModel.fromJson(jsonData['lawyer']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('editLawyerIdentificationImages: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('editLawyerIdentificationImages: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<PublicRelationModel> editPublicRelationIdentificationImages(EditPublicRelationIdentificationImagesParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.publicRelationIdField: parameters.publicRelationId.toString(),
        ApiConstants.identificationImagesField: parameters.identificationImages.join('--'),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.editPublicRelationIdentificationImagesEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return PublicRelationModel.fromJson(jsonData['publicRelation']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('editPublicRelationIdentificationImages: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('editPublicRelationIdentificationImages: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<LegalAccountantModel> editLegalAccountantIdentificationImages(EditLegalAccountantIdentificationImagesParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.legalAccountantIdField: parameters.legalAccountantId.toString(),
        ApiConstants.identificationImagesField: parameters.identificationImages.join('--'),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.editLegalAccountantIdentificationImagesEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return LegalAccountantModel.fromJson(jsonData['legalAccountant']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('editLegalAccountantIdentificationImages: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('editLegalAccountantIdentificationImages: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<LawyerModel> editLawyerBookingByAppointment(EditLawyerBookingByAppointmentParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.lawyerIdField: parameters.lawyerId.toString(),
        ApiConstants.isBookingByAppointmentField: parameters.isBookingByAppointment.toString(),
        ApiConstants.availablePeriodsField: parameters.availablePeriods.join('--'),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.editLawyerBookingByAppointmentEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return LawyerModel.fromJson(jsonData['lawyer']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('editLawyerBookingByAppointment: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('editLawyerBookingByAppointment: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<PublicRelationModel> editPublicRelationBookingByAppointment(EditPublicRelationBookingByAppointmentParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.publicRelationIdField: parameters.publicRelationId.toString(),
        ApiConstants.isBookingByAppointmentField: parameters.isBookingByAppointment.toString(),
        ApiConstants.availablePeriodsField: parameters.availablePeriods.join('--'),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.editPublicRelationBookingByAppointmentEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return PublicRelationModel.fromJson(jsonData['publicRelation']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('editPublicRelationBookingByAppointment: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('editPublicRelationBookingByAppointment: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<LegalAccountantModel> editLegalAccountantBookingByAppointment(EditLegalAccountantBookingByAppointmentParameters parameters) async {
    try {
      Map<String, dynamic> body = {
        ApiConstants.legalAccountantIdField: parameters.legalAccountantId.toString(),
        ApiConstants.isBookingByAppointmentField: parameters.isBookingByAppointment.toString(),
        ApiConstants.availablePeriodsField: parameters.availablePeriods.join('--'),
      };

      http.Response response = await http.post(
        Uri.parse(ApiConstants.editLegalAccountantBookingByAppointmentEndPoint),
        body: body,
      );

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        if(jsonData['status']) {
          return LegalAccountantModel.fromJson(jsonData['legalAccountant']);
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('editLegalAccountantBookingByAppointment: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('editLegalAccountantBookingByAppointment: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }

  @override
  Future<String> uploadFile(UploadFileParameters parameters) async {
    try {
      http.MultipartRequest request = http.MultipartRequest("POST", Uri.parse(ApiConstants.uploadFileEndPoint));
      request.fields[ApiConstants.directoryField] = parameters.directory;
      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(ApiConstants.fileField, parameters.file.path, contentType: MediaType('image', parameters.file.path.split('.').last));
      request.files.add(multipartFile);
      http.StreamedResponse response = await request.send();

      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(String.fromCharCodes(await response.stream.toBytes()));
        if(jsonData['status']) {
          return jsonData['file'];
        }
        else {
          throw ServerException(messageAr: jsonData['messageAr'], messageEn: jsonData['messageEn']);
        }
      }
      else {
        debugPrint('uploadFile: ${response.statusCode}: ${response.reasonPhrase}');
        throw ServerException(messageAr: 'حدث خطأ أثناء الاتصال بالخادم', messageEn: 'an error occurred while connecting to the server');
      }
    }
    on ServerException catch(error) {
      throw ServerException(messageAr: error.messageAr, messageEn: error.messageEn);
    }
    catch(error) {
      debugPrint('uploadFile: ${error.toString()}');
      throw ServerException(messageAr: 'حدث خطأ حاول مرة اخرى', messageEn: 'an error occurred try again');
    }
  }
}
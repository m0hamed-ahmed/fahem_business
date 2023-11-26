import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
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

abstract class BaseRepository {
  Future<Either<Failure, VersionModel>> getVersion();
  Future<Either<Failure, List<TransactionModel>>> getBookingAppointmentsForTarget(GetBookingAppointmentsForTargetParameters parameters);
  Future<Either<Failure, List<EmploymentApplicationModel>>> getEmploymentApplicationsForTarget(GetEmploymentApplicationsForTargetParameters parameters);
  Future<Either<Failure, List<TransactionModel>>> getAllInstantConsultationsForLawyer(GetAllInstantConsultationsForLawyerParameters parameters);
  Future<Either<Failure, InstantConsultationCommentModel>> insertInstantConsultationComment(InsertInstantConsultationCommentParameters parameters);
  Future<Either<Failure, List<JobModel>>> getJobsForTarget(GetJobsForTargetParameters parameters);
  Future<Either<Failure, JobModel>> insertJob(InsertJobParameters parameters);
  Future<Either<Failure, JobModel>> editJob(EditJobParameters parameters);
  Future<Either<Failure, void>> deleteJob(DeleteJobParameters parameters);
  Future<Either<Failure, LawyerModel>> checkAndGetLawyer(CheckAndGetLawyerParameters parameters);
  Future<Either<Failure, LawyerModel>> getLawyer(GetLawyerParameters parameters);
  Future<Either<Failure, bool>> isAllLawyerDataValid(IsAllLawyerDataValidParameters parameters);
  Future<Either<Failure, LawyerModel>> insertLawyer(InsertLawyerParameters parameters);
  Future<Either<Failure, LawyerModel>> editLawyer(EditLawyerParameters parameters);
  Future<Either<Failure, LawyerModel>> editSubscriptionOfFahemServices(EditSubscriptionOfFahemServicesParameters parameters);
  Future<Either<Failure, void>> deleteLawyer(DeleteLawyerParameters parameters);
  Future<Either<Failure, List<LawyerCategoryModel>>> getAllLawyersCategories();
  Future<Either<Failure, List<LawyerReviewModel>>> getLawyerReviewsForOne(GetLawyerReviewsForOneParameters parameters);
  Future<Either<Failure, LegalAccountantModel>> checkAndGetLegalAccountant(CheckAndGetLegalAccountantParameters parameters);
  Future<Either<Failure, LegalAccountantModel>> getLegalAccountant(GetLegalAccountantParameters parameters);
  Future<Either<Failure, bool>> isAllLegalAccountantDataValid(IsAllLegalAccountantDataValidParameters parameters);
  Future<Either<Failure, LegalAccountantModel>> insertLegalAccountant(InsertLegalAccountantParameters parameters);
  Future<Either<Failure, LegalAccountantModel>> editLegalAccountant(EditLegalAccountantParameters parameters);
  Future<Either<Failure, void>> deleteLegalAccountant(DeleteLegalAccountantParameters parameters);
  Future<Either<Failure, List<LegalAccountantReviewModel>>> getLegalAccountantReviewsForOne(GetLegalAccountantReviewsForOneParameters parameters);
  Future<Either<Failure, PublicRelationModel>> checkAndGetPublicRelation(CheckAndGetPublicRelationParameters parameters);
  Future<Either<Failure, PublicRelationModel>> getPublicRelation(GetPublicRelationParameters parameters);
  Future<Either<Failure, bool>> isAllPublicRelationDataValid(IsAllPublicRelationDataValidParameters parameters);
  Future<Either<Failure, PublicRelationModel>> insertPublicRelation(InsertPublicRelationParameters parameters);
  Future<Either<Failure, PublicRelationModel>> editPublicRelation(EditPublicRelationParameters parameters);
  Future<Either<Failure, void>> deletePublicRelation(DeletePublicRelationParameters parameters);
  Future<Either<Failure, List<PublicRelationCategoryModel>>> getAllPublicRelationsCategories();
  Future<Either<Failure, List<PublicRelationReviewModel>>> getPublicRelationsReviewsForOne(GetPublicRelationsReviewsForOneParameters parameters);
  Future<Either<Failure, List<TransactionModel>>> getRequestThePhoneNumberForTarget(GetRequestThePhoneNumberForTargetParameters parameters);
  Future<Either<Failure, LawyerModel>> editLawyerIdentificationImages(EditLawyerIdentificationImagesParameters parameters);
  Future<Either<Failure, PublicRelationModel>> editPublicRelationIdentificationImages(EditPublicRelationIdentificationImagesParameters parameters);
  Future<Either<Failure, LegalAccountantModel>> editLegalAccountantIdentificationImages(EditLegalAccountantIdentificationImagesParameters parameters);
  Future<Either<Failure, LawyerModel>> editLawyerBookingByAppointment(EditLawyerBookingByAppointmentParameters parameters);
  Future<Either<Failure, PublicRelationModel>> editPublicRelationBookingByAppointment(EditPublicRelationBookingByAppointmentParameters parameters);
  Future<Either<Failure, LegalAccountantModel>> editLegalAccountantBookingByAppointment(EditLegalAccountantBookingByAppointmentParameters parameters);
  Future<Either<Failure, String>> uploadFile(UploadFileParameters parameters);
}
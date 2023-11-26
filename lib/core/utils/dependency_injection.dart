import 'package:fahem_business/core/network/network_info.dart';
import 'package:fahem_business/core/utils/upload_file_provider.dart';
import 'package:fahem_business/data/data_source/remote/remote_data_source.dart';
import 'package:fahem_business/data/repository/repository.dart';
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
import 'package:fahem_business/domain/usecases/lawyers/get_lawyer_usecase.dart';
import 'package:fahem_business/domain/usecases/lawyers/insert_lawyer_usecase.dart';
import 'package:fahem_business/domain/usecases/lawyers/is_all_lawyer_data_valid_usecase.dart';
import 'package:fahem_business/domain/usecases/lawyers_categories/get_all_lawyers_categories_usecase.dart';
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
import 'package:fahem_business/domain/usecases/public_relations_categories/get_all_public_relations_categories_usecase.dart';
import 'package:fahem_business/domain/usecases/public_relations_reviews/get_public_relations_reviews_for_one_usecase.dart';
import 'package:fahem_business/domain/usecases/shared/upload_file_usecase.dart';
import 'package:fahem_business/domain/usecases/transaction_type_show_numbers/get_transaction_type_show_numbers_for_target_usecase.dart';
import 'package:fahem_business/domain/usecases/version/get_version_usecase.dart';
import 'package:fahem_business/presentation/features/lawyer/lawyer_identification_images/controllers/lawyer_identification_images_provider.dart';
import 'package:fahem_business/presentation/features/lawyer/lawyer_profile/controllers/lawyer_profile_provider.dart';
import 'package:fahem_business/presentation/features/legal_accountant/legal_accountant_identification_images/controllers/legal_accountant_identification_images_provider.dart';
import 'package:fahem_business/presentation/features/legal_accountant/legal_accountant_profile/controllers/legal_accountant_profile_provider.dart';
import 'package:fahem_business/presentation/features/public_relation/public_relation_identification_images/controllers/public_relation_identification_images_provider.dart';
import 'package:fahem_business/presentation/features/public_relation/public_relation_profile/controllers/public_relation_profile_provider.dart';
import 'package:fahem_business/presentation/features/settings/controllers/settings_provider.dart';
import 'package:fahem_business/presentation/features/start/controllers/version_provider.dart';
import 'package:fahem_business/presentation/features/transactions/booking_appointments/controllers/booking_appointments_provider.dart';
import 'package:fahem_business/presentation/features/jobs/employment_applications/controllers/employment_applications_provider.dart';
import 'package:fahem_business/presentation/features/fahem_services_feature/controllers/fahem_services_provider.dart';
import 'package:fahem_business/presentation/features/transactions/instant_consultations/controllers/instant_consultations_provider.dart';
import 'package:fahem_business/presentation/features/jobs/jobs/controllers/jobs_provider.dart';
import 'package:fahem_business/presentation/features/lawyer/lawyer/controllers/lawyers_categories_provider.dart';
import 'package:fahem_business/presentation/features/lawyer/lawyer/controllers/lawyer_provider.dart';
import 'package:fahem_business/presentation/features/lawyer/lawyer_reviews/controllers/lawyer_reviews_provider.dart';
import 'package:fahem_business/presentation/features/legal_accountant/legal_accountant/controllers/legal_accountant_provider.dart';
import 'package:fahem_business/presentation/features/legal_accountant/legal_accountant_reviews/controllers/legal_accountant_reviews_provider.dart';
import 'package:fahem_business/presentation/features/public_relation/public_relation/controllers/public_relations_categories_provider.dart';
import 'package:fahem_business/presentation/features/public_relation/public_relation/controllers/public_relation_provider.dart';
import 'package:fahem_business/presentation/features/public_relation/public_relation_reviews/controllers/public_relation_reviews_provider.dart';
import 'package:fahem_business/presentation/features/transactions/request_the_phone_number/controllers/request_the_phone_number_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final GetIt getIt = GetIt.instance;

class DependencyInjection {
   static void init() {

    // Core
    getIt.registerLazySingleton<BaseNetworkInfo>(() => NetworkInfo(InternetConnectionChecker()));

    // Provider
    getIt.registerFactory(() => VersionProvider(getIt()));
    getIt.registerFactory(() => LawyerProvider(getIt(), getIt(), getIt(), getIt(), getIt()));
    getIt.registerFactory(() => LawyersCategoriesProvider(getIt()));
    getIt.registerFactory(() => LawyerReviewsProvider(getIt()));
    getIt.registerFactory(() => LawyerProfileProvider(getIt()));
    getIt.registerFactory(() => LawyerIdentificationImagesProvider(getIt()));
    getIt.registerFactory(() => PublicRelationProvider(getIt(), getIt(), getIt(), getIt(), getIt()));
    getIt.registerFactory(() => PublicRelationsCategoriesProvider(getIt()));
    getIt.registerFactory(() => PublicRelationReviewsProvider(getIt()));
    getIt.registerFactory(() => PublicRelationProfileProvider(getIt()));
    getIt.registerFactory(() => PublicRelationIdentificationImagesProvider(getIt()));
    getIt.registerFactory(() => LegalAccountantProvider(getIt(), getIt(), getIt(), getIt(), getIt()));
    getIt.registerFactory(() => LegalAccountantReviewsProvider(getIt()));
    getIt.registerFactory(() => LegalAccountantProfileProvider(getIt()));
    getIt.registerFactory(() => LegalAccountantIdentificationImagesProvider(getIt()));
    getIt.registerFactory(() => JobsProvider(getIt(), getIt(), getIt(), getIt()));
    getIt.registerFactory(() => EmploymentApplicationsProvider(getIt()));
    getIt.registerFactory(() => RequestThePhoneNumberProvider(getIt()));
    getIt.registerFactory(() => BookingAppointmentsProvider(getIt()));
    getIt.registerFactory(() => FahemServicesProvider(getIt()));
    getIt.registerFactory(() => InstantConsultationsProvider(getIt(), getIt()));
    getIt.registerFactory(() => SettingsProvider(getIt(), getIt(), getIt()));
    getIt.registerFactory(() => UploadFileProvider(getIt()));

    // Usecase
    getIt.registerLazySingleton<GetVersionUseCase>(() => GetVersionUseCase(getIt()));
    getIt.registerLazySingleton<CheckAndGetLawyerUseCase>(() => CheckAndGetLawyerUseCase(getIt()));
    getIt.registerLazySingleton<GetLawyerUseCase>(() => GetLawyerUseCase(getIt()));
    getIt.registerLazySingleton<IsAllLawyerDataValidUseCase>(() => IsAllLawyerDataValidUseCase(getIt()));
    getIt.registerLazySingleton<InsertLawyerUseCase>(() => InsertLawyerUseCase(getIt()));
    getIt.registerLazySingleton<EditLawyerUseCase>(() => EditLawyerUseCase(getIt()));
    getIt.registerLazySingleton<DeleteLawyerUseCase>(() => DeleteLawyerUseCase(getIt()));
    getIt.registerLazySingleton<GetAllLawyersCategoriesUseCase>(() => GetAllLawyersCategoriesUseCase(getIt()));
    getIt.registerLazySingleton<GetLawyerReviewsForOneUseCase>(() => GetLawyerReviewsForOneUseCase(getIt()));
    getIt.registerLazySingleton<EditLawyerIdentificationImagesUseCase>(() => EditLawyerIdentificationImagesUseCase(getIt()));
    getIt.registerLazySingleton<CheckAndGetPublicRelationUseCase>(() => CheckAndGetPublicRelationUseCase(getIt()));
    getIt.registerLazySingleton<GetPublicRelationUseCase>(() => GetPublicRelationUseCase(getIt()));
    getIt.registerLazySingleton<IsAllPublicRelationDataValidUseCase>(() => IsAllPublicRelationDataValidUseCase(getIt()));
    getIt.registerLazySingleton<InsertPublicRelationUseCase>(() => InsertPublicRelationUseCase(getIt()));
    getIt.registerLazySingleton<EditPublicRelationUseCase>(() => EditPublicRelationUseCase(getIt()));
    getIt.registerLazySingleton<DeletePublicRelationUseCase>(() => DeletePublicRelationUseCase(getIt()));
    getIt.registerLazySingleton<GetAllPublicRelationsCategoriesUseCase>(() => GetAllPublicRelationsCategoriesUseCase(getIt()));
    getIt.registerLazySingleton<GetPublicRelationsReviewsForOneUseCase>(() => GetPublicRelationsReviewsForOneUseCase(getIt()));
    getIt.registerLazySingleton<EditPublicRelationIdentificationImagesUseCase>(() => EditPublicRelationIdentificationImagesUseCase(getIt()));
    getIt.registerLazySingleton<CheckAndGetLegalAccountantUseCase>(() => CheckAndGetLegalAccountantUseCase(getIt()));
    getIt.registerLazySingleton<GetLegalAccountantUseCase>(() => GetLegalAccountantUseCase(getIt()));
    getIt.registerLazySingleton<IsAllLegalAccountantDataValidUseCase>(() => IsAllLegalAccountantDataValidUseCase(getIt()));
    getIt.registerLazySingleton<InsertLegalAccountantUseCase>(() => InsertLegalAccountantUseCase(getIt()));
    getIt.registerLazySingleton<EditLegalAccountantUseCase>(() => EditLegalAccountantUseCase(getIt()));
    getIt.registerLazySingleton<DeleteLegalAccountantUseCase>(() => DeleteLegalAccountantUseCase(getIt()));
    getIt.registerLazySingleton<GetLegalAccountantReviewsForOneUseCase>(() => GetLegalAccountantReviewsForOneUseCase(getIt()));
    getIt.registerLazySingleton<EditLegalAccountantIdentificationImagesUseCase>(() => EditLegalAccountantIdentificationImagesUseCase(getIt()));
    getIt.registerLazySingleton<GetJobsForTargetUseCase>(() => GetJobsForTargetUseCase(getIt()));
    getIt.registerLazySingleton<InsertJobUseCase>(() => InsertJobUseCase(getIt()));
    getIt.registerLazySingleton<EditJobUseCase>(() => EditJobUseCase(getIt()));
    getIt.registerLazySingleton<DeleteJobUseCase>(() => DeleteJobUseCase(getIt()));
    getIt.registerLazySingleton<GetEmploymentApplicationsForTargetUseCase>(() => GetEmploymentApplicationsForTargetUseCase(getIt()));
    getIt.registerLazySingleton<GetRequestThePhoneNumberForTargetUseCase>(() => GetRequestThePhoneNumberForTargetUseCase(getIt()));
    getIt.registerLazySingleton<GetBookingAppointmentsForTargetUseCase>(() => GetBookingAppointmentsForTargetUseCase(getIt()));
    getIt.registerLazySingleton<EditSubscriptionOfFahemServicesUseCase>(() => EditSubscriptionOfFahemServicesUseCase(getIt()));
    getIt.registerLazySingleton<GetAllInstantConsultationsForLawyerUseCase>(() => GetAllInstantConsultationsForLawyerUseCase(getIt()));
    getIt.registerLazySingleton<InsertInstantConsultationCommentUseCase>(() => InsertInstantConsultationCommentUseCase(getIt()));
    getIt.registerLazySingleton<EditLawyerBookingByAppointmentUseCase>(() => EditLawyerBookingByAppointmentUseCase(getIt()));
    getIt.registerLazySingleton<EditPublicRelationBookingByAppointmentUseCase>(() => EditPublicRelationBookingByAppointmentUseCase(getIt()));
    getIt.registerLazySingleton<EditLegalAccountantBookingByAppointmentUseCase>(() => EditLegalAccountantBookingByAppointmentUseCase(getIt()));
    getIt.registerLazySingleton<UploadFileUseCase>(() => UploadFileUseCase(getIt()));

    // Repository
    getIt.registerLazySingleton<BaseRepository>(() => Repository(getIt(), getIt()));

    // Data Source
    getIt.registerLazySingleton<BaseRemoteDataSource>(() => RemoteDataSource());
  }
}
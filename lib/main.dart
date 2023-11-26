import 'package:fahem_business/core/services/notification_service.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/cache_helper.dart';
import 'package:fahem_business/core/utils/dependency_injection.dart';
import 'package:fahem_business/core/utils/my_app.dart';
import 'package:fahem_business/core/utils/upload_file_provider.dart';
import 'package:fahem_business/presentation/features/authentication/controllers/login_provider.dart';
import 'package:fahem_business/presentation/features/authentication/controllers/register_lawyer_provider.dart';
import 'package:fahem_business/presentation/features/authentication/controllers/register_legal_account_provider.dart';
import 'package:fahem_business/presentation/features/authentication/controllers/register_public_relation_provider.dart';
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
import 'package:fahem_business/presentation/features/jobs/jobs/controllers/add_job_provider.dart';
import 'package:fahem_business/presentation/features/jobs/jobs/controllers/edit_job_provider.dart';
import 'package:fahem_business/presentation/features/jobs/jobs/controllers/job_details_provider.dart';
import 'package:fahem_business/presentation/features/jobs/jobs/controllers/jobs_provider.dart';
import 'package:fahem_business/presentation/features/lawyer/lawyer/controllers/lawyer_provider.dart';
import 'package:fahem_business/presentation/features/lawyer/lawyer/controllers/lawyers_categories_provider.dart';
import 'package:fahem_business/presentation/features/lawyer/lawyer_reviews/controllers/lawyer_reviews_provider.dart';
import 'package:fahem_business/presentation/features/legal_accountant/legal_accountant/controllers/legal_accountant_provider.dart';
import 'package:fahem_business/presentation/features/legal_accountant/legal_accountant_reviews/controllers/legal_accountant_reviews_provider.dart';
import 'package:fahem_business/presentation/features/main/controllers/main_provider.dart';
import 'package:fahem_business/presentation/features/public_relation/public_relation/controllers/public_relation_provider.dart';
import 'package:fahem_business/presentation/features/public_relation/public_relation/controllers/public_relations_categories_provider.dart';
import 'package:fahem_business/presentation/features/public_relation/public_relation_reviews/controllers/public_relation_reviews_provider.dart';
import 'package:fahem_business/presentation/features/start/controllers/splash_provider.dart';
import 'package:fahem_business/presentation/features/transactions/request_the_phone_number/controllers/request_the_phone_number_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'presentation/features/lawyer/lawyer_identification_images/controllers/lawyer_identification_images_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Firebase.initializeApp();
  await CacheHelper.init();
  DependencyInjection.init();
  await NotificationService.init();

  await initializeDateFormatting().then((value) {
    runApp(
      Phoenix(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => getIt<VersionProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<LawyerProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<LawyersCategoriesProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<LawyerReviewsProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<LawyerProfileProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<LawyerIdentificationImagesProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<PublicRelationProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<PublicRelationsCategoriesProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<PublicRelationReviewsProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<PublicRelationProfileProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<PublicRelationIdentificationImagesProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<LegalAccountantProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<LegalAccountantReviewsProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<LegalAccountantProfileProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<LegalAccountantIdentificationImagesProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<JobsProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<EmploymentApplicationsProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<RequestThePhoneNumberProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<BookingAppointmentsProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<FahemServicesProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<InstantConsultationsProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<SettingsProvider>()),
            ChangeNotifierProvider(create: (context) => getIt<UploadFileProvider>()),

            ChangeNotifierProvider(create: (context) => AppProvider(
              isEnglish: CacheHelper.getData(key: PREFERENCES_KEY_IS_ENGLISH) ?? false,
            )),
            ChangeNotifierProvider(create: (context) => SplashProvider()),
            ChangeNotifierProvider(create: (context) => LoginProvider()),
            ChangeNotifierProvider(create: (context) => RegisterLawyerProvider()),
            ChangeNotifierProvider(create: (context) => RegisterPublicRelationProvider()),
            ChangeNotifierProvider(create: (context) => RegisterLegalAccountantProvider()),
            ChangeNotifierProvider(create: (context) => MainProvider()),
            ChangeNotifierProvider(create: (context) => JobDetailsProvider()),
            ChangeNotifierProvider(create: (context) => AddJobProvider()),
            ChangeNotifierProvider(create: (context) => EditJobProvider()),
          ],
          child: MyApp(),
        ),
      ),
    );
  });
}
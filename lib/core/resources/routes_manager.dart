import 'package:fahem_business/core/resources/constants_manager.dart';
import 'package:fahem_business/presentation/features/authentication/screens/login_screen.dart';
import 'package:fahem_business/presentation/features/authentication/screens/register_lawyer_screen.dart';
import 'package:fahem_business/presentation/features/authentication/screens/register_legal_account_screen.dart';
import 'package:fahem_business/presentation/features/authentication/screens/register_public_relation_screen.dart';
import 'package:fahem_business/presentation/features/authentication/screens/select_account_type_screen.dart';
import 'package:fahem_business/presentation/features/fahem_services_feature/screens/fahem_services_screen.dart';
import 'package:fahem_business/presentation/features/jobs/employment_applications/screens/employment_applications_screen.dart';
import 'package:fahem_business/presentation/features/jobs/jobs/screens/add_job_screen.dart';
import 'package:fahem_business/presentation/features/jobs/jobs/screens/edit_job_screen.dart';
import 'package:fahem_business/presentation/features/jobs/jobs/screens/job_details_screen.dart';
import 'package:fahem_business/presentation/features/jobs/jobs/screens/jobs_screen.dart';
import 'package:fahem_business/presentation/features/lawyer/lawyer_identification_images/screens/lawyer_identification_images_screen.dart';
import 'package:fahem_business/presentation/features/lawyer/lawyer_profile/screens/lawyer_profile_screen.dart';
import 'package:fahem_business/presentation/features/lawyer/lawyer_reviews/screens/lawyer_reviews_screen.dart';
import 'package:fahem_business/presentation/features/legal_accountant/legal_accountant_identification_images/screens/legal_accountant_identification_images_screen.dart';
import 'package:fahem_business/presentation/features/legal_accountant/legal_accountant_profile/screens/legal_accountant_profile_screen.dart';
import 'package:fahem_business/presentation/features/legal_accountant/legal_accountant_reviews/screens/legal_accountant_reviews_screen.dart';
import 'package:fahem_business/presentation/features/main/screens/main_screen.dart';
import 'package:fahem_business/presentation/features/public_relation/public_relation_identification_images/screens/public_relation_identification_images_screen.dart';
import 'package:fahem_business/presentation/features/public_relation/public_relation_profile/screens/public_relation_profile_screen.dart';
import 'package:fahem_business/presentation/features/public_relation/public_relation_reviews/screens/public_relation_reviews_screen.dart';
import 'package:fahem_business/presentation/features/settings/screens/settings_screen.dart';
import 'package:fahem_business/presentation/features/show_full_image/screens/show_full_image_screen.dart';
import 'package:fahem_business/presentation/features/start/screens/splash_screen.dart';
import 'package:fahem_business/presentation/features/start/screens/start_screen.dart';
import 'package:fahem_business/presentation/features/transactions/booking_appointments/screens/booking_appointments_screen.dart';
import 'package:fahem_business/presentation/features/transactions/instant_consultations/screens/instant_consultations_screen.dart';
import 'package:fahem_business/presentation/features/transactions/request_the_phone_number/screens/request_the_phone_number_screen.dart';
import 'package:flutter/material.dart';

class Routes {

  // Authentication
  static const String loginRoute = '/loginRoute';
  static const String selectAccountTypeRoute = '/selectAccountTypeRoute';
  static const String registerLawyerRoute = '/registerLawyerRoute';
  static const String registerPublicRelationRoute = '/registerPublicRelationRoute';
  static const String registerLegalAccountantRoute = '/registerLegalAccountantRoute';

  // Splash
  static const String splashRoute = '/splashRoute';
  static const String startRoute = '/startRoute';

  // Main
  static const String mainRoute = '/mainRoute';

  // Lawyer
  static const String lawyerProfileRoute = '/lawyerProfileRoute';
  static const String lawyerReviewsRoute = '/lawyerReviewsRoute';
  static const String lawyerIdentificationImagesRoute = '/lawyerIdentificationImagesRoute';

  // Public Relation
  static const String publicRelationProfileRoute = '/publicRelationProfileRoute';
  static const String publicRelationReviewsRoute = '/publicRelationReviewsRoute';
  static const String publicRelationIdentificationImagesRoute = '/publicRelationIdentificationImagesRoute';

  // Legal Accountant
  static const String legalAccountantProfileRoute = '/legalAccountantProfileRoute';
  static const String legalAccountantReviewsRoute = '/legalAccountantReviewsRoute';
  static const String legalAccountantIdentificationImagesRoute = '/legalAccountantIdentificationImagesRoute';

  // Jobs
  static const String jobsRoute = '/jobsRoute';
  static const String jobDetailsRoute = '/jobDetailsRoute';
  static const String addJobRoute = '/addJobRoute';
  static const String editJobRoute = '/editJobRoute';
  static const String employmentApplicationsRoute = '/employmentApplicationsRoute';

  // Fahem Services Feature
  static const String fahemServicesRoute = '/fahemServicesRoute';

  // Transactions
  static const String instantConsultationsRoute = '/instantConsultationsRoute';
  static const String requestThePhoneNumberRoute = '/requestThePhoneNumberRoute';
  static const String bookingAppointmentsRoute = '/bookingAppointmentsRoute';

  // Settings
  static const String settingsRoute = '/settingsRoute';

  // Show Full Image
  static const String showFullImageRoute = '/showFullImageRoute';
}

PageRouteBuilder onGenerateRoute (routeSettings) {
  return PageRouteBuilder(
    settings: routeSettings,
    transitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return routeSettings.name == Routes.showFullImageRoute ? ShowFullImageScreen(
        image: routeSettings.arguments[ConstantsManager.imageArgument],
        directory: routeSettings.arguments[ConstantsManager.directoryArgument],
      ) : _slideTransition(animation: animation, child: child);
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      switch (routeSettings.name) {

        // Authentication
        case Routes.loginRoute: return const LoginScreen();
        case Routes.selectAccountTypeRoute: return const SelectAccountTypeScreen();
        case Routes.registerLawyerRoute: return const RegisterLawyerScreen();
        case Routes.registerPublicRelationRoute: return const RegisterPublicRelationScreen();
        case Routes.registerLegalAccountantRoute: return const RegisterLegalAccountantScreen();

        // Splash
        case Routes.splashRoute: return const SplashScreen();
        case Routes.startRoute: return const StartScreen();

        // Main
        case Routes.mainRoute: return const MainScreen();

        // Lawyer
        case Routes.lawyerProfileRoute: return const LawyerProfileScreen();
        case Routes.lawyerReviewsRoute: return const LawyerReviewsScreen();
        case Routes.lawyerIdentificationImagesRoute: return const LawyerIdentificationImagesScreen();

        // Public Relation
        case Routes.publicRelationProfileRoute: return const PublicRelationProfileScreen();
        case Routes.publicRelationReviewsRoute: return const PublicRelationReviewsScreen();
        case Routes.publicRelationIdentificationImagesRoute: return const PublicRelationIdentificationImagesScreen();

        // Legal Accountant
        case Routes.legalAccountantProfileRoute: return const LegalAccountantProfileScreen();
        case Routes.legalAccountantReviewsRoute: return const LegalAccountantReviewsScreen();
        case Routes.legalAccountantIdentificationImagesRoute: return const LegalAccountantIdentificationImagesScreen();

        // Jobs
        case Routes.jobsRoute: return const JobsScreen();
        case Routes.jobDetailsRoute: return JobDetailsScreen(jobModel: routeSettings.arguments[ConstantsManager.jobModelArgument], tag: routeSettings.arguments[ConstantsManager.tagArgument]);
        case Routes.addJobRoute: return const AddJobScreen();
        case Routes.editJobRoute: return EditJobScreen(jobModel: routeSettings.arguments[ConstantsManager.jobModelArgument]);
        case Routes.employmentApplicationsRoute: return const EmploymentApplicationsScreen();

        // Fahem Services Feature
        case Routes.fahemServicesRoute: return const FahemServicesScreen();

        // Transactions
        case Routes.instantConsultationsRoute: return const InstantConsultationsScreen();
        case Routes.requestThePhoneNumberRoute: return const RequestThePhoneNumberScreen();
        case Routes.bookingAppointmentsRoute: return const BookingAppointmentsScreen();

        // Settings
        case Routes.settingsRoute: return const SettingsScreen();

        // Trivial Screen
        default: return const TrivialScreen();
      }
    },
  );
}

Widget _slideTransition({required Animation<double> animation, required Widget child}) {
  const Offset begin = Offset(1.0, 0.0);
  const Offset end = Offset.zero;
  const Cubic curve = Curves.ease;
  Animatable<Offset> tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  return SlideTransition(
    position: animation.drive(tween),
    child: child,
  );
}

class TrivialScreen extends StatefulWidget {

  const TrivialScreen({Key? key}) : super(key: key);

  @override
  State<TrivialScreen> createState() => _TrivialScreenState();
}

class _TrivialScreenState extends State<TrivialScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 1)).then((value) {
        Navigator.pushReplacementNamed(context, Routes.startRoute);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

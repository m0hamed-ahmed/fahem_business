import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/lawyers/lawyer_model.dart';
import 'package:fahem_business/domain/repository/base_repository.dart';
import 'package:fahem_business/domain/usecases/base/base_usecase.dart';

class EditSubscriptionOfFahemServicesUseCase extends BaseUseCase<LawyerModel, EditSubscriptionOfFahemServicesParameters> {
  final BaseRepository _baseRepository;

  EditSubscriptionOfFahemServicesUseCase(this._baseRepository);

  @override
  Future<Either<Failure, LawyerModel>> call(EditSubscriptionOfFahemServicesParameters parameters) async {
    return await _baseRepository.editSubscriptionOfFahemServices(parameters);
  }
}

class EditSubscriptionOfFahemServicesParameters {
  final int lawyerId;
  final bool isSubscriberToInstantLawyerService;
  final bool isSubscriberToInstantConsultationService;
  final bool isSubscriberToSecretConsultationService;
  final bool isSubscriberToEstablishingCompaniesService;
  final bool isSubscriberToRealEstateLegalAdviceService;
  final bool isSubscriberToInvestmentLegalAdviceService;
  final bool isSubscriberToTrademarkRegistrationAndIntellectualProtectionServ;
  final bool isSubscriberToDebtCollectionService;

  EditSubscriptionOfFahemServicesParameters({
    required this.lawyerId,
    required this.isSubscriberToInstantLawyerService,
    required this.isSubscriberToInstantConsultationService,
    required this.isSubscriberToSecretConsultationService,
    required this.isSubscriberToEstablishingCompaniesService,
    required this.isSubscriberToRealEstateLegalAdviceService,
    required this.isSubscriberToInvestmentLegalAdviceService,
    required this.isSubscriberToTrademarkRegistrationAndIntellectualProtectionServ,
    required this.isSubscriberToDebtCollectionService,
  });
}
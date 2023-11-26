import 'package:fahem_business/core/resources/constants_manager.dart';

enum JobDetailsMode {jobDetails, aboutCompany}

enum CommentStatus {active, pending, rejected}

enum FahemServiceType {
  instantLawyer,
  instantConsultation,
  secretConsultation,
  establishingCompanies,
  realEstateLegalAdvice,
  investmentLegalAdvice,
  trademarkRegistrationAndIntellectualProtection,
  debtCollection,
}

enum TransactionType {
  instantConsultation,
  showLawyerNumber,
  showPublicRelationNumber,
  showLegalAccountantNumber,
  appointmentBookingWithLawyer,
  appointmentBookingWithPublicRelation,
  appointmentBookingWithLegalAccountant;

  static TransactionType toTransactionType(String transactionType) {
    switch(transactionType) {
      case ConstantsManager.instantConsultationEnum: return TransactionType.instantConsultation;
      case ConstantsManager.showLawyerNumberEnum: return TransactionType.showLawyerNumber;
      case ConstantsManager.showPublicRelationNumberEnum: return TransactionType.showPublicRelationNumber;
      case ConstantsManager.showLegalAccountantNumberEnum: return TransactionType.showLegalAccountantNumber;
      case ConstantsManager.appointmentBookingWithLawyerEnum: return TransactionType.appointmentBookingWithLawyer;
      case ConstantsManager.appointmentBookingWithPublicRelationEnum: return TransactionType.appointmentBookingWithPublicRelation;
      case ConstantsManager.appointmentBookingWithLegalAccountantEnum: return TransactionType.appointmentBookingWithLegalAccountant;
      default: return TransactionType.instantConsultation;
    }
  }
}

enum AccountTypeEnum {lawyers, publicRelations, legalAccountants}

enum ShowMessage {success, failure}

enum AccountStatus {
  pending, acceptable, unacceptable;

  static AccountStatus toAccountStatus(String accountStatus) {
    switch(accountStatus) {
      case ConstantsManager.acceptableEnum: return AccountStatus.acceptable;
      case ConstantsManager.pendingEnum: return AccountStatus.pending;
      default: return AccountStatus.unacceptable;
    }
  }
}
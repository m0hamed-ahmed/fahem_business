import 'package:fahem_business/core/resources/fonts_manager.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/resources/values_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/enums.dart';
import 'package:fahem_business/core/utils/extensions.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/data/data_source/static/fahem_services_data.dart';
import 'package:fahem_business/presentation/features/fahem_services_feature/controllers/fahem_services_provider.dart';
import 'package:fahem_business/presentation/features/lawyer/lawyer/controllers/lawyer_provider.dart';
import 'package:fahem_business/presentation/shared/absorb_pointer_widget.dart';
import 'package:fahem_business/presentation/shared/background.dart';
import 'package:fahem_business/presentation/shared/custom_button.dart';
import 'package:fahem_business/presentation/shared/my_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FahemServicesScreen extends StatefulWidget {

  const FahemServicesScreen({Key? key}) : super(key: key);

  @override
  State<FahemServicesScreen> createState() => _FahemServicesScreenState();
}

class _FahemServicesScreenState extends State<FahemServicesScreen> {
  late AppProvider appProvider;
  late FahemServicesProvider fahemServicesProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    fahemServicesProvider = Provider.of<FahemServicesProvider>(context, listen: false);
    LawyerProvider lawyerProvider = Provider.of<LawyerProvider>(context, listen: false);

    if(lawyerProvider.lawyer.isSubscriberToInstantLawyerService) {fahemServicesProvider.fahemServicesIds.add(FahemServiceType.instantLawyer.name);}
    if(lawyerProvider.lawyer.isSubscriberToInstantConsultationService) {fahemServicesProvider.fahemServicesIds.add(FahemServiceType.instantConsultation.name);}
    if(lawyerProvider.lawyer.isSubscriberToSecretConsultationService) {fahemServicesProvider.fahemServicesIds.add(FahemServiceType.secretConsultation.name);}
    if(lawyerProvider.lawyer.isSubscriberToEstablishingCompaniesService) {fahemServicesProvider.fahemServicesIds.add(FahemServiceType.establishingCompanies.name);}
    if(lawyerProvider.lawyer.isSubscriberToRealEstateLegalAdviceService) {fahemServicesProvider.fahemServicesIds.add(FahemServiceType.realEstateLegalAdvice.name);}
    if(lawyerProvider.lawyer.isSubscriberToInvestmentLegalAdviceService) {fahemServicesProvider.fahemServicesIds.add(FahemServiceType.investmentLegalAdvice.name);}
    if(lawyerProvider.lawyer.isSubscriberToTrademarkRegistrationAndIntellectualProtectionServ) {fahemServicesProvider.fahemServicesIds.add(FahemServiceType.trademarkRegistrationAndIntellectualProtection.name);}
    if(lawyerProvider.lawyer.isSubscriberToDebtCollectionService) {fahemServicesProvider.fahemServicesIds.add(FahemServiceType.debtCollection.name);}
  }

  @override
  Widget build(BuildContext context) {
    return Selector<FahemServicesProvider, bool>(
      selector: (context, provider) => provider.isLoading,
      builder: (context, isLoading, _) {
        return Selector<AppProvider, bool>(
          selector: (context, provider) => provider.isEnglish,
          builder: (context, isEnglish, _) {
            return AbsorbPointerWidget(
              absorbing: isLoading,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: WillPopScope(
                  onWillPop: () => Future.value(!isLoading),
                  child: Directionality(
                    textDirection: Methods.getDirection(appProvider.isEnglish),
                    child: Scaffold(
                      body: Background(
                        child: SafeArea(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(SizeManager.s16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const MyHeader(title: StringsManager.fahemServices),
                                const SizedBox(height: SizeManager.s16),
                                Center(
                                  child: Text(
                                    Methods.getText(StringsManager.subscribeToAnyOfFahemServices, appProvider.isEnglish).toCapitalized(),
                                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s20, fontWeight: FontWeightManager.bold),
                                  ),
                                ),
                                const SizedBox(height: SizeManager.s16),
                                Selector<FahemServicesProvider, int>(
                                  selector: (context, provider) => provider.fahemServicesIds.length,
                                  builder: (context, fahemServicesIdsLength, _) {
                                    return ListView.separated(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return SwitchListTile(
                                          value: fahemServicesProvider.fahemServicesIds.contains(fahemServicesData[index].fahemServiceType.name),
                                          onChanged: (val) => fahemServicesProvider.toggleFahemServiceId(fahemServicesData[index].fahemServiceType.name),
                                          title: Text(
                                            appProvider.isEnglish ? fahemServicesData[index].nameEn : fahemServicesData[index].nameAr,
                                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.bold),
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) => const SizedBox(height: SizeManager.s10),
                                      itemCount: fahemServicesData.length,
                                    );
                                  },
                                ),
                                const SizedBox(height: SizeManager.s16),
                                CustomButton(
                                  buttonType: ButtonType.text,
                                  onPressed: () => fahemServicesProvider.onPressedSave(context),
                                  text: Methods.getText(StringsManager.save, appProvider.isEnglish).toUpperCase(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

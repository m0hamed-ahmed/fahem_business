import 'package:fahem_business/core/resources/colors_manager.dart';
import 'package:fahem_business/core/resources/fonts_manager.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/resources/values_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/extensions.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/data/data_source/static/period_data.dart';
import 'package:fahem_business/presentation/features/settings/controllers/settings_provider.dart';
import 'package:fahem_business/presentation/shared/absorb_pointer_widget.dart';
import 'package:fahem_business/presentation/shared/background.dart';
import 'package:fahem_business/presentation/shared/custom_button.dart';
import 'package:fahem_business/presentation/shared/my_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late AppProvider appProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    settingsProvider.resetAllData();

    settingsProvider.setIsBookingByAppointment(Methods.getTargetModel().isBookingByAppointment);
    settingsProvider.setSelectedPeriods(Methods.getTargetModel().availablePeriods);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<SettingsProvider, bool>(
      selector: (context, provider) => provider.isLoading,
      builder: (context, isLoading, _) {
        return Selector<AppProvider, bool>(
          selector: (context, provider) => provider.isEnglish,
          builder: (context, isEnglish, _) {
            return AbsorbPointerWidget(
              absorbing: isLoading,
              child: WillPopScope(
                onWillPop: () => Future.value(!isLoading),
                child: Directionality(
                  textDirection: Methods.getDirection(appProvider.isEnglish),
                  child: Scaffold(
                    body: Background(
                      child: SafeArea(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(SizeManager.s16),
                          child: Consumer<SettingsProvider>(
                            builder: (context, provider, _) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const MyHeader(title: StringsManager.settings),
                                  const SizedBox(height: SizeManager.s16),

                                  Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      color: ColorsManager.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: ColorsManager.grey300),
                                    ),
                                    child: Column(
                                      children: [
                                        Material(
                                          color: Colors.transparent,
                                          child: SwitchListTile(
                                            value: provider.isBookingByAppointment,
                                            onChanged: (val) => provider.changeIsBookingByAppointment(val),
                                            title: Text(
                                              Methods.getText(StringsManager.bookingByAppointment, appProvider.isEnglish).toCapitalized(),
                                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.bold),
                                            ),
                                            dense: true,
                                          ),
                                        ),
                                        if(provider.isBookingByAppointment) Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '${Methods.getText(StringsManager.chooseTheAvailablePeriods, appProvider.isEnglish).toCapitalized()} *',
                                                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeightManager.bold),
                                                  ),
                                                  if(provider.isButtonClicked && provider.isBookingByAppointment && provider.selectedPeriods.isEmpty) Text(
                                                    ' (${Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized()})',
                                                    style: Theme.of(context).textTheme.displaySmall!.copyWith(color: ColorsManager.red700),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              children: List.generate(periodsData.length, (index) {
                                                return Material(
                                                  color: Colors.transparent,
                                                  child: CheckboxListTile(
                                                    value: provider.selectedPeriods.contains(periodsData[index].periodId),
                                                    onChanged: (val) => provider.toggleSelectedPeriod(periodsData[index].periodId),
                                                    title: Text(
                                                      appProvider.isEnglish ? periodsData[index].nameEn : periodsData[index].nameAr,
                                                      style: Theme.of(context).textTheme.bodySmall,
                                                    ),
                                                    dense: true,
                                                  ),
                                                );
                                              }),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(16),
                                          child: CustomButton(
                                            buttonType: ButtonType.text,
                                            onPressed: () {
                                              provider.changeIsButtonClicked(true);
                                              if(provider.isAllDataValid()) {
                                                provider.onPressedSaveBookingByAppointment(context);
                                              }
                                            },
                                            buttonColor: ColorsManager.primaryColor,
                                            text: Methods.getText(StringsManager.save, appProvider.isEnglish).toUpperCase(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
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
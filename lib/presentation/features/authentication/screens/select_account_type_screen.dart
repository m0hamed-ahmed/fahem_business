import 'package:fahem_business/core/resources/colors_manager.dart';
import 'package:fahem_business/core/resources/fonts_manager.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/resources/values_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/extensions.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/data/data_source/static/accounts_types_data.dart';
import 'package:fahem_business/presentation/shared/background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectAccountTypeScreen extends StatefulWidget {

  const SelectAccountTypeScreen({Key? key}) : super(key: key);

  @override
  State<SelectAccountTypeScreen> createState() => _SelectAccountTypeScreenState();
}

class _SelectAccountTypeScreenState extends State<SelectAccountTypeScreen> {
  late AppProvider appProvider;

  @override
  void initState() {
    appProvider = Provider.of<AppProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<AppProvider, bool>(
      selector: (context, provider) => provider.isEnglish,
      builder: (context, isEnglish, _) {
        return Directionality(
          textDirection: Methods.getDirection(appProvider.isEnglish),
          child: Scaffold(
            body: Background(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(SizeManager.s16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Methods.getText(StringsManager.chooseAccountType, appProvider.isEnglish).toTitleCase(),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: SizeManager.s30, fontWeight: FontWeightManager.black),
                      ),
                      const SizedBox(height: SizeManager.s30),
                      SizedBox(
                        height: SizeManager.s150,
                        child: Row(
                          children: List.generate(accountsTypesData.length, (index) => Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(SizeManager.s5),
                              constraints: const BoxConstraints(
                                minWidth: SizeManager.s130,
                              ),
                              decoration: BoxDecoration(
                                color: ColorsManager.primaryColor,
                                borderRadius: BorderRadius.circular(SizeManager.s10),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => Navigator.pushNamed(context, accountsTypesData[index].route),
                                  borderRadius: BorderRadius.circular(SizeManager.s10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(SizeManager.s10),
                                    child: Column(
                                      children: [
                                        Image.asset(accountsTypesData[index].image, height: SizeManager.s80),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              (appProvider.isEnglish ? accountsTypesData[index].nameEn : accountsTypesData[index].nameAr),
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorsManager.white, fontWeight: FontWeightManager.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
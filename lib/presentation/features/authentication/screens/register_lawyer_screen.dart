import 'package:fahem_business/core/resources/colors_manager.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/resources/values_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/presentation/features/authentication/controllers/register_lawyer_provider.dart';
import 'package:fahem_business/presentation/shared/absorb_pointer_widget.dart';
import 'package:fahem_business/presentation/shared/background.dart';
import 'package:fahem_business/presentation/shared/custom_button.dart';
import 'package:fahem_business/presentation/shared/my_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterLawyerScreen extends StatefulWidget {

  const RegisterLawyerScreen({Key? key}) : super(key: key);

  @override
  State<RegisterLawyerScreen> createState() => _RegisterLawyerScreenState();
}

class _RegisterLawyerScreenState extends State<RegisterLawyerScreen> {
  late AppProvider appProvider;
  late RegisterLawyerProvider registerLawyerProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    registerLawyerProvider = Provider.of<RegisterLawyerProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<RegisterLawyerProvider, bool>(
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
                  onWillPop: () => isLoading ? Future.value(false) : registerLawyerProvider.onBackPressed(context),
                  child: Directionality(
                    textDirection: Methods.getDirection(appProvider.isEnglish),
                    child: Scaffold(
                      body: Background(
                        child: SafeArea(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Selector<RegisterLawyerProvider, int>(
                                  selector: (context, provider) => provider.currentPage,
                                  builder: (context, currentPage, child) {
                                    return Padding(
                                      padding: const EdgeInsets.all(SizeManager.s16),
                                      child: Column(
                                        children: [
                                          MyHeader(
                                            title: StringsManager.createAccount,
                                            onBackPressed: () => registerLawyerProvider.onBackPressed(context),
                                          ),
                                          SizedBox(
                                            height: SizeManager.s15,
                                            child: Row(
                                              children: List.generate(registerLawyerProvider.pages.length, (index) {
                                                return Expanded(
                                                  child: Container(
                                                    margin: EdgeInsetsDirectional.fromSTEB(SizeManager.s0, SizeManager.s0, index == registerLawyerProvider.pages.length-1 ? SizeManager.s10 : SizeManager.s5, SizeManager.s10),
                                                    height: SizeManager.s4,
                                                    decoration: BoxDecoration(
                                                      color: index <= currentPage ? ColorsManager.primaryColor : ColorsManager.grey,
                                                      borderRadius: BorderRadius.circular(SizeManager.s5),
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ),
                                          ),
                                          const SizedBox(height: SizeManager.s16),
                                          Expanded(
                                            child: ConstrainedBox(
                                              constraints: BoxConstraints(minWidth: constraints.maxWidth, minHeight: constraints.maxHeight-15-32),
                                              child: IntrinsicHeight(
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      child: registerLawyerProvider.pages[currentPage],
                                                    ),
                                                    const SizedBox(height: SizeManager.s16),
                                                    CustomButton(
                                                      buttonType: ButtonType.text,
                                                      onPressed: () => registerLawyerProvider.onNextClicked(context),
                                                      buttonColor: ColorsManager.primaryColor,
                                                      borderRadius: SizeManager.s10,
                                                      text: Methods.getText(currentPage == registerLawyerProvider.pages.length-1 ? StringsManager.create : StringsManager.next, appProvider.isEnglish).toUpperCase(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
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
import 'package:fahem_business/core/resources/colors_manager.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/resources/values_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/presentation/features/authentication/controllers/register_legal_account_provider.dart';
import 'package:fahem_business/presentation/shared/absorb_pointer_widget.dart';
import 'package:fahem_business/presentation/shared/background.dart';
import 'package:fahem_business/presentation/shared/custom_button.dart';
import 'package:fahem_business/presentation/shared/my_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterLegalAccountantScreen extends StatefulWidget {

  const RegisterLegalAccountantScreen({Key? key}) : super(key: key);

  @override
  State<RegisterLegalAccountantScreen> createState() => _RegisterLegalAccountantScreenState();
}

class _RegisterLegalAccountantScreenState extends State<RegisterLegalAccountantScreen> {
  late AppProvider appProvider;
  late RegisterLegalAccountantProvider registerLegalAccountantProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    registerLegalAccountantProvider = Provider.of<RegisterLegalAccountantProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<RegisterLegalAccountantProvider, bool>(
      selector: (context, provider) => provider.isLoading,
      builder: (context, isLoading, child) {
        return Selector<AppProvider, bool>(
          selector: (context, provider) => provider.isEnglish,
          builder: (context, isEnglish, _) {
            return AbsorbPointerWidget(
              absorbing: isLoading,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: WillPopScope(
                  onWillPop: () => isLoading ? Future.value(false) : registerLegalAccountantProvider.onBackPressed(context),
                  child: Directionality(
                    textDirection: Methods.getDirection(appProvider.isEnglish),
                    child: Scaffold(
                      body: Background(
                        child: SafeArea(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Selector<RegisterLegalAccountantProvider, int>(
                                  selector: (context, provider) => provider.currentPage,
                                  builder: (context, currentPage, child) {
                                    return Padding(
                                      padding: const EdgeInsets.all(SizeManager.s16),
                                      child: Column(
                                        children: [
                                          MyHeader(
                                            title: StringsManager.createAccount,
                                            onBackPressed: () => registerLegalAccountantProvider.onBackPressed(context),
                                          ),
                                          SizedBox(
                                            height: SizeManager.s15,
                                            child: Row(
                                              children: List.generate(registerLegalAccountantProvider.pages.length, (index) {
                                                return Expanded(
                                                  child: Container(
                                                    margin: EdgeInsetsDirectional.fromSTEB(SizeManager.s0, SizeManager.s0, index == registerLegalAccountantProvider.pages.length-1 ? SizeManager.s10 : SizeManager.s5, SizeManager.s10),
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
                                                      child: registerLegalAccountantProvider.pages[currentPage],
                                                    ),
                                                    const SizedBox(height: SizeManager.s16),
                                                    CustomButton(
                                                      buttonType: ButtonType.text,
                                                      onPressed: () => registerLegalAccountantProvider.onNextClicked(context),
                                                      buttonColor: ColorsManager.primaryColor,
                                                      borderRadius: SizeManager.s10,
                                                      text: Methods.getText(currentPage == registerLegalAccountantProvider.pages.length-1 ? StringsManager.create : StringsManager.next, appProvider.isEnglish).toUpperCase(),
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
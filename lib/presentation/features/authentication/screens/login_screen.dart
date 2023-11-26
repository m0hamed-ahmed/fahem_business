import 'dart:io';

import 'package:fahem_business/core/resources/assets_manager.dart';
import 'package:fahem_business/core/resources/colors_manager.dart';
import 'package:fahem_business/core/resources/constants_manager.dart';
import 'package:fahem_business/core/resources/fonts_manager.dart';
import 'package:fahem_business/core/resources/routes_manager.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/resources/values_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/dialogs.dart';
import 'package:fahem_business/core/utils/extensions.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/core/utils/validator.dart';
import 'package:fahem_business/data/data_source/static/accounts_types_data.dart';
import 'package:fahem_business/data/models/static/account_type_model.dart';
import 'package:fahem_business/presentation/features/authentication/controllers/login_provider.dart';
import 'package:fahem_business/presentation/shared/absorb_pointer_widget.dart';
import 'package:fahem_business/presentation/shared/background.dart';
import 'package:fahem_business/presentation/shared/custom_button.dart';
import 'package:fahem_business/presentation/shared/custom_text_form_field.dart';
import 'package:fahem_business/presentation/shared/drop_down_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AppProvider appProvider;
  late LoginProvider loginProvider;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingControllerEmailAddress = TextEditingController();
  final TextEditingController _textEditingControllerPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    loginProvider = Provider.of<LoginProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<LoginProvider, bool>(
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
                  onWillPop: () => Dialogs.showBottomSheetConfirmation(context: context, message: Methods.getText(StringsManager.doYouWantToExitAnApp, appProvider.isEnglish).toCapitalized()),
                  child: Directionality(
                    textDirection: Methods.getDirection(appProvider.isEnglish),
                    child: Scaffold(
                      body: Background(
                        child: SafeArea(
                          child: Center(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(SizeManager.s16),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Logo
                                    Text(
                                      Methods.getText(StringsManager.appName, appProvider.isEnglish).toTitleCase(),
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: SizeManager.s30, fontWeight: FontWeightManager.black),
                                    ),
                                    const SizedBox(height: SizeManager.s20),
                                    Image.asset(ImagesManager.logo, width: SizeManager.s100, height: SizeManager.s100),
                                    const SizedBox(height: SizeManager.s100),

                                    // Account Type
                                    Selector<LoginProvider, bool>(
                                      selector: (context, provider) => provider.isButtonClicked,
                                      builder: (context, isButtonClicked, _) {
                                        return Selector<LoginProvider, AccountTypeModel?>(
                                          selector: (context, provider) => provider.accountTypeModel,
                                          builder: (context, accountTypeModel, _) {
                                            return DropDownWidget(
                                              hint: StringsManager.accountType,
                                              isRequired: isButtonClicked && accountTypeModel == null,
                                              currentValue: accountTypeModel,
                                              valuesObject: List.generate(accountsTypesData.length, (index) => accountsTypesData[index]),
                                              valuesText: List.generate(accountsTypesData.length, (index) => appProvider.isEnglish ? accountsTypesData[index].nameEn : accountsTypesData[index].nameAr),
                                              onChanged: (val) => loginProvider.changeAccountTypeModel(val as AccountTypeModel),
                                              color: ColorsManager.white,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    const SizedBox(height: SizeManager.s16),

                                    // Email Address
                                    CustomTextFormField(
                                      controller: _textEditingControllerEmailAddress,
                                      keyboardType: TextInputType.emailAddress,
                                      labelText: Methods.getText(StringsManager.emailAddress, appProvider.isEnglish).toCapitalized(),
                                      prefixIcon: const Icon(Icons.email_outlined, color: ColorsManager.primaryColor),
                                      suffixIcon: IconButton(
                                        onPressed: () => _textEditingControllerEmailAddress.clear(),
                                        icon: const Icon(Icons.clear, color: ColorsManager.primaryColor),
                                      ),
                                      validator: (val) {
                                        if(Validator.isEmpty(val!)) {return Methods.getText(StringsManager.required, appProvider.isEnglish);}
                                        else if(!Validator.isEmailAddressValid(val)) {return Methods.getText(StringsManager.pleaseEnterAValidEmailAddress, appProvider.isEnglish);}
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: SizeManager.s16),

                                    // Password
                                    Selector<LoginProvider, bool>(
                                      selector: (context, provider) => provider.isShowPassword,
                                      builder: (context, isShowPassword, child) {
                                        return CustomTextFormField(
                                          controller: _textEditingControllerPassword,
                                          keyboardType: TextInputType.visiblePassword,
                                          labelText: Methods.getText(StringsManager.password, appProvider.isEnglish).toCapitalized(),
                                          obscureText: !isShowPassword,
                                          prefixIcon: const Icon(Icons.lock_outline, color: ColorsManager.primaryColor),
                                          suffixIcon: IconButton(
                                            onPressed: () => loginProvider.changeIsShowPassword(),
                                            icon: Icon(isShowPassword ? Icons.visibility_off : Icons.visibility, color: ColorsManager.primaryColor),
                                          ),
                                          validator: (val) {
                                            if(Validator.isEmpty(val!)) {return Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized();}
                                            return null;
                                          },
                                        );
                                      },
                                    ),
                                    const SizedBox(height: SizeManager.s32),

                                    // Button
                                    CustomButton(
                                      buttonType: ButtonType.text,
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        loginProvider.changeIsButtonClicked(true);
                                        if(_formKey.currentState!.validate() && loginProvider.isAllValid()) {
                                          loginProvider.checkAndGetAccount(
                                            context: context,
                                            emailAddress: _textEditingControllerEmailAddress.text.trim(),
                                            password: _textEditingControllerPassword.text,
                                          );
                                        }
                                      },
                                      text: Methods.getText(StringsManager.login, appProvider.isEnglish).toUpperCase(),
                                    ),
                                    const SizedBox(height: SizeManager.s16),

                                    // Don't Have Account
                                    Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                        Text(
                                          Methods.getText(StringsManager.dontHaveAnAccountYet, appProvider.isEnglish).toCapitalized(),
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            FocusScope.of(context).unfocus();
                                            Navigator.pushNamed(context, Routes.selectAccountTypeRoute);
                                          },
                                          style: TextButton.styleFrom(
                                            visualDensity: const VisualDensity(horizontal: -4),
                                            padding: const EdgeInsets.symmetric(horizontal: SizeManager.s5),
                                          ),
                                          child: Text(
                                            Methods.getText(StringsManager.newAccount, appProvider.isEnglish).toUpperCase(),
                                            style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeightManager.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: SizeManager.s16),

                                    // Fahem App
                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text: Methods.getText(StringsManager.downloadClientApp, appProvider.isEnglish).toCapitalized(),
                                        style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorsManager.black),
                                        children: [
                                          const TextSpan(text: ConstantsManager.space),
                                          TextSpan(
                                            text: Methods.getText(StringsManager.fromHere, appProvider.isEnglish),
                                            style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorsManager.primaryColor, fontWeight: FontWeightManager.black),
                                            recognizer: TapGestureRecognizer()..onTap = () => Methods.openUrl(Platform.isAndroid ? ConstantsManager.fahemPlayStoreUrl : ConstantsManager.fahemAppStoreUrl),
                                          ),
                                        ],
                                      ),
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
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _textEditingControllerEmailAddress.dispose();
    _textEditingControllerPassword.dispose();
    super.dispose();
  }
}
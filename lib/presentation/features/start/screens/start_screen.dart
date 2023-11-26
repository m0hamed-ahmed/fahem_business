import 'package:fahem_business/core/resources/assets_manager.dart';
import 'package:fahem_business/core/resources/routes_manager.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/resources/values_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/cache_helper.dart';
import 'package:fahem_business/core/utils/dialogs.dart';
import 'package:fahem_business/core/utils/extensions.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/presentation/features/lawyer/lawyer/controllers/lawyers_categories_provider.dart';
import 'package:fahem_business/presentation/features/public_relation/public_relation/controllers/public_relations_categories_provider.dart';
import 'package:fahem_business/presentation/shared/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatefulWidget {

  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late AppProvider appProvider;
  late LawyersCategoriesProvider lawyersCategoriesProvider;
  late PublicRelationsCategoriesProvider publicRelationsCategoriesProvider;

  Future<void> _getData() async {
    await lawyersCategoriesProvider.getAllLawyersCategories(context).then((value) async {
      if(lawyersCategoriesProvider.lawyersCategories.isNotEmpty) {
        await publicRelationsCategoriesProvider.getAllPublicRelationsCategories(context).then((value) {
          if(publicRelationsCategoriesProvider.publicRelationsCategories.isNotEmpty) {
            bool isLogged = CacheHelper.getData(key: PREFERENCES_KEY_IS_LOGGED) ?? false;
            Navigator.pushReplacementNamed(context, isLogged ? Routes.splashRoute : Routes.loginRoute);
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    lawyersCategoriesProvider = Provider.of<LawyersCategoriesProvider>(context, listen: false);
    publicRelationsCategoriesProvider = Provider.of<PublicRelationsCategoriesProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Dialogs.showBottomSheetConfirmation(context: context, message: Methods.getText(StringsManager.doYouWantToExitAnApp, appProvider.isEnglish).toCapitalized()),
      child: Directionality(
        textDirection: Methods.getDirection(appProvider.isEnglish),
        child: Scaffold(
          body: FutureBuilder(
            future: _getData(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              else if(snapshot.connectionState == ConnectionState.done && lawyersCategoriesProvider.lawyersCategories.isNotEmpty) {
                return Container();
              }
              else {
                return Padding(
                  padding: const EdgeInsets.all(SizeManager.s32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Image.asset(ImagesManager.oops, width: SizeManager.s200, height: SizeManager.s200),
                      ),
                      const SizedBox(height: SizeManager.s100),
                      CustomButton(
                        buttonType: ButtonType.text,
                        onPressed: () => setState(() {}),
                        text: Methods.getText(StringsManager.tryAgain, appProvider.isEnglish).toTitleCase(),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
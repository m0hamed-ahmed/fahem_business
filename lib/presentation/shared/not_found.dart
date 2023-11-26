import 'package:fahem_business/core/resources/assets_manager.dart';
import 'package:fahem_business/core/resources/values_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/extensions.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class NotFound extends StatelessWidget {
  final String notFoundMessage;

  const NotFound({Key? key, required this.notFoundMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: SizeManager.s100),
            Lottie.asset(ImagesManager.notFound, width: SizeManager.s200, height: SizeManager.s200),
            Text(
              Methods.getText(notFoundMessage, appProvider.isEnglish).toCapitalized(),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s20),
            ),
          ],
        ),
      ),
    );
  }
}
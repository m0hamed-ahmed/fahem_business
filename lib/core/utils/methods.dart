import 'dart:convert';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fahem_business/core/network/firebase_constants.dart';
import 'package:fahem_business/core/resources/constants_manager.dart';
import 'package:fahem_business/core/resources/language_manager.dart';
import 'package:fahem_business/core/resources/routes_manager.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/services/notification_service.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/cache_helper.dart';
import 'package:fahem_business/core/utils/dialogs.dart';
import 'package:fahem_business/core/utils/enums.dart';
import 'package:fahem_business/data/models/lawyers/lawyer_model.dart';
import 'package:fahem_business/data/models/legal_accountant/legal_account_model.dart';
import 'package:fahem_business/data/models/public_relations/public_relation_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart' as intl;

class Methods {

  static String getText(String text, bool isEnglish) {
    String language = isEnglish ? ConstantsManager.english : ConstantsManager.arabic;
    return languageManager[text]![language]!;
  }

  static String formatDate({required BuildContext context, required int milliseconds, bool isDateOnly = false, bool isTimeAndAOnly = false}) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    String locale = appProvider.isEnglish ? 'en_US' : 'ar_EG';

    String date = intl.DateFormat.yMMMMd(locale).format(DateTime.fromMillisecondsSinceEpoch(milliseconds));
    String time = intl.DateFormat('h:mm', locale).format(DateTime.fromMillisecondsSinceEpoch(milliseconds));
    String a = intl.DateFormat('a', locale).format(DateTime.fromMillisecondsSinceEpoch(milliseconds));

    if(isDateOnly) {
      return date;
    }
    else if(isTimeAndAOnly) {
      return '$time $a';
    }
    else {
      return '$date / $time $a';
    }
  }

  static String getYoutubeThumbnail(String videoId) {
    return 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
  }

  static String getRandomId() {
    List<String> characters = [
      '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
      'a','b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
      'A','B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
    ];
    String id = '';
    for(int i=0; i<20; i++) {
      id+= characters[Random().nextInt(characters.length)];
    }
    return id;
  }

  static TextDirection getDirection(bool isEnglish) {
    return isEnglish ? TextDirection.ltr : TextDirection.rtl;
  }

  static bool isAccountAcceptable() {
    String accountType = CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT_TYPE);
    String accountCached = CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT);

    if(accountType == AccountTypeEnum.lawyers.name) {
      LawyerModel lawyerModel = LawyerModel.fromJson(json.decode(accountCached));
      return lawyerModel.accountStatus == AccountStatus.acceptable;
    }
    else if(accountType == AccountTypeEnum.publicRelations.name) {
      PublicRelationModel publicRelationModel = PublicRelationModel.fromJson(json.decode(accountCached));
      return publicRelationModel.accountStatus == AccountStatus.acceptable;
    }
    else {
      LegalAccountantModel legalAccountantModel = LegalAccountantModel.fromJson(json.decode(accountCached));
      return legalAccountantModel.accountStatus == AccountStatus.acceptable;
    }
  }

  static dynamic getTargetModel() {
    String accountType = CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT_TYPE);
    String accountCached = CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT);

    if(accountType == AccountTypeEnum.lawyers.name) {
      return LawyerModel.fromJson(json.decode(accountCached));
    }
    else if(accountType == AccountTypeEnum.publicRelations.name) {
      return PublicRelationModel.fromJson(json.decode(accountCached));
    }
    else {
      return LegalAccountantModel.fromJson(json.decode(accountCached));
    }
  }

  static Future<void> openUrl(String url) async {
    try {
      Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {await launchUrl(uri, mode: LaunchMode.externalApplication);}
      else {throw 'can\'t launch url';}
    }
    catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<bool> checkConnectivityState() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.wifi) {return true;}
    else if (result == ConnectivityResult.mobile) {return true;}
    else {return false;}
  }

  static Future<Position?> checkPermissionAndGetCurrentPosition(BuildContext context) async {
    Position? position;

    await Geolocator.isLocationServiceEnabled().then((isLocationServiceEnabled) async {
      if(isLocationServiceEnabled) {
        await Geolocator.checkPermission().then((locationPermission) async {
          if(locationPermission == LocationPermission.denied) {
            await Geolocator.requestPermission().then((locationPermission) async {
              if(locationPermission == LocationPermission.denied) {
                Dialogs.showPermissionDialog(
                  context: context,
                  title: StringsManager.permission,
                  message: StringsManager.youShouldUpdateTheLocationPermissionInTheAppSettings,
                );
              }
              if(locationPermission == LocationPermission.deniedForever) {
                Dialogs.showPermissionDialog(
                  context: context,
                  title: StringsManager.permission,
                  message: StringsManager.youShouldUpdateTheLocationPermissionInTheAppSettings,
                );
              }
              if(locationPermission == LocationPermission.whileInUse || locationPermission == LocationPermission.always) {
                position = await Geolocator.getCurrentPosition().then((value) => value);
              }
            });
          }
          else if(locationPermission == LocationPermission.deniedForever) {
            Dialogs.showPermissionDialog(
              context: context,
              title: StringsManager.location,
              message: StringsManager.youShouldUpdateTheLocationPermissionInTheAppSettings,
            );
          }
          else if(locationPermission == LocationPermission.whileInUse || locationPermission == LocationPermission.always) {
            position = await Geolocator.getCurrentPosition().then((value) => value);
          }
        });
      }
      else {
        Dialogs.showPermissionDialog(
          context: context,
          title: StringsManager.location,
          message: StringsManager.locationServicesAreDisabledTurnItOnToContinue,
        );
      }
    });

    return position;
  }

  static String getTopic() {
    String accountTypeCached = CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT_TYPE);
    String accountCached = CacheHelper.getData(key: PREFERENCES_KEY_ACCOUNT);
    if(accountTypeCached == AccountTypeEnum.lawyers.name) {
      LawyerModel lawyerModel = LawyerModel.fromJson(json.decode(accountCached));
      return '${lawyerModel.lawyerId}${ConstantsManager.fahemBusinessLawyersKeyword}';
    }
    else if(accountTypeCached == AccountTypeEnum.publicRelations.name) {
      PublicRelationModel publicRelationModel = PublicRelationModel.fromJson(json.decode(accountCached));
      return '${publicRelationModel.publicRelationId}${ConstantsManager.fahemBusinessPublicRelationsKeyword}';
    }
    else if(accountTypeCached == AccountTypeEnum.legalAccountants.name) {
      LegalAccountantModel legalAccountantModel = LegalAccountantModel.fromJson(json.decode(accountCached));
      return '${legalAccountantModel.legalAccountantId}${ConstantsManager.fahemBusinessLegalAccountantsKeyword}';
    }
    return '';
  }

  static void logout(BuildContext context) {
    NotificationService.unsubscribeFromTopic(FirebaseConstants.fahemBusinessTopic);
    NotificationService.unsubscribeFromTopic(getTopic());
    NotificationService.unsubscribeFromTopic(FirebaseConstants.instantConsultationsTopic);
    CacheHelper.removeData(key: PREFERENCES_KEY_IS_LOGGED);
    CacheHelper.removeData(key: PREFERENCES_KEY_ACCOUNT_TYPE);
    CacheHelper.removeData(key: PREFERENCES_KEY_ACCOUNT);
    Navigator.pushNamedAndRemoveUntil(context, Routes.loginRoute, (route) => false);
  }
}
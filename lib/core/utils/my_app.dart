import 'package:fahem_business/core/resources/routes_manager.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/resources/theme_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/extensions.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/core/utils/my_behavior.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  const MyApp._internal(); // Named Constructor

  static const MyApp _instance = MyApp._internal(); // Singleton

  factory MyApp() => _instance; // Factory

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: Methods.getText(StringsManager.appName, provider.isEnglish).toTitleCase(),
          theme: getApplicationThemeLight(),
          themeMode: ThemeMode.light,
          onGenerateRoute: (routeSettings) => onGenerateRoute(routeSettings),
          builder: (context, child) {
            return ScrollConfiguration(
              behavior: MyBehavior(),
              child: child!,
            );
          },
        );
      }
    );
  }
}
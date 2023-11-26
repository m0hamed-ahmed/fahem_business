import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {

  AppProvider({required isEnglish}) {
    _isEnglish = isEnglish;
  }

  bool _isEnglish = false;
  bool get isEnglish => _isEnglish;
  changeIsEnglish(bool isEnglish) {_isEnglish = isEnglish; notifyListeners();}
}
import 'package:fahem_business/core/resources/constants_manager.dart';

extension StringExtension on String {

  String toCapitalized() {
    return length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : ConstantsManager.empty;
  }

  String toTitleCase() {
    return replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
  }
}
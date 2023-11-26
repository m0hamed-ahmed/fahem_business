import 'package:fahem_business/core/utils/enums.dart';

class FahemServiceModel {
  final FahemServiceType fahemServiceType;
  final String nameAr;
  final String nameEn;

  FahemServiceModel({
    required this.fahemServiceType,
    required this.nameAr,
    required this.nameEn,
  });

  factory FahemServiceModel.fromJson(Map<String, dynamic> json) {
    return FahemServiceModel(
      fahemServiceType: json['fahemServiceType'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
    );
  }

  static Map<String, dynamic> toMap(FahemServiceModel fahemServiceModel) {
    return {
      'fahemServiceType': fahemServiceModel.fahemServiceType,
      'nameAr': fahemServiceModel.nameAr,
      'nameEn': fahemServiceModel.nameEn,
    };
  }

  static List<FahemServiceModel> fromJsonList (List<dynamic> list) => list.map<FahemServiceModel>((item) => FahemServiceModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<FahemServiceModel> list) => list.map<Map<String, dynamic>>((item) => FahemServiceModel.toMap(item)).toList();
}
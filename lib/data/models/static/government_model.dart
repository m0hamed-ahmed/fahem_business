class GovernmentModel {
  final String nameAr;
  final String nameEn;

  GovernmentModel({
    required this.nameAr,
    required this.nameEn,
  });

  factory GovernmentModel.fromJson(Map<String, dynamic> json) {
    return GovernmentModel(
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
    );
  }

  static Map<String, dynamic> toMap(GovernmentModel governmentModel) {
    return {
      'nameAr': governmentModel.nameAr,
      'nameEn': governmentModel.nameEn,
    };
  }

  static List<GovernmentModel> fromJsonList (List<dynamic> list) => list.map<GovernmentModel>((item) => GovernmentModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<GovernmentModel> list) => list.map<Map<String, dynamic>>((item) => GovernmentModel.toMap(item)).toList();
}
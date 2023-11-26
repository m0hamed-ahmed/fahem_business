class AccountTypeModel {
  final String accountType;
  final String image;
  final String nameAr;
  final String nameEn;
  final String route;

  const AccountTypeModel({
    required this.accountType,
    required this.image,
    required this.nameAr,
    required this.nameEn,
    required this.route,
  });

  factory AccountTypeModel.fromJson(Map<String, dynamic> json) {
    return AccountTypeModel(
      accountType: json['accountType'],
      image: json['image'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
      route: json['route'],
    );
  }

  static Map<String, dynamic> toMap(AccountTypeModel accountTypeModel) {
    return {
      'accountType': accountTypeModel.accountType,
      'image': accountTypeModel.image,
      'nameAr': accountTypeModel.nameAr,
      'nameEn': accountTypeModel.nameEn,
      'route': accountTypeModel.route,
    };
  }

  static List<AccountTypeModel> fromJsonList (List<dynamic> list) => list.map<AccountTypeModel>((item) => AccountTypeModel.fromJson(item)).toList();

  static List<Map<String, dynamic>> toMapList(List<AccountTypeModel> list) => list.map<Map<String, dynamic>>((item) => AccountTypeModel.toMap(item)).toList();
}
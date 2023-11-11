class LoadModel {
  final String? id;
  final String title;
  final GlobalType equipmentType;
  final GlobalType presentationType;
  final double weight;
  final String userId;
  final String? userName;
  final DateTime? createdAt;
  final DateTime loadingDate;
  final DateTime unloadingDate;
  final String? description;
  final GlobalType feeType;
  final double fee;
  final GlobalType transactionType;
  final int paymentDelay;

  LoadModel({
    this.id,
    required this.title,
    required this.equipmentType,
    required this.presentationType,
    required this.weight,
    required this.userId,
    this.userName,
    this.createdAt,
    required this.loadingDate,
    required this.unloadingDate,
    this.description,
    required this.feeType,
    required this.fee,
    required this.transactionType,
    required this.paymentDelay,
  });

  static List<LoadModel> getLoads(List<Map<String, dynamic>> loads) {
    return List<LoadModel>.from(loads.map((x) => LoadModel.fromJson(x)));
  }

  factory LoadModel.fromJson(Map<String, dynamic> json) => LoadModel(
        id: json['id'],
        title: json['title'],
        equipmentType: GlobalType.fromJson(json['equipment_type']),
        presentationType: GlobalType.fromJson(json['load_presentation_type']),
        weight: json['weight'].toDouble(),
        userId: json['user']['id'],
        userName: json['user']['name'],
        createdAt: DateTime.parse(json['created_at']),
        loadingDate: DateTime.parse(json['loading_date']),
        unloadingDate: DateTime.parse(json['unloading_date']),
        description: json['description'],
        feeType: GlobalType.fromJson(json['fee_type']),
        fee: double.parse(json['fee']),
        transactionType: GlobalType.fromJson(json['payment_type']),
        paymentDelay: json['payment_delay'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'equipment_type_id': equipmentType.id,
        'load_presentation_type_id': presentationType.id,
        'weight': weight,
        'user_id': userId,
        'loading_date': loadingDate.toIso8601String(),
        'unloading_date': unloadingDate.toIso8601String(),
        'description': description,
        'fee_type_id': feeType.id,
        'fee': fee,
        'payment_type_id': transactionType.id,
        'payment_delay': paymentDelay,
      };
}

class GlobalType {
  final String id;
  final String name;
  final String type;

  GlobalType({
    required this.id,
    required this.name,
    required this.type,
  });

  factory GlobalType.fromJson(Map<String, dynamic> json) => GlobalType(
        id: json['id'],
        name: json['name'],
        type: json['type'],
      );
}

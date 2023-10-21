class LoadModel {
  final String id;
  final String title;
  final GlobalType equipmentType;
  final GlobalType presentationType;
  final double weight;
  final String userId;
  final String userName;
  final DateTime createdAt;
  final DateTime loadingDate;
  final DateTime unloadingDate;
  final String description;

  LoadModel({
    required this.id,
    required this.title,
    required this.equipmentType,
    required this.presentationType,
    required this.weight,
    required this.userId,
    required this.userName,
    required this.createdAt,
    required this.loadingDate,
    required this.unloadingDate,
    required this.description,
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
      );
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

import 'package:cargaapp_mobile/backend/models/load.dart';

class Equipment {
  final String id;
  final String licensePlate;
  final int capacity;
  final GlobalType type;
  final DateTime createdAt;
  final String userId;

  Equipment({
    required this.id,
    required this.licensePlate,
    required this.capacity,
    required this.type,
    required this.createdAt,
    required this.userId,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'],
      licensePlate: json['license_plate'],
      capacity: json['capacity'].round(),
      type: GlobalType.fromJson(json['type']),
      createdAt: DateTime.parse(json['created_at']),
      userId: json['user_id'],
    );
  }

  static List<Equipment> getEquipments(List<dynamic> equipments) {
    equipments =
        equipments.where((equipment) => equipment['type'] != null).toList();
    return List<Equipment>.from(equipments.map((x) => Equipment.fromJson(x)));
  }
}

import 'package:cargaapp_mobile/backend/models/equipment.dart';
import 'package:cargaapp_mobile/backend/models/load.dart';
import 'package:cargaapp_mobile/backend/models/location.dart';
import 'package:cargaapp_mobile/backend/services/supabase_config.dart';
import 'package:flutter/material.dart';

class EquipmentService extends ChangeNotifier {
  final supabase = SupabaseConfig().supabase;

  List<Equipment> _equipments = [];

  List<GlobalType> _equipmentTypes = [];

  Map<String, dynamic> _filters = {};

  Map<String, dynamic> get filters => _filters;

  set filters(Map<String, dynamic> value) {
    _filters = value;
    notifyListeners();
  }

  List<Equipment> get equipments => _equipments;

  set equipments(List<Equipment> value) {
    _equipments = value;
    notifyListeners();
  }

  validateFilter() {
    _filters = Map.from(_filters)
      ..removeWhere((key, value) => value == null || value == 0.0);
    notifyListeners();
    // setState(() {});
  }

  Future<List<Equipment>> getUserEquipments(String userId) async {
    final response = await supabase
        .from('equipments')
        .select(
            'id, user_id, capacity, license_plate, created_at, type:equipment_type(id, name, type))')
        .eq('user_id', userId)
        .order('created_at');

    _equipments = await Equipment.getEquipments(response);

    return _equipments;
  }

  Future<bool> getAllEquipments() async {
    final response = await supabase
        .from('equipments')
        .select(
            'id, user_id, capacity, license_plate, created_at, type:equipment_type(id, name, type))')
        .order('created_at');

    _equipments = await Equipment.getEquipments(response);

    notifyListeners();

    return true;
  }

  Future<bool> createEquipment(Map<String, dynamic> equipmentMap) async {
    final response = await supabase.from('equipments').upsert(equipmentMap);

    return true;
  }

  Future<bool> deleteEquipment(List<String> selectedId) async {
    final response =
        await supabase.from('equipments').delete().in_('id', selectedId);

    return true;
  }

  Future<List<GlobalType>> getEquipmentTypes() async {
    final response = await supabase
        .from('global_types')
        .select('*')
        .eq('type', 'equipment_type');

    print(response.toString());

    _equipmentTypes = await List<GlobalType>.from(
      response.map((x) => GlobalType.fromJson(x)),
    );

    return _equipmentTypes;
  }

  Future<bool?> filterEquipments() async {
    var response;
    String? equipmentTypeId = _filters['vehicle_type'];
    double? capacity = _filters['capacity'];

    if (equipmentTypeId == null && capacity == null) return null;

    if (equipmentTypeId != null && capacity != null) {
      response = await supabase
          .from('equipments')
          .select(
              'id, user_id, capacity, license_plate, created_at, type:equipment_type(id, name, type)')
          .eq('type.id', equipmentTypeId)
          .gt('capacity', capacity)
          .order('created_at');
    } else if (equipmentTypeId != null) {
      response = await supabase
          .from('equipments')
          .select(
              'id, user_id, capacity, license_plate, created_at, type:equipment_type(id, name, type)')
          .eq('type.id', equipmentTypeId)
          .order('created_at');
    } else if (capacity != null) {
      response = await supabase
          .from('equipments')
          .select(
              'id, user_id, capacity, license_plate, created_at, type:equipment_type(id, name, type)')
          .gt('capacity', capacity)
          .order('created_at');
    }

    _equipments = await Equipment.getEquipments(response);
    notifyListeners();

    return true;
  }

  Future<List<Location>> search(String term) async {
    final query = term.replaceAll(' ', "' | '");

    final List<Map<String, dynamic>> response = await supabase
        .from('arg')
        .select('*')
        .textSearch('city', "'$query'")
        .select();

    final locations = await Location.getLocations(response);

    return locations;
  }
}

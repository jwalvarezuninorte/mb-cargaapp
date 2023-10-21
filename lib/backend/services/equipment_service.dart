import 'package:cargaapp_mobile/backend/models/equipment.dart';
import 'package:cargaapp_mobile/backend/models/load.dart';
import 'package:cargaapp_mobile/backend/models/location.dart';
import 'package:cargaapp_mobile/backend/services/supabase_config.dart';
import 'package:flutter/material.dart';

class EquipmentService extends ChangeNotifier {
  final supabase = SupabaseConfig().supabase;

  List<Equipment> _equipments = [];

  List<GlobalType> _equipmentTypes = [];

  List<Equipment> get equipments => _equipments;

  set equipments(List<Equipment> value) {
    _equipments = value;
    notifyListeners();
  }

  Future<List<Equipment>> getEquipments(String userId) async {
    final response = await supabase
        .from('equipments')
        .select(
            'id, capacity, license_plate, created_at, type:equipment_type(id, name, type))')
        .eq('user_id', userId)
        .order('created_at');

    print(response.toString());

    _equipments = await Equipment.getEquipments(response);

    return _equipments;
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

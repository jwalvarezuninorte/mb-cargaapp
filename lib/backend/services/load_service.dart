import 'package:cargaapp_mobile/backend/services/supabase_config.dart';
import 'package:flutter/material.dart';

import '../models/load.dart';

class LoadService extends ChangeNotifier {
  final supabase = SupabaseConfig().supabase;
  List<LoadModel>? _loads;

  List<LoadModel>? get loads => _loads;

  set loads(List<LoadModel>? value) {
    _loads = value;
    // notifyListeners();
  }

// return loads, and also the params for global types (id and name)
  Future<List<LoadModel>?> getLoads(Map<String, dynamic> filters) async {
    print('Getting loads with filter :: $filters');
    await Future.delayed(Duration(seconds: 2));
    final List<
        Map<String,
            dynamic>> response = await supabase.from('loads').select(
        '*, load_presentation_type:load_presentation_type_id(id, name, type)'
        ',equipment_type:equipment_type_id(id, name, type)'
        ',user:user_id(id, name, email, phone_number)');

    // filter response where 'location' is equal to filter['location'], 'distance' is less or equal to filter['distance'] and 'vehicle_type' is equal to filter['vehicle_type']
    final filteredResponse = response
        .where((element) =>
            // element['location'] == filters['location'] &&
            element['weight'] <= (filters['distance'] ?? 9999999) &&
            (filters['vehicle_type'] != null
                ? element['equipment_type']['id'] == filters['vehicle_type']
                : element['equipment_type']['id'] != filters['vehicle_type']))
        .toList();

    _loads = LoadModel.getLoads(filteredResponse);
    // notifyListeners();

    return _loads;
  }
}

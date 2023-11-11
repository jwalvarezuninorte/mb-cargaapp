import 'package:cargaapp_mobile/backend/services/supabase_config.dart';
import 'package:cargaapp_mobile/screens/miscellany/full_screen_process_status.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../models/load.dart';

class LoadService extends ChangeNotifier {
  final supabase = SupabaseConfig().supabase;
  List<LoadModel>? _loads;

  LoadModel? _currentLoad;

  LoadModel? get currentLoad => _currentLoad;

  set currentLoad(LoadModel? value) {
    _currentLoad = value;
    notifyListeners();
  }

  // List<GlobalType> _presentationTypes = [];
  // List<GlobalType> _equipmentTypes = [];
  // List<GlobalType> _feeTypes = [];
  // List<GlobalType> _transactionTypes = [];

  // Form fields
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // late LoadService _loadService;

  List<GlobalType> presentationTypes = [];
  List<GlobalType> equipmentTypes = [];
  List<GlobalType> feeTypes = [];
  List<GlobalType> transactionTypes = [];

  final loadTitle = TextEditingController();
  GlobalType? _loadPresentationType;

  GlobalType? get loadPresentationType => _loadPresentationType;

  set loadPresentationType(GlobalType? value) {
    _loadPresentationType = value;
    notifyListeners();
  }

  final loadWeight = TextEditingController();
  GlobalType? _loadEquipmentType;

  DateRangePickerController _pickerController = DateRangePickerController();

  DateRangePickerController get pickerController => _pickerController;

  set pickerController(DateRangePickerController value) {
    _pickerController = value;
  }

  DateTime _loadingDate = DateTime.now();
  DateTime _unloadingDate = DateTime.now().add(const Duration(days: 3));

  DateTime get loadingDate => _loadingDate;

  set loadingDate(DateTime value) {
    _loadingDate = value;
  }

  GlobalType? _loadFeeType;
  final loadFee = TextEditingController();
  GlobalType? _loadTransactionType;
  final loadPaymentDelay = TextEditingController();
  final loadDescription = TextEditingController();

  // end form fields

  List<LoadModel>? get loads => _loads;

  GlobalType? get loadEquipmentType => _loadEquipmentType;

  set loadEquipmentType(GlobalType? value) {
    _loadEquipmentType = value;
    notifyListeners();
  }

  GlobalType? get loadFeeType => _loadFeeType;

  set loadFeeType(GlobalType? value) {
    _loadFeeType = value;
    notifyListeners();
  }

  GlobalType? get loadTransactionType => _loadTransactionType;

  set loadTransactionType(GlobalType? value) {
    _loadTransactionType = value;
    notifyListeners();
  }

  set loads(List<LoadModel>? value) {
    _loads = value;
    // notifyListeners();
  }

// return loads, and also the params for global types (id and name)
  Future<List<LoadModel>?> getLoads(Map<String, dynamic> filters) async {
    print('Getting loads with filter :: $filters');
    // await Future.delayed(Duration(seconds: 2));
    final List<
        Map<String,
            dynamic>> response = await supabase.from('loads').select(
        '*, load_presentation_type:load_presentation_type_id(id, name, type)'
        ',fee_type:fee_type_id(id, name, type)'
        ',payment_type:payment_type_id(id, name, type)'
        ',equipment_type:equipment_type_id(id, name, type)'
        ',user:user_id(id, name, email, phone_number)');

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

  Future<bool> createLoad(LoadModel load) async {
    await supabase.from('loads').insert(load.toJson());

    return true;
  }

  Future<bool> updateLoad(LoadModel load) async {
    await supabase
        .from('loads')
        .update({"id": load.id, ...load.toJson()})
        .eq('id', load.id)
        .single();

    _currentLoad = await _getLoadById(load.id!);

    _pickerController.selectedRange = PickerDateRange(
      _currentLoad!.loadingDate,
      _currentLoad!.unloadingDate,
    );

    notifyListeners();

    return true;
  }

  Future<LoadModel> _getLoadById(String id) async {
    final response = await supabase
        .from('loads')
        .select('*'
            ',load_presentation_type:load_presentation_type_id(id, name, type)'
            ',equipment_type:equipment_type_id(id, name, type)'
            ',fee_type:fee_type_id(id, name, type)'
            ',payment_type:payment_type_id(id, name, type)'
            ',user:user_id(id, name, email, phone_number)')
        .eq('id', id)
        .single();

    return LoadModel.fromJson(response);
  }

  Future<bool> deleteLoadById(String id) async {
    await supabase.from('loads').delete().eq('id', id);

    return true;
  }

  Future<List<LoadModel>?> getUserLoads(String userId) async {
    final response = await supabase
        .from('loads')
        .select('*'
            ',load_presentation_type:load_presentation_type_id(id, name, type)'
            ',equipment_type:equipment_type_id(id, name, type)'
            ',fee_type:fee_type_id(id, name, type)'
            ',payment_type:payment_type_id(id, name, type)'
            ',user:user_id(id, name, email, phone_number)')
        .eq('user_id', userId)
        .order('created_at');

    _loads = response.map<LoadModel>((e) => LoadModel.fromJson(e)).toList();

    return _loads;
  }

  Future<bool> handleEditCreateLoadForm(LoadModel? load) async {
    final response = await getAllGlobalTypes();
    if (!response) return false;

    if (load != null) {
      loadTitle.text = load.title;
      loadPresentationType = load.presentationType;
      loadWeight.text = load.weight.toString();
      loadEquipmentType = load.equipmentType;
      loadingDate = load.loadingDate;
      unloadingDate = load.unloadingDate;
      loadDescription.text = load.description ?? '';
      loadFeeType = load.feeType;
      loadFee.text = load.fee.toString();
      loadTransactionType = load.transactionType;
      loadPaymentDelay.text = load.paymentDelay.toString();
    }

    notifyListeners();

    return true;
  }

  Future<bool> getAllGlobalTypes() async {
    final response = await supabase.from('global_types').select('*');

    final allTypes = await List<GlobalType>.from(
      response.map((x) => GlobalType.fromJson(x)),
    );

    presentationTypes = allTypes
        .where((element) => element.type == 'load_presentation_type')
        .toList();
    equipmentTypes =
        allTypes.where((element) => element.type == 'equipment_type').toList();
    feeTypes = allTypes.where((element) => element.type == 'fee_type').toList();
    transactionTypes =
        allTypes.where((element) => element.type == 'payment_type').toList();

    // notifyListeners();
    // return true if the process was successful
    return true;
  }

  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    // setState(() {
    if (args.value is PickerDateRange) {
      loadingDate = args.value.startDate;
      unloadingDate = args.value.endDate ?? args.value.startDate;
    }
    // });
    notifyListeners();
  }

  bool globalValidationOk() {
    formKey.currentState!.validate();
    if (loadPresentationType == null) return false;
    if (loadEquipmentType == null) return false;
    if (loadingDate == null) return false;
    if (unloadingDate == null) return false;
    if (loadFeeType == null) return false;
    if (loadTransactionType == null) return false;

    return true;
  }

  // Return true if we need to update a list, making a get request
  Future<bool> handleOnPressed(
    BuildContext context,
    bool isSubscriptionActive,
    LoadModel load,
  ) async {
    if (isSubscriptionActive) {
      // final loadService = Provider.of<LoadService>(context, listen: false);
      currentLoad = load;
      return await Navigator.of(context).pushNamed('/offer_detail').then(
            (value) => true,
          );
    }

    Navigator.of(context).pushNamed(
      '/full_screen_status',
      arguments: ScreenArguments(
        'Necesitas una membresía',
        'Para llevar a cabo esta acción, es\nnecesario que debas subscribirte.',
        Icons.lock,
        false,
        () => Navigator.of(context).pushNamed('/membership_onboarding'),
        'Comprar membresía',
        'Regresar a la app',
        () => Navigator.of(context).pop(),
      ),
    );

    return false;
  }

  DateTime get unloadingDate => _unloadingDate;

  set unloadingDate(DateTime value) {
    _unloadingDate = value;
    notifyListeners();
  }
}

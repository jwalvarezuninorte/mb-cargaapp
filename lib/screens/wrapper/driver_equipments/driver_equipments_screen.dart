import 'package:animate_do/animate_do.dart';
import 'package:cargaapp_mobile/backend/models/equipment.dart';
import 'package:cargaapp_mobile/backend/models/load.dart';
import 'package:cargaapp_mobile/backend/services/auth_service.dart';
import 'package:cargaapp_mobile/backend/services/equipment_service.dart';
import 'package:cargaapp_mobile/screens/miscellany/full_screen_process_status.dart';
import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:cargaapp_mobile/utils/date.dart';
import 'package:cargaapp_mobile/widgets/common/bottomSheet.helper.dart';
import 'package:cargaapp_mobile/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class DriverEquipmentsScreen extends StatefulWidget {
  const DriverEquipmentsScreen({super.key});

  @override
  State<DriverEquipmentsScreen> createState() => _DriverEquipmentsScreenState();
}

class _DriverEquipmentsScreenState extends State<DriverEquipmentsScreen> {
  late EquipmentService _equipmentService;
  Map<String, dynamic> jsonNewEquipment = {
    'license_plate': '',
    'capacity': 0.0,
    'equipment_type_id': '',
  };

  onJsonNewEquipmentChanged(String key, dynamic value) async {
    print('$key :: $value');
    jsonNewEquipment[key] = value;
  }

  List<String> _selectedEquipments = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _equipmentService = Provider.of<EquipmentService>(
        context,
        listen: false,
      );
    });
  }

  @override
  void dispose() {
    // print('equipments :: ${_equipmentService.equipments.length}');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _equipmentService.equipments = [];
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _equipmentService = Provider.of<EquipmentService>(context);
    final _authService = Provider.of<AuthService>(context);
    final bool isSubscriptionActive = _authService.user!.subscription.isActive;

    final String _userId = _authService.user?.id as String;

    return GestureDetector(
      onTap: isSubscriptionActive
          ? null
          : () => Navigator.of(context).pushNamed(
                '/full_screen_status',
                arguments: ScreenArguments(
                  'Necesitas una membresía',
                  'Para poder filtrar cargas, es\nnecesario que debas subscribirte.',
                  Icons.lock,
                  false,
                  () =>
                      Navigator.of(context).pushNamed('/membership_onboarding'),
                  'Comprar membresía',
                  'Regresar a la app',
                  () => Navigator.of(context).pop(),
                ),
              ),
      child: AbsorbPointer(
        absorbing: !isSubscriptionActive,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.base,
            title: _selectedEquipments.isNotEmpty
                ? FadeInUp(
                    duration: Duration(milliseconds: 200),
                    child: TextButton.icon(
                      label: Text('Cancelar'),
                      onPressed: () {
                        _selectedEquipments.clear();
                        setState(() {});
                      },
                      icon: Icon(Icons.close_rounded),
                    ),
                  )
                : FadeInDown(
                    duration: Duration(milliseconds: 100),
                    child: Text("Mis equipos"),
                  ),
            actions: [
              _selectedEquipments.isNotEmpty
                  ? TextButton.icon(
                      label: Text(
                        'Eliminar (${_selectedEquipments.length})',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      onPressed: () async {
                        await _equipmentService
                            .deleteEquipment(_selectedEquipments);
                        _equipmentService.equipments = [];
                        _selectedEquipments.clear();
                        setState(() {});
                      },
                      icon: Icon(
                        Iconsax.trash,
                        color: Colors.redAccent,
                      ),
                    )
                  : TextButton.icon(
                      label: Text('Agregar'),
                      onPressed: () => showBottomSheetAddEquipment(
                        context: context,
                        onChange: (k, v) => onJsonNewEquipmentChanged(k, v),
                        json: jsonNewEquipment,
                      ).then((value) {
                        _equipmentService.equipments = [];
                        setState(() {});
                      }),
                      icon: Icon(Iconsax.add_circle),
                    ),
            ],
          ),
          body: FutureBuilder(
            future: _equipmentService.equipments.isEmpty
                ? _equipmentService.getUserEquipments(_userId)
                : null,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasData) {
                List<Equipment> _equipments = snapshot.data ?? [];
                if (_equipments.isEmpty)
                  return EmptyContent(
                    icon: Iconsax.info_circle,
                    message: 'No tienes vehiculos guardados',
                    onPressed: () {
                      //   TODO: implement onPressed
                    },
                    buttonText: 'Agregar tu primer vehículo',
                  );

                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: AppTheme.padding / 2),
                      ...List.generate(_equipments.length, (index) {
                        final _equipment = _equipments[index];

                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppTheme.padding / 2,
                            vertical: AppTheme.padding / 4,
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(
                              AppTheme.defaultRadius,
                            ),
                            onTap: () {
                              if (_selectedEquipments.isNotEmpty) {
                                if (_selectedEquipments
                                    .contains(_equipment.id)) {
                                  _selectedEquipments.removeWhere(
                                    (id) => _equipment.id == id,
                                  );
                                } else {
                                  _selectedEquipments.add(_equipment.id);
                                }
                                setState(() {});
                              }
                            },
                            onLongPress: () {
                              if (_selectedEquipments.contains(_equipment.id))
                                return;
                              _selectedEquipments.add(_equipment.id);
                              setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.all(AppTheme.padding),
                              decoration: BoxDecoration(
                                color:
                                    _selectedEquipments.contains(_equipment.id)
                                        ? AppTheme.primary.withAlpha(20)
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(
                                  AppTheme.defaultRadius,
                                ),
                                border: Border.all(
                                  color: _selectedEquipments
                                          .contains(_equipment.id)
                                      ? AppTheme.primary.withAlpha(100)
                                      : AppTheme.dark.withOpacity(0.1),
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2,
                                        color:
                                            AppTheme.primary.withOpacity(0.3),
                                        strokeAlign:
                                            BorderSide.strokeAlignOutside,
                                      ),
                                      color: AppTheme.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Icon(Iconsax.truck, size: 30),
                                    ),
                                  ),
                                  SizedBox(width: AppTheme.padding),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${_equipment.type.name} : ${_equipment.licensePlate}",
                                        style: AppTheme
                                            .lightTheme.textTheme.bodyMedium!
                                            .copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: AppTheme.padding / 4),
                                      Text(
                                        _equipment.createdAt.readable(),
                                        style: AppTheme.lightTheme.textTheme
                                            .headlineMedium!
                                            .copyWith(
                                          color: AppTheme.dark.withOpacity(0.4),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Chip(
                                    padding: EdgeInsets.symmetric(
                                      vertical: AppTheme.padding / 2,
                                      horizontal: AppTheme.padding / 2,
                                    ),
                                    backgroundColor:
                                        AppTheme.base.withOpacity(0.8),
                                    label: Text(
                                      '${_equipment.capacity} Kg',
                                      style: AppTheme
                                          .lightTheme.textTheme.headlineMedium!
                                          .copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: AppTheme.padding),
                    ],
                  ),
                );
              }

              return EmptyContent(
                icon: Iconsax.info_circle,
                message: 'Hubo un error al cargar los vehículos',
                onPressed: () {
                  //   TODO: implement onPressed
                },
                buttonText: 'Volver a cargar',
              );
              ;
            },
          ),
        ),
      ),
    );
  }
}

Future<void> showBottomSheetAddEquipment({
  required BuildContext context,
  required Function(String key, dynamic value) onChange,
  required Map<String, dynamic> json,
}) async {
  final TextEditingController _plateLicenceController = TextEditingController();
  bool btnDisabled = true;

  final _equipmentService = Provider.of<EquipmentService>(
    context,
    listen: false,
  );

  final _authService = Provider.of<AuthService>(context, listen: false);

  final String _userId = _authService.user!.id;

  List<GlobalType> _equipmentTypes =
      await _equipmentService.getEquipmentTypes();

  return showCustomBottomSheet(context: context, content: [
    StatefulBuilder(
      builder: (context, StateSetter setState) {
        void verifyJsonNewEquipment() async {
          if (json['license_plate'].isNotEmpty &&
              json['capacity'] > 0 &&
              json['equipment_type_id'].isNotEmpty) {
            btnDisabled = false;
          } else {
            btnDisabled = true;
          }
          setState(() {});
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SectionHeader(title: "Registrar nuevo equipo", hasPadding: false),
            SizedBox(height: AppTheme.padding / 2),
            TextFormField(
              style: TextStyle(fontSize: 16),
              autofocus: true,
              controller: _plateLicenceController,
              decoration: InputDecoration(
                hintText: 'Placa Licencia',
                prefixIcon: Icon(Iconsax.truck),
              ),
              onChanged: (value) {
                print('value :: $value');
                onChange('license_plate', value);
                verifyJsonNewEquipment();
              },
            ),
            SizedBox(height: AppTheme.padding),
            SectionHeader(title: "Tipo de equipo", hasPadding: false),
            SizedBox(height: AppTheme.padding / 2),
            // modify this::
            DropdownMenu(
              width: MediaQuery.of(context).size.width - AppTheme.padding * 2,
              hintText: 'Tipo de vehículo',
              onSelected: (GlobalType? value) {
                onChange('equipment_type_id', value!.id);
                verifyJsonNewEquipment();
              },
              dropdownMenuEntries:
                  _equipmentTypes.map<DropdownMenuEntry<GlobalType>>(
                (GlobalType value) {
                  return DropdownMenuEntry<GlobalType>(
                    value: value,
                    label: value.name,
                  );
                },
              ).toList(),
            ),
            SizedBox(height: AppTheme.padding),
            SectionHeader(
              title: "Capacidad máxima",
              hasPadding: false,
              actionLabel: '${json['capacity'].roundToDouble()} Kg',
              onMorePressed: () {},
            ),
            SizedBox(height: AppTheme.padding / 2),
            SliderTheme(
              data: SliderThemeData(
                trackShape: CustomTrackShape(),
                trackHeight: 10,
                overlayShape: SliderComponentShape.noOverlay,
                thumbShape: const RoundSliderThumbShape(
                  pressedElevation: 0,
                  enabledThumbRadius: 12,
                  elevation: 0,
                ),
              ),
              child: Slider(
                divisions: 100,
                max: 10000,
                min: 0,
                inactiveColor: AppTheme.dark.withOpacity(0.2),
                value: json['capacity'].roundToDouble(),
                onChanged: (value) {
                  print(value);
                  // _backgroundBlur = 50 * value;
                  // setState(() {});
                  onChange('capacity', value);
                  verifyJsonNewEquipment();
                },
              ),
            ),
            SizedBox(height: AppTheme.padding),
            ElevatedButton(
              onPressed: btnDisabled
                  ? null
                  : () async {
                      try {
                        await _equipmentService.createEquipment({
                          'capacity': json['capacity'],
                          'license_plate': json['license_plate'],
                          'equipment_type': json['equipment_type_id'],
                          'user_id': _userId,
                        });
                        Navigator.of(context).pop();
                        print('🟢 yeii');
                      } catch (e) {
                        print('🔴 error :: $e');
                      }
                    },
              child: Text("Crear vehiculo"),
            ),
            // Spacer(),
          ],
        );
      },
    ),
  ]);
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

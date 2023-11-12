import 'package:cargaapp_mobile/backend/models/equipment.dart';
import 'package:cargaapp_mobile/backend/models/load.dart';
import 'package:cargaapp_mobile/backend/models/user.dart';
import 'package:cargaapp_mobile/backend/services/auth_service.dart';
import 'package:cargaapp_mobile/backend/services/equipment_service.dart';
import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:cargaapp_mobile/utils/date.dart';
import 'package:cargaapp_mobile/widgets/common/bottomSheet.helper.dart';
import 'package:cargaapp_mobile/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LoadGiverOffersScreen extends StatefulWidget {
  const LoadGiverOffersScreen({super.key});

  @override
  State<LoadGiverOffersScreen> createState() => _LoadGiverOffersScreenState();
}

class _LoadGiverOffersScreenState extends State<LoadGiverOffersScreen> {
  late EquipmentService _equipmentService;

  // Map<String, dynamic> jsonNewEquipment = {
  //   'license_plate': '',
  //   'capacity': 0.0,
  //   'equipment_type_id': '',
  // };

  // onJsonNewEquipmentChanged(String key, dynamic value) async {
  //   print('$key :: $value');
  //   jsonNewEquipment[key] = value;
  // }

  List<String> _selectedEquipments = [];

  // Map<String, Object?> _filters = {};

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
    // final _authService = Provider.of<AuthService>(context);
    // final bool isSubscriptionActive = _authService.user!.subscription.isActive;

    // final String _userId = _authService.user?.id as String;

    Map<String, dynamic> filters = _equipmentService.filters;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.base,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Equipos'),
            SizedBox(height: AppTheme.padding / 4),
            Text(
              "Ofertas de equipos para hoy",
              style: AppTheme.lightTheme.textTheme.headlineMedium!.copyWith(
                color: AppTheme.dark.withOpacity(0.4),
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            label: filters.isEmpty
                ? Text('Filtrar')
                : Text('Filtros (${filters.length})'),
            onPressed: () async {
              await showBottomSheetFilterOptions(context).then((value) {
                if (value != null) {
                  _equipmentService.filters = value;
                  return _equipmentService.validateFilter();
                }
              });
              if (filters.isEmpty) {
                _equipmentService.getAllEquipments();
              }

              await _equipmentService.filterEquipments();
            },
            icon: Icon(Iconsax.filter),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _equipmentService.equipments.isEmpty
            ? _equipmentService.getAllEquipments()
            : null,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data == true) {
            final List<Equipment> _equipments = _equipmentService.equipments;

            if (_equipments.isEmpty)
              return EmptyContent(
                icon: Iconsax.info_circle,
                message: 'No hay publicaciones de equipos',
                onPressed: () {
                  //   TODO: implement onPressed
                },
                buttonText: 'Volver a cargar',
              );

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: AppTheme.padding / 2),
                  ...List.generate(_equipments.length, (index) {
                    final Equipment _equipment = _equipments[index];

                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppTheme.padding / 2,
                        vertical: AppTheme.padding / 4,
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(
                          AppTheme.defaultRadius,
                        ),
                        onTap: () async {
                          final _authService = AuthService();

                          final UserModel userDetail =
                              await _authService.getUserDetail(
                            id: _equipment.userId,
                          );

                          await showCustomBottomSheet(
                            context: context,
                            fullHeight: false,
                            crossAlignment: CrossAxisAlignment.center,
                            content: [
                              ProfileAvatar(
                                userName: userDetail.name,
                                imageUrl: userDetail.profilePhotoURL,
                              ),
                              SizedBox(height: AppTheme.padding / 2),
                              Text(
                                '${userDetail.name.split(" ")[0]} ${userDetail.name.split(" ")[1]}',
                                style: AppTheme.lightTheme.textTheme.titleLarge!
                                    .copyWith(fontSize: 24),
                              ),
                              SizedBox(height: AppTheme.padding / 2),
                              Text(
                                '${userDetail.email}',
                                style: AppTheme.lightTheme.textTheme.bodyMedium,
                              ),
                              Text(
                                'Telefono: ${userDetail.phoneNumber}',
                                style: AppTheme.lightTheme.textTheme.bodyMedium,
                              ),
                              SizedBox(height: AppTheme.padding),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.padding * 2,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      onPressed: () => launchUrlString(
                                        'sms:${userDetail.phoneNumber}',
                                      ),
                                      icon: Icon(
                                        Icons.chat_bubble_outline_rounded,
                                        color: Colors.white,
                                      ),
                                      style: IconButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        padding: const EdgeInsets.all(
                                          AppTheme.padding,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => launchUrlString(
                                        'mailto:${userDetail.email}',
                                      ),
                                      icon: Icon(
                                        Icons.mail_outline_rounded,
                                        color: Colors.white,
                                      ),
                                      style: IconButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        padding: const EdgeInsets.all(
                                          AppTheme.padding,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => launchUrlString(
                                        'tel://${userDetail.phoneNumber}',
                                      ),
                                      icon: Icon(Iconsax.call,
                                          color: Colors.white),
                                      style: IconButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        padding: const EdgeInsets.all(
                                          AppTheme.padding,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: AppTheme.padding * 1.4),
                            ],
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(AppTheme.padding),
                          decoration: BoxDecoration(
                            color: _selectedEquipments.contains(_equipment.id)
                                ? AppTheme.primary.withAlpha(20)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(
                              AppTheme.defaultRadius,
                            ),
                            border: Border.all(
                              color: _selectedEquipments.contains(_equipment.id)
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
                                    color: AppTheme.primary.withOpacity(0.3),
                                    strokeAlign: BorderSide.strokeAlignOutside,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    style: AppTheme
                                        .lightTheme.textTheme.headlineMedium!
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
                                backgroundColor: AppTheme.base.withOpacity(0.8),
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
        },
      ),
    );
  }
}

Future showBottomSheetFilterOptions(
  BuildContext context,
) async {
  final _equipmentService = Provider.of<EquipmentService>(
    context,
    listen: false,
  );

  List<GlobalType> _equipmentTypes =
      await _equipmentService.getEquipmentTypes();

  double _capacityInKg = _equipmentService.filters['capacity'] ?? 0.0;
  GlobalType? _selectedEquipment = _equipmentTypes
      .where(
          (element) => element.id == _equipmentService.filters['vehicle_type'])
      .firstOrNull;

  return showCustomBottomSheet(
    context: context,
    fullHeight: false,
    content: [
      StatefulBuilder(
        builder: (context, setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SectionHeader(
                title: "Capacidad mínima",
                hasPadding: false,
                actionLabel: _capacityInKg.round() == 0
                    ? 'Sin límites'
                    : '${_capacityInKg.round()} Kg',
                onMorePressed: () {},
              ),
              SizedBox(height: AppTheme.padding / 2),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.padding / 2,
                ),
                child: SliderTheme(
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
                    divisions: 1000,
                    max: 10000,
                    min: 0,
                    inactiveColor: AppTheme.dark.withOpacity(0.2),
                    value: _capacityInKg,
                    onChanged: (value) {
                      // print(value);
                      _capacityInKg = value;
                      setState(() {});
                    },
                  ),
                ),
              ),
              SizedBox(height: AppTheme.padding * 1.5),
              SectionHeader(
                title: "Tipo de vehivulo",
                hasPadding: false,
              ),
              SizedBox(height: AppTheme.padding / 2),
              DropdownMenu(
                width: MediaQuery.of(context).size.width - AppTheme.padding * 2,
                hintText: 'Tipo de vehículo',
                onSelected: (GlobalType? value) {
                  _selectedEquipment = value;
                  setState(() {});
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
                initialSelection: _selectedEquipment,
              ),
            ],
          );
        },
      ),
      SizedBox(height: AppTheme.padding * 2),
      ElevatedButton(
        onPressed: () => Navigator.of(context).pop(
          {
            'capacity': _capacityInKg,
            'vehicle_type': _selectedEquipment?.id,
            // 'capacity': _equipmentService.filters['capacity'],
            // 'vehicle_type': _equipmentService.filters['vehicle_type'],
          },
        ),
        child: Text("Filtrar"),
      ),
      SizedBox(height: AppTheme.padding),
      Center(
        child: TextButton.icon(
          style: TextButton.styleFrom(
            foregroundColor: Colors.redAccent,
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () async {
            _equipmentService.filters = {};
            _equipmentService.getAllEquipments();
            Navigator.of(context).pop();
          },
          icon: Icon(
            Iconsax.trash,
            color: Colors.redAccent,
          ),
          label: Text(
            'Limpiar filtro',
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
      ),
      SizedBox(height: AppTheme.padding * 2),
    ],
  );
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
                // print('value :: $value');
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
                  // print(value);
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

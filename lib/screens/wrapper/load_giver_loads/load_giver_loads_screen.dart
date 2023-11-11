import 'package:animate_do/animate_do.dart';
import 'package:cargaapp_mobile/backend/models/load.dart';
import 'package:cargaapp_mobile/backend/models/location.dart';
import 'package:cargaapp_mobile/backend/services/auth_service.dart';
import 'package:cargaapp_mobile/backend/services/equipment_service.dart';
import 'package:cargaapp_mobile/backend/services/load_service.dart';
import 'package:cargaapp_mobile/screens/miscellany/full_screen_process_status.dart';
import 'package:cargaapp_mobile/screens/wrapper/driver_equipments/driver_equipments_screen.dart';
import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:cargaapp_mobile/widgets/common/bottomSheet.helper.dart';
import 'package:cargaapp_mobile/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class LoadGiverLoadsScreen extends StatefulWidget {
  const LoadGiverLoadsScreen({super.key});

  @override
  State<LoadGiverLoadsScreen> createState() => _LoadGiverLoadsScreenState();
}

class _LoadGiverLoadsScreenState extends State<LoadGiverLoadsScreen> {
  // Future<void> _navigateToMembershipRequiredScreen(BuildContext context) async {
  //   final response = await Navigator.of(context).pushNamed(
  //     '/full_screen_status',
  //     arguments: ScreenArguments(
  //       'Necesitas una membresía',
  //       'Para poder filtrar cargas, es\nnecesario que debas subscribirte.',
  //       Icons.lock,
  //       false,
  //       () => Navigator.of(context).pushNamed('/membership_onboarding'),
  //       'Comprar membresía',
  //       'Regresar a la app',
  //       () => Navigator.of(context).pop(),
  //     ),
  //   );
  // }

  Map<String, Object?> _filters = {};

  validateFilter() {
    _filters = Map.from(_filters)
      ..removeWhere((key, value) => value == null || value == 0.0);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<AuthService>(
      context,
      listen: false,
    );

    final loadService = Provider.of<LoadService>(
      context,
      listen: false,
    );

    final bool isSubscriptionActive = _authService.user!.subscription.isActive;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mis Cargas'),
            SizedBox(height: AppTheme.padding / 4),
            Text(
              "Ofertas de carga para hoy",
              style: AppTheme.lightTheme.textTheme.headlineMedium!.copyWith(
                color: AppTheme.dark.withOpacity(0.4),
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            label: Text('Agregar'),
            onPressed: () async {
              loadService.currentLoad = null;

              await Navigator.of(context).pushNamed('/create_load').then(
                (value) {
                  if (value != null) return setState(() {});
                },
              );
            },
            icon: Icon(Iconsax.add_circle),
          ),
        ],
      ),
      body: HomeData(filters: _filters),
    );
  }
}

class HomeData extends StatefulWidget {
  HomeData({required this.filters});

  Map<String, dynamic> filters;

  @override
  State<HomeData> createState() => _HomeDataState();
}

class _HomeDataState extends State<HomeData> {
  @override
  Widget build(BuildContext context) {
    final LoadService loadService = Provider.of<LoadService>(context);

    final authService = Provider.of<AuthService>(context);

    final _userId = authService.user!.id;

    // final bool isSubscriptionActive = authService.user!.subscription.isActive;

    return FadeInUp(
      duration: const Duration(milliseconds: 200),
      child: FutureBuilder(
        initialData: [],
        future: loadService.getUserLoads(_userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(AppTheme.padding * 2),
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasData) {
            final loads = snapshot.data ?? [];
            if (loads.isEmpty) {
              return Center(
                child: EmptyContent(
                  icon: Iconsax.info_circle,
                  message: 'No hay datos para mostrar',
                ),
              );
            }

            return ListView.separated(
              separatorBuilder: (context, index) => SizedBox(
                height: AppTheme.padding / 2,
              ),
              clipBehavior: Clip.none,
              padding: EdgeInsets.all(AppTheme.padding / 2),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: loads.length,
              itemBuilder: (context, index) => LoadCard(
                load: loads[index],
                handleOnPressed: () async {
                  final response = await loadService.handleOnPressed(
                    context,
                    true,
                    loads[index],
                  );

                  if (!response) return;

                  setState(() {});
                },
              ),
            );
          }

          return Center(
            child: Padding(
              padding: EdgeInsets.all(AppTheme.padding * 2),
              child: Text('No hay datos para mostrar'),
            ),
          );
        },
      ),
    );
  }
}

Future<Location?> _handleSearchNavigation(BuildContext context) async {
  final response = await Navigator.of(context).pushNamed(
    '/select_location',
  );

  return response as Location?;
}

Future showBottomSheetFilterOptions(BuildContext context) async {
  Location? _selectedLocation;
  double _distanceInKm = 0.0;
  GlobalType? _selectedEquipment;

  final _equipmentService = Provider.of<EquipmentService>(
    context,
    listen: false,
  );

  List<GlobalType> _equipmentTypes =
      await _equipmentService.getEquipmentTypes();

  return showCustomBottomSheet(
    context: context,
    content: [
      SectionHeader(title: "Ubicación", hasPadding: false),
      SizedBox(height: AppTheme.padding / 2),
      StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              GestureDetector(
                onTap: () async {
                  final response = await _handleSearchNavigation(context);
                  if (response == null) return;

                  _selectedLocation = response;
                  setState(() {});
                },
                child: TextFormField(
                  enabled: false,
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText:
                        _selectedLocation?.city ?? 'Seleccionar ubicación',
                    suffixIcon: _selectedLocation != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.padding / 2,
                            ),
                            child: TextButton.icon(
                              onPressed: null,
                              label: Text('Editar'),
                              icon: Icon(
                                Icons.mode_edit_outline_outlined,
                                size: 20,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
              ),
              SizedBox(height: AppTheme.padding),
              SectionHeader(
                title: "Capacidad máxima",
                hasPadding: false,
                actionLabel: _distanceInKm.round() == 0
                    ? 'Sin límites'
                    : '${_distanceInKm.round()} Km',
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
                    value: _distanceInKm,
                    onChanged: (value) {
                      print(value);
                      _distanceInKm = value;
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
              ),
            ],
          );
        },
      ),
      SizedBox(height: AppTheme.padding * 2),
      ElevatedButton(
        onPressed: () => Navigator.of(context).pop(
          {
            'location': _selectedLocation?.id,
            'distance': _distanceInKm,
            'vehicle_type': _selectedEquipment?.id,
          },
        ),
        child: Text("Aplicar"),
      ),
    ],
  );
}

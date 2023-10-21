import 'package:animate_do/animate_do.dart';
import 'package:cargaapp_mobile/backend/models/location.dart';
import 'package:cargaapp_mobile/backend/services/equipment_service.dart';
import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:cargaapp_mobile/widgets/common/error_loading_data.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

TextEditingController _searchController = TextEditingController();

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({Key? key}) : super(key: key);

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  List<Location>? _locations;
  Location? _selectedCity;

  @override
  Widget build(BuildContext context) {
    final EquipmentService _equipmentService = Provider.of<EquipmentService>(
      context,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.base,
        leading: Container(),
        leadingWidth: 0,
        title: FadeInUp(
          duration: Duration(milliseconds: 200),
          child: TextButton.icon(
            label: Text(
              'Cancelar',
              style: TextStyle(color: Colors.redAccent),
            ),
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.close_rounded,
              color: Colors.redAccent,
            ),
          ),
        ),
        actions: [
          _selectedCity != null
              ? FadeInUp(
                  duration: Duration(milliseconds: 200),
                  child: TextButton.icon(
                    label: Text('Aceptar'),
                    onPressed: () => Navigator.of(context).pop(_selectedCity),
                    icon: Icon(Icons.check),
                  ),
                )
              : Container(),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.padding),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: AppTheme.padding),
                TextFormField(
                  style: TextStyle(fontSize: 16),
                  autofocus: true,
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar lugar por nombre',
                    prefixIcon: Icon(Iconsax.map),
                  ),
                  onEditingComplete: () async {
                    _locations = await _equipmentService
                        .search(_searchController.text.trim());
                    setState(() {});
                  },
                ),
                SizedBox(height: AppTheme.padding),
                ...List.generate(
                  _locations?.length ?? 0,
                  (index) => ListTile(
                    selectedTileColor: AppTheme.dark.withOpacity(0.2),
                    selected: _selectedCity == _locations![index],
                    leading: Icon(
                      Icons.place_rounded,
                      color: AppTheme.dark.withOpacity(0.2),
                    ),
                    title: Text(_locations![index].city),
                    onTap: () {
                      //   TODO: implement selection of city and navigate back
                      _selectedCity = _locations![index];
                      setState(() {});
                    },
                  ),
                ),
                if (_locations != null)
                  _locations!.isEmpty
                      ? ErrorLoadingData(
                          message: 'No se encontró resultados'
                              'para "${_searchController.text}"',
                        )
                      : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

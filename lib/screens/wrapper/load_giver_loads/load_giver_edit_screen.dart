import 'package:animate_do/animate_do.dart';
import 'package:cargaapp_mobile/backend/models/load.dart';
import 'package:cargaapp_mobile/backend/services/auth_service.dart';
import 'package:cargaapp_mobile/backend/services/load_service.dart';
import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:cargaapp_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class LoadGiverEditScreen extends StatefulWidget {
  LoadGiverEditScreen({super.key});

  // LoadModel? load;

  @override
  State<LoadGiverEditScreen> createState() => _LoadGiverEditScreenState();
}

class _LoadGiverEditScreenState extends State<LoadGiverEditScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // final response = await _loadService.getAllGlobalTypes();
      // if (!response) {
      //   print('Show error message');
      //   return;
      // }

      // _presentationTypes = _loadService.presentationTypes;
      // _equipmentTypes = _loadService.equipmentTypes;
      // _feeTypes = _loadService.feeTypes;
      // _transactionTypes = _loadService.transactionTypes;
      //
      // if (widget.load != null) {
      //   _loadTitle.text = widget.load!.title;
      //   _loadPresentationType = widget.load!.presentationType;
      //   _loadWeight.text = widget.load!.weight.toString();
      //   //   TODO: CONTINUAR CON ESTO WEE
      //   //   SE ESTABA PASANDO LAS PROPIEDADES DE UN LADO A OTRO PARA RELLENAR LOS CAMPOS DE UNA CARGA
      // }

      // setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<AuthService>(context);
    final _loadService = Provider.of<LoadService>(context, listen: false);

    final LoadModel? load = _loadService.currentLoad;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 150,
        leading: FadeInUp(
          duration: Duration(milliseconds: 300),
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: Container(
            decoration: BoxDecoration(color: Colors.deepOrangeAccent),
            height: 40,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: AppTheme.padding / 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Recuerda que todos los campos son obligatorios",
                  style: AppTheme.lightTheme.textTheme.headlineMedium!.copyWith(
                    color: AppTheme.base.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton.icon(
            label: Text('Guardar'),
            onPressed: () async {
              //   TODO: implement Create Load
              if (!_loadService.globalValidationOk()) return;

              final editedOrNewLoad = LoadModel(
                id: load?.id,
                title: _loadService.loadTitle.text,
                equipmentType: _loadService.loadEquipmentType!,
                presentationType: _loadService.loadPresentationType!,
                weight: double.parse(_loadService.loadWeight.text),
                userId: _authService.user!.id,
                loadingDate: _loadService.loadingDate,
                unloadingDate: _loadService.unloadingDate,
                description: _loadService.loadDescription.text,
                feeType: _loadService.loadFeeType!,
                fee: double.parse(_loadService.loadFee.text),
                transactionType: _loadService.loadTransactionType!,
                paymentDelay: int.parse(_loadService.loadPaymentDelay.text),
              );

              final responseOk = load == null
                  ? await _loadService.createLoad(editedOrNewLoad)
                  : await _loadService.updateLoad(editedOrNewLoad);

              if (responseOk) {
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(
                        'Se ha ${load == null ? "creado" : "editado"} la carga correctamente',
                      ),
                    ),
                  );

                return Navigator.of(context).pop(true);
              }

              final bool isEditing = load != null;

              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      'Hubo un error al ${isEditing ? "editar" : "crear"} la carga',
                    ),
                  ),
                );
              return null;
            },
            icon: Icon(Icons.save_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.padding),
        child: FutureBuilder(
          future: _loadService.handleEditCreateLoadForm(load),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Text('Hubo un error al cargar los datos');
            }

            if (snapshot.hasData && snapshot.data == true) {
              return _buildLoadForm(context);
            }

            return Text('Error desconocido');
          },
        ),
      ),
    );
  }
}

Widget _buildLoadForm(BuildContext context) {
  final _loadService = Provider.of<LoadService>(context, listen: false);

  return FadeInUp(
    duration: Duration(milliseconds: 300),
    child: Form(
      key: _loadService.formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppTheme.padding),
            Text(
              'Información básica',
              style: AppTheme.lightTheme.textTheme.displayMedium,
            ),
            SizedBox(height: AppTheme.padding / 2),
            InputText(
              padding: 0,
              formatter: InputFormatter.text,
              controller: _loadService.loadTitle,
              keyboardType: TextInputType.text,
              label: 'Tipo: ej. Soja, Trigo, etc.',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Este campo es obligatorio';
                }

                return null;
              },
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: DropdownMenu(
                    initialSelection: _loadService.loadPresentationType?.id,
                    width: MediaQuery.of(context).size.width / 2.4,
                    hintText: 'Tipo de presentación',
                    onSelected: (String? id) {
                      _loadService.loadPresentationType = _loadService
                          .presentationTypes
                          .firstWhere((element) => element.id == id);
                      print('done');
                    },
                    dropdownMenuEntries: _loadService.presentationTypes
                        .map<DropdownMenuEntry<String>>(
                      (GlobalType value) {
                        return DropdownMenuEntry<String>(
                          value: value.id,
                          label: value.name,
                        );
                      },
                    ).toList(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: InputText(
                    formatter: InputFormatter.number,
                    controller: _loadService.loadWeight,
                    suffix: 'Kg',
                    keyboardType: TextInputType.number,
                    label: 'Peso en kg',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Este campo es obligatorio';
                      }

                      return null;
                    },
                  ),
                ),
              ],
            ),
            DropdownMenu(
              initialSelection: _loadService.loadEquipmentType?.id,
              width: MediaQuery.of(context).size.width - AppTheme.padding * 2,
              hintText: 'Tipo de camión',
              onSelected: (String? id) {
                _loadService.loadEquipmentType = _loadService.equipmentTypes
                    .firstWhere((element) => element.id == id);
              },
              dropdownMenuEntries:
                  _loadService.equipmentTypes.map<DropdownMenuEntry<String>>(
                (GlobalType value) {
                  return DropdownMenuEntry<String>(
                    value: value.id,
                    label: value.name,
                  );
                },
              ).toList(),
            ),
            SizedBox(height: AppTheme.padding / 2),
            Divider(color: Colors.black12),
            SizedBox(height: AppTheme.padding / 2),
            Text(
              'Fecha de carga y descarga',
              style: AppTheme.lightTheme.textTheme.displayMedium,
            ),
            SizedBox(height: AppTheme.padding / 2),
            SfDateRangePicker(
              onSelectionChanged: _loadService.onSelectionChanged,
              selectionMode: DateRangePickerSelectionMode.range,
              initialSelectedRange: PickerDateRange(
                _loadService.currentLoad?.loadingDate,
                _loadService.currentLoad?.unloadingDate,
              ),
            ),
            LoadDateRange(
              loadingDate: _loadService.loadingDate,
              unloadingDate: _loadService.unloadingDate,
            ),
            SizedBox(height: AppTheme.padding / 2),
            Divider(color: Colors.black12),
            SizedBox(height: AppTheme.padding / 2),
            Text(
              'Información de pago',
              style: AppTheme.lightTheme.textTheme.displayMedium,
            ),
            SizedBox(height: AppTheme.padding / 2),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: DropdownMenu(
                    initialSelection: _loadService.loadFeeType?.id,
                    width: MediaQuery.of(context).size.width / 2.4,
                    hintText: 'Tipo de tarifa',
                    onSelected: (String? value) {
                      _loadService.loadFeeType = _loadService.feeTypes
                          .firstWhere((element) => element.id == value);
                    },
                    dropdownMenuEntries:
                        _loadService.feeTypes.map<DropdownMenuEntry<String>>(
                      (GlobalType value) {
                        return DropdownMenuEntry<String>(
                          value: value.id,
                          label: value.name,
                        );
                      },
                    ).toList(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: InputText(
                    formatter: InputFormatter.none,
                    controller: _loadService.loadFee,
                    suffix: 'ARS',
                    keyboardType: TextInputType.text,
                    label: 'Tarifa (fee)',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Este campo es obligatorio';
                      }

                      return null;
                    },
                  ),
                ),
              ],
            ),
            DropdownMenu(
              initialSelection: _loadService.loadTransactionType?.id,
              width: MediaQuery.of(context).size.width - AppTheme.padding * 2,
              hintText: 'Tipo de transacción',
              onSelected: (String? value) {
                _loadService.loadTransactionType = _loadService.transactionTypes
                    .firstWhere((element) => element.id == value);
              },
              dropdownMenuEntries:
                  _loadService.transactionTypes.map<DropdownMenuEntry<String>>(
                (GlobalType value) {
                  return DropdownMenuEntry<String>(
                    value: value.id,
                    label: value.name,
                  );
                },
              ).toList(),
            ),
            InputText(
              formatter: InputFormatter.number,
              controller: _loadService.loadPaymentDelay,
              suffix: 'Días',
              keyboardType: TextInputType.number,
              label: 'Tiempo de pago',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Este campo es obligatorio';
                }

                return null;
              },
            ),
            Divider(color: Colors.black12),
            SizedBox(height: AppTheme.padding / 2),
            Text(
              'Información adicional',
              style: AppTheme.lightTheme.textTheme.displayMedium,
            ),
            InputText(
              maxLines: 6,
              formatter: InputFormatter.none,
              controller: _loadService.loadDescription,
              keyboardType: TextInputType.text,
              label: 'Escribe datos adicionales sobre tu carga',
              validator: (value) {
                // if (value!.isEmpty) {
                //   return 'Este campo es obligatorio';
                // }

                return null;
              },
            ),
            SizedBox(height: AppTheme.padding * 2),
          ],
        ),
      ),
    ),
  );
}

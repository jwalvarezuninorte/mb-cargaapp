import 'package:cargaapp_mobile/backend/models/load.dart';
import 'package:cargaapp_mobile/backend/models/user.dart';
import 'package:cargaapp_mobile/backend/services/auth_service.dart';
import 'package:cargaapp_mobile/backend/services/load_service.dart';
import 'package:cargaapp_mobile/screens/wrapper/load_giver_loads/load_giver_edit_screen.dart';
import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:cargaapp_mobile/utils/date.dart';
import 'package:cargaapp_mobile/utils/url_launcher.dart';
import 'package:cargaapp_mobile/widgets/common/common.dart';
import 'package:cargaapp_mobile/widgets/common/popup.helper.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:url_launcher/url_launcher.dart';

class LoadDetailScreen extends StatelessWidget {
  const LoadDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments;

    // load = args as LoadModel;
    // if (args != null) {}

    final _authService = Provider.of<AuthService>(context);
    final UserModel _user = _authService.user as UserModel;

    final _loadService = Provider.of<LoadService>(context);

    LoadModel load = _loadService.currentLoad as LoadModel;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left_2),
          onPressed: () => Navigator.of(context).pop(true),
        ),
        title: Text("Detalle de carga"),
        actions: [
          _user.id == load.userId
              ? TextButton.icon(
                  onPressed: () async {
                    // _loadService.currentLoad = load;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoadGiverEditScreen(),
                      ),
                    ).then((editCompleted) {
                      if (!editCompleted) return;
                    });
                  },
                  icon: Icon(Iconsax.edit),
                  label: Text('Editar'),
                )
              : TextButton.icon(
                  onPressed: () {
                    //   TODO: implement report bottom sheet
                  },
                  icon: Icon(Iconsax.info_circle),
                  label: Text('Reportar'),
                ),
          SizedBox(width: AppTheme.padding / 2),
        ],
      ),
      body: Container(
        clipBehavior: Clip.none,
        margin: const EdgeInsets.symmetric(horizontal: AppTheme.padding),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppTheme.padding / 2),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 240,
                    child: Text(
                      "${load.title} (${load.presentationType.name})",
                      style: AppTheme.lightTheme.textTheme.displayLarge,
                      maxLines: 2,
                    ),
                  ),
                  Chip(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppTheme.defaultRadius,
                      ),
                    ),
                    backgroundColor: AppTheme.dark.withOpacity(0.05),
                    label: Text(
                      "${load.weight} Kg",
                      style: AppTheme.lightTheme.textTheme.displayMedium,
                    ),
                    labelPadding: EdgeInsets.all(AppTheme.padding / 6),
                  ),
                ],
              ),
              SizedBox(height: AppTheme.padding / 4),

              //   card caption
              Text(
                "Por ${load.userName} ~ ${load.createdAt?.timeAgo()}",
                style: AppTheme.lightTheme.textTheme.bodyMedium!.copyWith(
                  color: Colors.grey[600]!.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppTheme.padding / 4),
              Text(
                "Tipo de vehiculo: ${load.equipmentType.name}",
                style: AppTheme.lightTheme.textTheme.headlineMedium!.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: AppTheme.padding),

              // description section
              SectionHeader(title: "Descripción", hasPadding: false),

              SizedBox(height: AppTheme.padding / 2),

              Text(
                (load.description == null || load.description!.isEmpty)
                    ? 'Sin descripción'
                    : load.description!,
                style: AppTheme.lightTheme.textTheme.bodyMedium!.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: AppTheme.padding),

              AbsorbPointer(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.base.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
                  ),
                  padding: const EdgeInsets.all(AppTheme.padding / 2),
                  child: SfDateRangePicker(
                    initialSelectedRange: PickerDateRange(
                      load.loadingDate,
                      load.unloadingDate,
                    ),
                    controller: _loadService.pickerController,
                    initialSelectedRanges: [
                      PickerDateRange(load.loadingDate, load.unloadingDate),
                    ],
                    selectionMode: DateRangePickerSelectionMode.range,
                  ),
                ),
              ),

              Text(load.loadingDate.readable()),

              SizedBox(height: AppTheme.padding),

              Divider(
                height: 0,
                color: AppTheme.dark.withOpacity(0.05),
              ),

              SizedBox(height: AppTheme.padding),
              //   card date section

              SectionHeader(
                title: "Información de pago",
                hasPadding: false,
              ),

              SizedBox(height: AppTheme.padding / 2),

              Wrap(
                children: [
                  Chip(
                    padding: EdgeInsets.symmetric(
                      vertical: AppTheme.padding / 2,
                      horizontal: AppTheme.padding / 2,
                    ),
                    backgroundColor: AppTheme.base.withOpacity(0.8),
                    label: Text(
                      'Tipo tarifa: ${load.feeType.name}',
                      style: AppTheme.lightTheme.textTheme.headlineMedium!
                          .copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Chip(
                    padding: EdgeInsets.symmetric(
                      vertical: AppTheme.padding / 2,
                      horizontal: AppTheme.padding / 2,
                    ),
                    backgroundColor: AppTheme.base.withOpacity(0.8),
                    label: Text(
                      'Tarifa: ${load.fee}',
                      style: AppTheme.lightTheme.textTheme.headlineMedium!
                          .copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Chip(
                    padding: EdgeInsets.symmetric(
                      vertical: AppTheme.padding / 2,
                      horizontal: AppTheme.padding / 2,
                    ),
                    backgroundColor: AppTheme.base.withOpacity(0.8),
                    label: Text(
                      '${load.transactionType.name}',
                      style: AppTheme.lightTheme.textTheme.headlineMedium!
                          .copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Chip(
                    padding: EdgeInsets.symmetric(
                      vertical: AppTheme.padding / 2,
                      horizontal: AppTheme.padding / 2,
                    ),
                    backgroundColor: AppTheme.base.withOpacity(0.8),
                    label: Text(
                      'Tiempo de pago: ${load.paymentDelay} días',
                      style: AppTheme.lightTheme.textTheme.headlineMedium!
                          .copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
              //   card date section

              SizedBox(height: AppTheme.padding / 2),
              _user.id == load.userId
                  ? SizedBox()
                  : ElevatedButton(
                      onPressed: () async {
                        final Uri whatsappLaunchUri = Uri(
                          scheme: 'https',
                          path: 'wa.me/+573015351652}',
                          query: UrlLauncher.encodeQueryParameters(
                            <String, String>{
                              'text': 'Hola ${load?.userName}...',
                            },
                          ),
                        );
                        await launchUrl(
                          whatsappLaunchUri,
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: Text(
                        'Contactar a ${load.userName?.split(" ")[0]}',
                      ),
                    ),

              SizedBox(height: AppTheme.padding),
              if (_user.id == load.userId)
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
                      final bool confirm = await showCustomDialog(
                        context: context,
                        popupTitle: 'Confirmar',
                        popupContent: '¿Está seguro de eliminar la carga?',
                      ).then((value) => value);

                      if (!confirm) return;

                      final deletedLoad =
                          await _loadService.deleteLoadById(load.id!);

                      if (deletedLoad) {
                        Navigator.of(context).pop(true);

                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text(
                                'Se ha eliminado la carga correctamente',
                              ),
                            ),
                          );
                      }
                    },
                    icon: Icon(
                      Iconsax.trash,
                      color: Colors.redAccent,
                    ),
                    label: Text(
                      'Eliminar',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ),

              SizedBox(height: AppTheme.padding * 2),
            ],
          ),
        ),
      ),
    );
  }
}

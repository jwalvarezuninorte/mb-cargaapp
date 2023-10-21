import 'package:cargaapp_mobile/backend/models/load.dart';
import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:cargaapp_mobile/utils/date.dart';
import 'package:cargaapp_mobile/utils/url_launcher.dart';
import 'package:cargaapp_mobile/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class OfferDetailScreen extends StatelessWidget {
  const OfferDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    LoadModel? load;

    load = args as LoadModel;
    if (args != null) {}

    return Scaffold(
      appBar: AppBar(
        title: Text("Detalle de carga"),
        actions: [
          TextButton.icon(
            onPressed: () {},
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
                        AppTheme.defaultRadius * 2,
                      ),
                    ),
                    backgroundColor: AppTheme.dark.withOpacity(0.05),
                    label: Text(
                      "${load.weight} Kg",
                      style: AppTheme.lightTheme.textTheme.displayMedium,
                    ),
                    labelPadding: EdgeInsets.all(AppTheme.padding / 2),
                  )
                ],
              ),
              SizedBox(height: AppTheme.padding / 4),

              //   card caption
              Text(
                "Por ${load.userName} ~ ${load.createdAt.timeAgo()}",
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

              Divider(
                height: 0,
                color: AppTheme.dark.withOpacity(0.05),
              ),
              SizedBox(height: AppTheme.padding),

              // description section
              SectionHeader(title: "Descripción", hasPadding: false),

              SizedBox(height: AppTheme.padding / 2),

              Text(
                load.description,
                style: AppTheme.lightTheme.textTheme.bodyMedium!.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
                textAlign: TextAlign.justify,
              ),

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

              Placeholder(
                fallbackHeight: 100,
              ),

              SizedBox(height: AppTheme.padding),

              Divider(
                height: 0,
                color: AppTheme.dark.withOpacity(0.05),
              ),
              SizedBox(height: AppTheme.padding),
              //   card date section

              SectionHeader(
                title: "Información de carga/descarga",
                hasPadding: false,
              ),

              SizedBox(height: AppTheme.padding / 2),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    padding: EdgeInsets.symmetric(
                      vertical: AppTheme.padding / 2,
                      horizontal: AppTheme.padding / 2,
                    ),
                    backgroundColor: AppTheme.base.withOpacity(0.8),
                    label: Text(
                      load.loadingDate.readable(),
                      style: AppTheme.lightTheme.textTheme.headlineMedium!
                          .copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Icon(
                      Icons.arrow_right_rounded,
                      size: 26,
                      color: AppTheme.dark,
                    ),
                  ),
                  Chip(
                    padding: EdgeInsets.symmetric(
                      vertical: AppTheme.padding / 2,
                      horizontal: AppTheme.padding / 2,
                    ),
                    backgroundColor: AppTheme.base.withOpacity(0.8),
                    label: Text(
                      load.unloadingDate.readable(),
                      style: AppTheme.lightTheme.textTheme.headlineMedium!
                          .copyWith(
                        color: Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppTheme.padding / 2),
              ElevatedButton(
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
                child: Text('Contactar a ${load.userName.split(" ")[0]}'),
              ),
              SizedBox(height: AppTheme.padding * 2),
            ],
          ),
        ),
      ),
    );
  }
}

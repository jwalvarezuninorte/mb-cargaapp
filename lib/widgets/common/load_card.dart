import 'package:cargaapp_mobile/backend/models/load.dart';
import 'package:cargaapp_mobile/backend/services/auth_service.dart';
import 'package:cargaapp_mobile/backend/services/load_service.dart';
import 'package:cargaapp_mobile/screens/miscellany/full_screen_process_status.dart';
import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:cargaapp_mobile/utils/date.dart';
import 'package:cargaapp_mobile/widgets/base/load_date_range.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadCard extends StatelessWidget {
  const LoadCard({
    super.key,
    required this.load,
    required this.handleOnPressed,
  });

  final LoadModel load;

  // final void Function(
  //   BuildContext context,
  //   bool isSubscriptionActive,
  //   LoadModel load,
  // ) handleOnPressed;

  final VoidCallback handleOnPressed;

  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<AuthService>(context);
    final bool isSubscriptionActive = _authService.user!.subscription.isActive;

    return GestureDetector(
      onTap: handleOnPressed,
      child: Container(
        padding: EdgeInsets.all(AppTheme.padding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
          border: Border.all(color: AppTheme.dark.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.dark.withOpacity(0.2),
              spreadRadius: -6,
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //   card header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 200,
                  child: Text(
                    "${load.title} (${load.presentationType.name})",
                    style: AppTheme.lightTheme.textTheme.displayMedium,
                    maxLines: 2,
                  ),
                ),
                Chip(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
                  ),
                  backgroundColor: AppTheme.dark.withOpacity(0.05),
                  label: Text(
                    "${load.weight} Kg",
                    style: AppTheme.lightTheme.textTheme.displaySmall,
                  ),
                  labelPadding: EdgeInsets.all(2),
                )
              ],
            ),

            SizedBox(height: AppTheme.padding / 4),
            Text(
              "Tipo de vehiculo: ${load.equipmentType.name}",
              style: AppTheme.lightTheme.textTheme.headlineMedium!.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppTheme.padding / 2),

            //   card caption
            isSubscriptionActive
                ? LoadDateRange(
                    loadingDate: load.loadingDate,
                    unloadingDate: load.unloadingDate,
                  )
                : Container(),

            //   card button
            SizedBox(height: AppTheme.padding / 2),
            ElevatedButton(
              style: isSubscriptionActive
                  ? null
                  : AppTheme.lightTheme.elevatedButtonTheme.style!.copyWith(
                      backgroundColor: MaterialStatePropertyAll(AppTheme.base),
                      foregroundColor:
                          MaterialStatePropertyAll(AppTheme.primary),
                    ),
              onPressed: handleOnPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  !isSubscriptionActive
                      ? Row(
                          children: [
                            Icon(Icons.lock),
                            SizedBox(width: AppTheme.padding / 2),
                          ],
                        )
                      : Container(),
                  Text("Ver detalles"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

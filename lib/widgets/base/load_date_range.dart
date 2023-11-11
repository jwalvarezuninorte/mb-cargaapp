import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:cargaapp_mobile/utils/date.dart';
import 'package:flutter/material.dart';

class LoadDateRange extends StatelessWidget {
  const LoadDateRange({
    super.key,
    required this.loadingDate,
    required this.unloadingDate,
  });

  final DateTime? loadingDate;
  final DateTime? unloadingDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Chip(
            padding: EdgeInsets.symmetric(
              vertical: AppTheme.padding / 2,
              horizontal: AppTheme.padding / 2,
            ),
            backgroundColor: AppTheme.base.withOpacity(0.8),
            label: Text(
              loadingDate?.readable() ?? 'Sin fecha de carga',
              style: AppTheme.lightTheme.textTheme.headlineMedium!.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),
        ),
        Icon(
          Icons.arrow_right_rounded,
          size: 26,
          color: AppTheme.dark,
        ),
        Expanded(
          child: Chip(
            padding: EdgeInsets.symmetric(
              vertical: AppTheme.padding / 2,
              horizontal: AppTheme.padding / 2,
            ),
            backgroundColor: AppTheme.base.withOpacity(0.8),
            label: Text(
              unloadingDate?.readable() ?? 'Sin fecha de descarga',
              style: AppTheme.lightTheme.textTheme.headlineMedium!.copyWith(
                color: Colors.grey[600],
              ),
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
        ),
      ],
    );
  }
}

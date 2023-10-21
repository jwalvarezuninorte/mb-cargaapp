import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DragIndicator extends StatelessWidget {
  const DragIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: AppTheme.padding),
          width: 50,
          height: 5,
          decoration: BoxDecoration(
            color: AppTheme.dark.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
          ),
        ),
      ],
    );
  }
}

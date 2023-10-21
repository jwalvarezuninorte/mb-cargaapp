import 'package:flutter/material.dart';
import 'package:cargaapp_mobile/theme/app_theme.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppTheme.padding / 2,
      ),
      padding: EdgeInsets.all(AppTheme.padding / 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          AppTheme.defaultRadius * 4,
        ),
        border: Border.all(
          color: AppTheme.secondary,
          width: 1,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.secondary, AppTheme.primary],
        ),
      ),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            AppTheme.defaultRadius * 4 - 2,
          ),
        ),
        child: Icon(
          Icons.add,
          size: 30,
          color: AppTheme.secondary,
        ),
      ),
    );
  }
}

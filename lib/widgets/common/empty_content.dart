import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent({
    required this.message,
    required this.icon,
    this.iconSize,
    this.buttonText,
    this.onPressed,
    super.key,
  });

  final String message;
  final IconData icon;
  final String? buttonText;
  final VoidCallback? onPressed;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 30),
        SizedBox(height: AppTheme.padding / 2),
        Text(message, textAlign: TextAlign.center),
        SizedBox(height: AppTheme.padding),
        if (buttonText != null)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppTheme.padding * 2.5,
            ),
            child: ElevatedButton(
              onPressed: onPressed,
              child: Text(buttonText ?? ''),
            ),
          )
      ],
    );
  }
}

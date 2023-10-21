import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Button({
    super.key,
    required this.onPressed,
    required this.label,
    required this.icon,
    this.color = AppTheme.dark,
    this.padding,
  });

  final VoidCallback onPressed;
  final String label;
  final IconData icon;
  final Color color;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.only(top: AppTheme.padding / 2),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.02),
          padding: EdgeInsets.symmetric(
            horizontal: AppTheme.padding,
            vertical: AppTheme.padding * 0.8,
          ),
        ),
        onPressed: onPressed,
        label: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: color.withOpacity(0.8),
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
          ],
        ),
        icon: Icon(icon, color: color),
      ),
    );
  }
}

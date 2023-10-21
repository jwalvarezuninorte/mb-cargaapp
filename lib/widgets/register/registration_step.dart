import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';

class RegistrationStep extends StatelessWidget {
  const RegistrationStep({
    this.callToAction,
    required this.child,
    required this.subtitle,
    required this.title,
    super.key,
  });

  final String subtitle;
  final String title;
  final Widget? callToAction;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.padding,
        0,
        AppTheme.padding,
        AppTheme.padding,
      ),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 32,
                color: AppTheme.dark,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppTheme.dark.withOpacity(0.3),
              ),
            ),
            const SizedBox(height: AppTheme.padding / 2),
            child,
            callToAction ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

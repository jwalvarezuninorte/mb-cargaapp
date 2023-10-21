import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';

enum SectionHeaderType {
  title,
  de,
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    super.key,
    this.actionLabel = 'Ver todas',
    this.onMorePressed,
    this.hasPadding = true,
  });

  final String title;
  final String actionLabel;
  final VoidCallback? onMorePressed;
  final bool? hasPadding;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (hasPadding!)
          const SizedBox(
            width: AppTheme.padding,
          ),
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.displayMedium!.copyWith(
            color: Colors.black38,
          ),
        ),
        const Spacer(),
        if (onMorePressed != null)
          TextButton(
            onPressed: onMorePressed,
            child: Text(actionLabel),
          ),
        if (hasPadding!)
          const SizedBox(
            width: AppTheme.padding,
          ),
      ],
    );
  }
}

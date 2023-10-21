import 'package:flutter/material.dart';
import 'package:cargaapp_mobile/theme/app_theme.dart';

class QuestionActionRow extends StatelessWidget {
  const QuestionActionRow({
    required this.questionLabel,
    required this.actionLabel,
    required this.action,
    super.key,
    this.dark = false,
  });
  final String questionLabel;
  final String actionLabel;
  final VoidCallback action;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          questionLabel,
          style: AppTheme.lightTheme.textTheme.displaySmall!.copyWith(
            color: dark ? AppTheme.base : AppTheme.dark.withOpacity(0.6),
          ),
        ),
        TextButton(
          onPressed: action,
          child: Text(
            actionLabel,
            style: AppTheme.lightTheme.textTheme.displaySmall!.copyWith(
              color: dark ? AppTheme.primary : AppTheme.dark.withOpacity(0.6),
            ),
          ),
        ),
      ],
    );
  }
}

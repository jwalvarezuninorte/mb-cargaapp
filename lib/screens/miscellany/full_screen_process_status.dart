import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';

class FullScreenProcessStatus extends StatelessWidget {
  const FullScreenProcessStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(AppTheme.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Icon(
              args.icon,
              color: args.isError ? Colors.redAccent : Colors.lightGreen,
              size: 100,
            ),
            SizedBox(height: AppTheme.padding),
            Text(
              args.title,
              style: AppTheme.lightTheme.textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppTheme.padding / 2),
            Text(
              args.message,
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: AppTheme.padding),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.padding * 2,
              ),
              child: ElevatedButton(
                onPressed: args.onTap,
                child: Text(args.btnLabel),
              ),
            ),
            Spacer(),
            TextButton(
              onPressed: args.bottonAction,
              child: Text(
                args.bottomLabel,
                style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  color: AppTheme.dark.withOpacity(0.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScreenArguments {
  final String title;
  final String message;
  final IconData icon;
  final bool isError;

  final VoidCallback onTap;
  final String btnLabel;

  final String bottomLabel;
  final VoidCallback bottonAction;

  ScreenArguments(
    this.title,
    this.message,
    this.icon,
    this.isError,
    this.onTap,
    this.btnLabel,
    this.bottomLabel,
    this.bottonAction,
  );
}

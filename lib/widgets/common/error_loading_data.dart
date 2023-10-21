import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorLoadingData extends StatelessWidget {
  const ErrorLoadingData({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lottie/error.json',
            width: 150,
            height: 150,
            fit: BoxFit.cover,
            repeat: false,
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.displaySmall,
          ),
        ],
      ),
    );
  }
}

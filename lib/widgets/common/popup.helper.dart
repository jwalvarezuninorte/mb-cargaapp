import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';

Future showCustomDialog({
  required BuildContext context,
  required String popupTitle,
  required String popupContent,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(popupTitle),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                popupContent,
                style: AppTheme.lightTheme.textTheme.displayMedium,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.redAccent),
            ),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('Aceptar'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
    },
  );
}

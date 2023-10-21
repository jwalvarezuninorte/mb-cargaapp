import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class LoadGiverLoadsScreen extends StatelessWidget {
  const LoadGiverLoadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.base,
        title: Text("Mis cargas"),
        actions: [
          TextButton.icon(
            label: Text('Agregar'),
            onPressed: () {},
            icon: Icon(Iconsax.add_circle),
          ),
        ],
      ),
      body: Placeholder(),
    );
  }
}

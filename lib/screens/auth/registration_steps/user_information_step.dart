import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:cargaapp_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../backend/services/auth_service.dart';

class UserInformationStep extends StatelessWidget {
  UserInformationStep({
    super.key,
  });

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    void updateJsonUser(String key, String value) {
      authService.jsonUser = {
        ...authService.jsonUser,
        key: value,
      };
    }

    return RegistrationStep(
      title: 'Ingresa tus \ndatos básicos',
      subtitle: 'Para ingresar debes tener una cuenta. Crea una.',
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Nombre completo',
                prefixIcon: Icon(
                  FontAwesomeIcons.userLarge,
                  size: 24,
                  color: AppTheme.dark.withOpacity(0.3),
                ),
              ),
              controller: _nameController,
              onChanged: (value) => updateJsonUser('name', value),
              onEditingComplete: () {
                FocusScope.of(context).nextFocus();
              },
              autofocus: true,
            ),
            const SizedBox(height: AppTheme.padding / 2),
            TextFormField(
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Correo electrónico',
                prefixIcon: Icon(
                  FontAwesomeIcons.at,
                  size: 24,
                  color: AppTheme.dark.withOpacity(0.3),
                ),
              ),
              controller: _emailController,
              onChanged: (value) => updateJsonUser('email', value),
              onEditingComplete: () {
                FocusScope.of(context).nextFocus();
              },
            ),
            const SizedBox(height: AppTheme.padding / 2),
            TextFormField(
              style: TextStyle(fontSize: 16),
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Contraseña',
                prefixIcon: Icon(
                  FontAwesomeIcons.lock,
                  size: 24,
                  color: AppTheme.dark.withOpacity(0.3),
                ),
              ),
              controller: _passwordController,
              onChanged: (value) => updateJsonUser('password', value),
              onEditingComplete: () => FocusScope.of(context).nextFocus(),
            ),
            const SizedBox(height: AppTheme.padding * 2),
          ],
        ),
      ),
    );
  }
}

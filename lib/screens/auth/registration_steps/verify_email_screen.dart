import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../backend/services/auth_service.dart';

class VerifyEmailScreen extends StatelessWidget {
  VerifyEmailScreen({Key? key}) : super(key: key);

  final TextEditingController _verificationCodeController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    void updateJsonUser(String key, String value) {
      authService.jsonUser = {
        ...authService.jsonUser,
        key: value,
      };
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppTheme.padding,
            AppTheme.padding * 2,
            AppTheme.padding,
            AppTheme.padding,
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lottie/email_sent.json',
                width: 200,
                repeat: false,
              ),
              Text(
                'Verifica tu cuenta',
                style: AppTheme.lightTheme.textTheme.displayLarge,
              ),
              const SizedBox(height: AppTheme.padding),

              TextFormField(
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Código de verificación',
                ),
                controller: _verificationCodeController,
                onChanged: (value) =>
                    updateJsonUser('verification_code', value),
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
                },
                autofocus: true,
              ),
              const SizedBox(height: AppTheme.padding),
              Text(
                msg,
                style: AppTheme.lightTheme.textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              Spacer(),
              // const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.of(context).pushNamedAndRemoveUntil(
              //       '/login',
              //       (route) => false,
              //     );
              //   },
              //   child: const Text('Iniciar sesión'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

String msg =
    'Por favor, revisa tu correo electrónico y sigue las instrucciones para verificar tu cuenta.';

String msg2 =
    'Si no encuentras el correo electrónico, \nrevisa tu carpeta de spam.';

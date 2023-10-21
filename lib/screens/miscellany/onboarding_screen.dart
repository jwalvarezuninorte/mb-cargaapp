import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:cargaapp_mobile/widgets/common/question_action_row.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Image.asset(
              'assets/images/pexels-nicklas-12546374.jpg',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.9],
                    colors: [
                      Colors.transparent,
                      Colors.black87,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.padding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text(
                    'Conectamos el trasporte directo con\nel dador de cargas',
                    style: AppTheme.lightTheme.textTheme.displayLarge!.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 32,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: AppTheme.padding),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/login');
                    },
                    child: const Text('Iniciar sesión'),
                  ),
                  const SizedBox(height: AppTheme.padding / 2),
                  QuestionActionRow(
                    dark: true,
                    questionLabel: '¿No tienes una cuenta?',
                    actionLabel: 'Crear cuenta',
                    action: () {
                      Navigator.of(context).pushNamed('/register');
                    },
                  ),
                  const SizedBox(height: AppTheme.padding * 2),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

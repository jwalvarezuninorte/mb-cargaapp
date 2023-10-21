import 'package:cargaapp_mobile/screens/auth/registration_steps/registration_steps.dart';
import 'package:cargaapp_mobile/screens/auth/registration_steps/verify_email_screen.dart';
import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:cargaapp_mobile/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../backend/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final PageController _pageController = PageController();

  final List<Widget> _steps = [
    UserInformationStep(),
    UserTypeSelectionStep(),
    VerifyEmailScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GoBackAppBar(),
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: _steps,
            ),
            _ButtonAndPageIndicator(
              pageController: _pageController,
              steps: _steps,
            ),
          ],
        ),
      ),
    );
  }
}

class _ButtonAndPageIndicator extends StatefulWidget {
  const _ButtonAndPageIndicator({
    required PageController pageController,
    required List<Widget> steps,
  })  : _pageController = pageController,
        _steps = steps;

  final PageController _pageController;
  final List<Widget> _steps;

  @override
  State<_ButtonAndPageIndicator> createState() =>
      _ButtonAndPageIndicatorState();
}

class _ButtonAndPageIndicatorState extends State<_ButtonAndPageIndicator> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final jsonUser = authService.jsonUser;
    return Positioned(
      bottom: 20,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.padding),
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(
                  MediaQuery.of(context).size.width - AppTheme.padding * 2,
                  60,
                ),
              ),
              onPressed: () => _handleClick(
                widget._pageController.page?.toInt(),
                jsonUser,
                widget._pageController,
                widget._steps,
                context,
                authService,
              ),
              child: Text(getButtonText(widget._pageController.page)),
            ),
            const SizedBox(height: AppTheme.padding),
            SmoothPageIndicator(
              controller: widget._pageController,
              count: widget._steps.length,
              effect: ExpandingDotsEffect(
                dotColor: AppTheme.dark.withOpacity(0.2),
                activeDotColor: AppTheme.dark,
                dotHeight: 12,
                dotWidth: 12,
                expansionFactor: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String getButtonText(page) {
  debugPrint(page.toString());
  switch (page) {
    case 1:
      return "Crear cuenta";
    case 2:
      return "Verificar código";
    case 3:
      return "Este es el último step";
    default:
      return "Continuar";
  }
}

void _handleClick(
  int? page,
  Map<String, dynamic> jsonUser,
  PageController scrollController,
  List<Widget> steps,
  BuildContext context,
  AuthService authService,
) async {
  if (!isStepCompleted(page, jsonUser)) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa todos los campos'),
        ),
      );
    return;
  }

  switch (page) {
    case 1:
      try {
        await authService.register();

        scrollController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } catch (e) {
        debugPrint(e.toString());
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(e.toString().substring(10)),
            ),
          );
      }
      return;
    case 2:
      try {
        await authService.verify();
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('La verificación ha sido correcta ✨'),
            ),
          );

        // Navigator.of(context).popAndPushNamed("/login");
      } catch (e) {
        debugPrint(e.toString());
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(e.toString().substring(10)),
            ),
          );
      }
      return;
    default:
      scrollController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
  }
}

// Todo: Add documentation
bool isStepCompleted(int? page, Map<String, dynamic> jsonUser) {
  switch (page) {
    case 0:
      return jsonUser['name'] != null &&
          jsonUser['email'] != null &&
          jsonUser['password'] != null;
    case 1:
      return jsonUser['dni'] != null &&
          jsonUser['phone_number'] != null &&
          jsonUser['id_user_type'] != null;
    case 2:
      return jsonUser['verification_code'] != null;
  }
  return false;
}

import 'dart:async';

import 'package:cargaapp_mobile/backend/services/auth_service.dart';
import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:cargaapp_mobile/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as Supabase;

TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late FocusNode _passwordFocusNode;
  bool _loading = false;

  late final StreamSubscription<Supabase.AuthState> _authStateSubscription;
  late AuthService _authService;

  Future login(
    AuthService authService,
  ) async {
    _loading = true;
    setState(() {});
    try {
      await authService.supabase.auth.signInWithPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verifica los datos ingresados 👀'),
        ),
      );
    }
    _loading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _authService = Provider.of<AuthService>(context, listen: false);

      _authStateSubscription =
          _authService.supabase.auth.onAuthStateChange.listen(
        (data) async {
          // if (_redirecting) return;
          final session = data.session;
          if (session != null) {
            _authService.user = await _authService.getUserDetail();
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/app',
              (route) => false,
            );
          }
        },
      );
    });

    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _authStateSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);
    //
    _emailController.text = 'enusa@telegmail.com';
    _passwordController.text = 'enusa@telegmail.com';

    return Scaffold(
      appBar: GoBackAppBar(),
      body: GestureDetector(
        onVerticalDragCancel: () => FocusScope.of(context).unfocus(),
        onHorizontalDragCancel: () => FocusScope.of(context).unfocus(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.padding),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: AppTheme.padding),
              TextFormField(
                style: TextStyle(fontSize: 16),
                autofocus: true,
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Correo electrónico',
                  prefixIcon: Icon(FontAwesomeIcons.at),
                ),
                onFieldSubmitted: (value) => _passwordFocusNode.requestFocus(),
              ),
              const SizedBox(height: AppTheme.padding),
              TextFormField(
                style: TextStyle(fontSize: 16),
                focusNode: _passwordFocusNode,
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Contraseña',
                  prefixIcon: Icon(FontAwesomeIcons.lock),
                ),
                onFieldSubmitted: (value) => login(authService),
              ),
              SectionHeader(
                title: '',
                actionLabel: 'Olvidé mi contraseña',
                onMorePressed: () {
                  // TODO: Implement forgot password
                },
                hasPadding: false,
              ),
              // const SizedBox(height: AppTheme.padding * 2),
              Spacer(),
              ElevatedButton(
                onPressed: () => login(authService),
                child: _loading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: AppTheme.base,
                        ),
                      )
                    : const Text('Iniciar sesión'),
              ),
              // const SizedBox(height: AppTheme.padding * 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿No tienes una cuenta?',
                    style: AppTheme.lightTheme.textTheme.displaySmall!.copyWith(
                      color: AppTheme.dark.withOpacity(0.6),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushNamed(
                      '/register',
                    ),
                    child: const Text('Regístrate'),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.padding),
            ],
          ),
        ),
      ),
    );
  }
}

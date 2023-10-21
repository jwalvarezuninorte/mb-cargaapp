import 'dart:async';

import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as Supabase;

import '../../backend/services/auth_service.dart';

class VerifySavedUserScreen extends StatefulWidget {
  const VerifySavedUserScreen({Key? key}) : super(key: key);

  @override
  State<VerifySavedUserScreen> createState() => _VerifySavedUserScreenState();
}

class _VerifySavedUserScreenState extends State<VerifySavedUserScreen> {
  late final StreamSubscription<Supabase.AuthState> _authStateSubscription;
  late AuthService _authService;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _authService = Provider.of<AuthService>(context, listen: false);
      final _auth = _authService.supabase.auth;

      // if (_authService.supabase.auth.currentSession != null) {
      //   Navigator.pushReplacementNamed(context, '/app');
      // }

      _authStateSubscription = _auth.onAuthStateChange.listen(
        (data) async {
          // if (_redirecting) return;
          final session = data.session;
          if (session != null) {
            // Get user detail
            _authService.user = await _authService.getUserDetail();
            // _redirecting = true;
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/app',
              (route) => false,
            );
          }
        },
      );

      if (_auth.currentSession == null) {
        Navigator.of(context).pushNamed('/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator(color: AppTheme.primary)),
    );
  }
}

import 'package:cargaapp_mobile/app_scaffold.dart';
import 'package:cargaapp_mobile/screens/auth/registration_steps/verify_email_screen.dart';
import 'package:cargaapp_mobile/screens/membership/membership_onboarding_screen.dart';
import 'package:cargaapp_mobile/screens/screens.dart';
import 'package:cargaapp_mobile/screens/common/load_detail_screen.dart';
import 'package:flutter/material.dart';

import '../screens/auth/verify_saved_user_screen.dart';

class AppRoutes {
  static const initialRoute = '/init';

  static Map<String, Widget Function(BuildContext)> routes = {
    '/init': (BuildContext context) => const VerifySavedUserScreen(),
    '/app': (BuildContext context) => const AppScaffold(),
    '/login': (BuildContext context) => const LoginScreen(),
    '/register': (BuildContext context) => const RegisterScreen(),
    '/onboarding': (BuildContext context) => const OnboardingScreen(),
    '/verify_email': (BuildContext context) => VerifyEmailScreen(),
    '/membership_onboarding': (BuildContext context) =>
        const MembershipOnboardingScreen(),
    '/search': (BuildContext context) => const SearchScreen(),
    '/offer_detail': (BuildContext context) => const LoadDetailScreen(),
    '/pay_membership': (BuildContext context) => const PayMembershipScreen(),
    '/payment_status': (BuildContext context) =>
        const FullScreenProcessStatus(),
    '/full_screen_status': (BuildContext context) =>
        const FullScreenProcessStatus(),
    '/select_location': (BuildContext context) => const SelectLocationScreen(),
    '/edit_load': (BuildContext context) => LoadGiverEditScreen(),
    '/create_load': (BuildContext context) => LoadGiverEditScreen(),
    '/edit_profile': (BuildContext context) => EditProfileScreen(),
  };
}

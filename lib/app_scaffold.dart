import 'dart:async';

import 'package:cargaapp_mobile/backend/models/subscription.dart';
import 'package:cargaapp_mobile/backend/services/app_service.dart';
import 'package:cargaapp_mobile/screens/miscellany/browser_view_screen.dart';
import 'package:cargaapp_mobile/screens/screens.dart';
import 'package:cargaapp_mobile/screens/wrapper/driver_equipments/driver_equipments_screen.dart';
import 'package:cargaapp_mobile/screens/wrapper/load_giver_loads/load_giver_loads_screen.dart';
import 'package:cargaapp_mobile/screens/wrapper/offers/load_giver/offers_screen.dart';
import 'package:cargaapp_mobile/widgets/common/common.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as Supabase;

import 'backend/services/auth_service.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({
    super.key,
  });

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  late final StreamSubscription<Supabase.AuthState> _authStateSubscription;
  late final StreamSubscription _userSubscriptionState;
  late AuthService _authService;

  // late List<Widget> screens;

  List<Widget> driverScreens = [
    const DriverOffersScreen(),
    // const SearchScreen(),
    const DriverEquipmentsScreen(),
    const ProfileScreen(),
  ];

  // TODO: Change to the respective screens array
  List<Widget> loadGiverScreens = [
    const LoadGiverOffersScreen(),
    // const SearchScreen(),
    const LoadGiverLoadsScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/init',
        (route) => false,
      );
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _authService = Provider.of<AuthService>(context, listen: false);

        // if (_authService.user == null) {
        //   Navigator.of(context).pushNamedAndRemoveUntil(
        //     '/init',
        //     (route) => false,
        //   );
        // }

        _authStateSubscription =
            _authService.supabase.auth.onAuthStateChange.listen(
          (data) {
            final session = data.session;
            if (session == null) {
              print("🔴🔴🔴🔴");
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/onboarding',
                (route) => false,
              );
            }
          },
        );

        _userSubscriptionState = _authService.supabase
            .from('subscriptions')
            .stream(primaryKey: ['id'])
            .eq('id', _authService.user?.subscription.id)
            .listen((List<Map<String, dynamic>> data) {
              Subscription newSubscription = Subscription.fromJson({
                ...data[0],
                "membership":
                    _authService.user?.subscription.membership.toJson()
              });

              _authService.updateUserSubscription(newSubscription);

              print(data);
            });
      },
    );
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    _userSubscriptionState.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppService _appService = Provider.of<AppService>(context);
    final AuthService _authService = Provider.of<AuthService>(context);
    final bool isDriver =
        _authService.user?.subscription.membership.price != null;
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onVerticalDragCancel: () => FocusScope.of(context).unfocus(),
        onHorizontalDragCancel: () => FocusScope.of(context).unfocus(),
        child: kIsWeb
            ? BrowserViewScreen(
                content: PageView(
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _appService.pageController,
                  children: isDriver ? driverScreens : loadGiverScreens,
                ),
              )
            : PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _appService.pageController,
                children: isDriver ? driverScreens : loadGiverScreens,
              ),
      ),
      bottomNavigationBar: kIsWeb
          ? null
          : CustomBottomNavigationBar(
              selectedIndex: _appService.selectedIndex,
              onTap: (p0) => _appService.changeScreen(p0, context),
            ),
    );
  }
}

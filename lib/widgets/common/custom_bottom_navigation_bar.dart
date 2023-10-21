import 'package:animate_do/animate_do.dart';
import 'package:cargaapp_mobile/backend/models/subscription.dart';
import 'package:cargaapp_mobile/backend/services/auth_service.dart';
import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    required this.selectedIndex,
    required this.onTap,
    super.key,
  });

  final int selectedIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<AuthService>(context);
    final Subscription _subscription = _authService.user!.subscription;

    final bool isDriver =
        _authService.user!.subscription.membership.price != null;

    final _driverBottomNavigationItems = [
      const _BottomNavigationItem(
        icon: Iconsax.flash_1,
        label: 'Ofertas',
      ),
      // const _BottomNavigationItem(
      //   icon: Iconsax.search_normal,
      //   label: 'Buscar',
      // ),
      const _BottomNavigationItem(
        icon: Iconsax.truck,
        label: 'Mis equipos',
      ),
      const _BottomNavigationItem(
        icon: Iconsax.user,
        label: 'Perfil',
      ),
    ];

    final _loadGiverBottomNavigationItems = [
      const _BottomNavigationItem(
        icon: Iconsax.truck_fast,
        label: 'Ofertas',
      ),
      // const _BottomNavigationItem(
      //   icon: Iconsax.search_normal,
      //   label: 'Buscar',
      // ),
      const _BottomNavigationItem(
        icon: Iconsax.box,
        label: 'Mis cargas',
      ),
      const _BottomNavigationItem(
        icon: Iconsax.user,
        label: 'Perfil',
      ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _subscription.isActive
            ? Container()
            : SlideInUp(
                delay: Duration(seconds: 0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(
                    "/membership_onboarding",
                  ),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.deepOrangeAccent),
                    height: 40,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppTheme.padding / 2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "🚐 Obten una membresía para tener acceso a toda la app",
                          style: AppTheme.lightTheme.textTheme.headlineMedium!
                              .copyWith(
                            color: AppTheme.base.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        Container(
          decoration: BoxDecoration(
            // color: Colors.red,
            border: Border(
              top: BorderSide(color: AppTheme.dark.withOpacity(0.2)),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: onTap,
            elevation: 0,
            items: [
              ...List.generate(
                isDriver
                    ? _driverBottomNavigationItems.length
                    : _loadGiverBottomNavigationItems.length,
                (index) => BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.all(AppTheme.padding / 2),
                    child: Icon(
                      isDriver
                          ? _driverBottomNavigationItems[index].icon
                          : _loadGiverBottomNavigationItems[index].icon,
                      size: 26,
                    ),
                  ),
                  label: isDriver
                      ? _driverBottomNavigationItems[index].label
                      : _loadGiverBottomNavigationItems[index].label,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BottomNavigationItem {
  const _BottomNavigationItem({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;
}

import 'package:cargaapp_mobile/backend/services/auth_service.dart';
import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:cargaapp_mobile/widgets/common/common.dart';
import 'package:cargaapp_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class UserType {
  UserType({
    this.isPremium,
    required this.id,
    required this.name,
    required this.icon,
  });

  final String id;
  final String name;
  final IconData icon;
  bool? isPremium = false;
}

class UserTypeSelectionStep extends StatelessWidget {
  UserTypeSelectionStep({super.key});

  final TextEditingController _dniController = TextEditingController();

  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<AuthService>(context);

    void updateJsonUser(String key, String value) {
      _authService.jsonUser = {
        ..._authService.jsonUser,
        key: value,
      };
    }

    return RegistrationStep(
      title: 'Ingresa tus datos básicos',
      subtitle: '',
      child: Column(
        children: [
          TextFormField(
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
              hintText: 'DNI',
              prefixIcon: Icon(
                FontAwesomeIcons.idBadge,
                size: 24,
                color: AppTheme.dark.withOpacity(0.3),
              ),
            ),
            controller: _dniController,
            onChanged: (value) => updateJsonUser('dni', value),
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
          ),
          const SizedBox(height: AppTheme.padding / 2),
          TextFormField(
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Telefono Celular',
              prefixIcon: Icon(
                FontAwesomeIcons.squarePhone,
                size: 24,
                color: AppTheme.dark.withOpacity(0.3),
              ),
            ),
            controller: _phoneNumberController,
            onChanged: (value) => updateJsonUser('phone_number', value),
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
          ),
          const SizedBox(height: AppTheme.padding),
          SectionHeader(
            title: "¿Qué tipo de usuario eres?",
            hasPadding: false,
          ),
          const SizedBox(height: AppTheme.padding / 2),
          FutureBuilder(
            future: _authService.memberships.isEmpty
                ? _authService.getMemberships()
                : null,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (snapshot.hasData) {
                final memberships = snapshot.data ?? [];
                return Wrap(
                  spacing: AppTheme.padding,
                  runSpacing: AppTheme.padding,
                  children: [
                    ...List.generate(
                      memberships.length,
                      (index) => InkWell(
                        borderRadius:
                            BorderRadius.circular(AppTheme.defaultRadius),
                        onTap: () {
                          _authService.selectedMembership = memberships[index];
                          _authService.jsonUser = {
                            ..._authService.jsonUser,
                            'id_user_type': memberships[index].id,
                          };

                          // TODO: change to statless widget and use provider
                          // setState(() {});
                        },
                        child: Container(
                          height: 160,
                          width: MediaQuery.of(context).size.width / 2.5,
                          padding: const EdgeInsets.all(AppTheme.padding / 2),
                          decoration: BoxDecoration(
                            color: memberships[index].id ==
                                    _authService.selectedMembership?.id
                                ? AppTheme.secondary.withOpacity(0.4)
                                : AppTheme.dark.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(
                              AppTheme.defaultRadius,
                            ),
                            border: Border.all(
                              color: memberships[index].id ==
                                      _authService.selectedMembership?.id
                                  ? AppTheme.secondary
                                  : AppTheme.dark.withOpacity(0.04),
                              width: 3,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(
                              //   universities[index].icon,
                              //   size: 60,
                              //   color: Colors.pinkAccent,
                              // ),
                              SvgPicture.network(
                                memberships[index].iconURL ?? '',
                                width: 60,
                              ),
                              SizedBox(height: AppTheme.padding / 2),
                              Text(
                                memberships[index].name,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              }

              return Text("No hay datos pra mostrar");
            },
          ),
          SizedBox(height: AppTheme.padding),
          _authService.selectedMembership?.price != null
              ? Text(
                  "Este tipo de usuario necesita un pago de \n${_authService.selectedMembership?.price} ARS más adelante",
                  textAlign: TextAlign.center,
                  style: AppTheme.lightTheme.textTheme.bodyMedium!.copyWith(
                    color: Colors.black38,
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}

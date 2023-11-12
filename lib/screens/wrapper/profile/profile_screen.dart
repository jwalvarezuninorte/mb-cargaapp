import 'package:cargaapp_mobile/backend/models/subscription.dart';
import 'package:cargaapp_mobile/backend/models/user.dart';
import 'package:cargaapp_mobile/backend/services/auth_service.dart';
import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:cargaapp_mobile/utils/date.dart';
import 'package:cargaapp_mobile/utils/image.dart';
import 'package:cargaapp_mobile/utils/url_launcher.dart';
import 'package:cargaapp_mobile/widgets/base/Button.dart';
import 'package:cargaapp_mobile/widgets/common/bottomSheet.helper.dart';
import 'package:cargaapp_mobile/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool loadedProfileScreen = false;

  // late UserModel _user;
  // late AuthService _authService;

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   _authService = Provider.of<AuthService>(context, listen: false);
    //
    //   // session = authService.supabase.auth.currentSession;
    //   UserModel.fromUser(
    //     _authService.supabase.auth.currentUser as Supabase.User,
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = Provider.of<AuthService>(context);
    // final Supabase.User? _user = _authService.supabase.auth.currentUser;
    // final UserModel? _user = UserModel.fromUser(
    //   _authService.supabase.auth.currentUser as Supabase.User,
    // );

    final UserModel _user = _authService.user as UserModel;
    final Subscription _subscription = _authService.user!.subscription;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.base,
        title: Text("Mi perfil"),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed('/edit_profile'),
            icon: Icon(Iconsax.edit),
          ),
          IconButton(
            onPressed: () => _showBottomSheetUserOptions(context),
            icon: Icon(Iconsax.setting),
          ),
          SizedBox(width: AppTheme.padding / 2),
        ],
      ),
      body: SafeArea(
        child: Center(
            child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.padding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: AppTheme.padding),
              _ProfileHeader(user: _user),
              SizedBox(height: AppTheme.padding),
              Divider(color: AppTheme.dark.withOpacity(0.2)),
              SizedBox(height: AppTheme.padding),
              if (_subscription.isActive == false)
                EmptyContent(
                  message: 'Necesitas una suscripción\npara ver ofertas',
                  icon: Iconsax.receipt_item,
                  iconSize: 50,
                  buttonText: 'Suscribirme ahora',
                  onPressed: () {
                    Navigator.of(context).pushNamed('/membership_onboarding');
                  },
                )
              else
                _SubscriptionInfo(subscription: _subscription),
              Spacer(flex: 2),
            ],
          ),
        )),
      ),
    );
  }

  Future<void> _showBottomSheetUserOptions(BuildContext context) {
    final AuthService _authService = Provider.of<AuthService>(
      context,
      listen: false,
    );

    final bool isDriver =
        _authService.user?.subscription.membership.price != null;

    return showCustomBottomSheet(
      context: context,
      fullHeight: false,
      content: [
        SectionHeader(title: "Cuenta", hasPadding: false),
        Button(
          onPressed: () {
            Navigator.of(context).pushNamed('/edit_profile');
          },
          label: 'Editar',
          icon: Iconsax.edit,
        ),
        Button(
          onPressed: () async {
            final Uri emailLaunchUri = Uri(
              scheme: 'mailto',
              path: "support@cargaapp.com",
              query: UrlLauncher.encodeQueryParameters(
                <String, String>{
                  'subject': 'Reportar cuenta',
                  'body': 'Hola. Quiero reportar una cuenta...',
                },
              ),
            );
            await launchUrl(emailLaunchUri);
          },
          label: 'Reportar una cuenta',
          icon: Iconsax.judge,
        ),
        Button(
          onPressed: () {
            final _authServer = Provider.of<AuthService>(
              context,
              listen: false,
            );
            _authServer.supabase.auth.signOut();
          },
          label: 'Cerrar sesión',
          icon: Iconsax.logout,
        ),
        SizedBox(height: AppTheme.padding * 2),
        SectionHeader(title: "Otros", hasPadding: false),
        if (isDriver)
          Button(
            onPressed: () {},
            label: 'Cancelar suscripción',
            icon: Iconsax.ticket_expired,
          ),
        Button(
          onPressed: () {},
          label: 'Eliminar cuenta',
          icon: Iconsax.ticket_expired,
          color: Colors.red,
        ),
        SizedBox(height: AppTheme.padding * 2),
      ],
    );
  }
}

List subscriptionAttributes = [
  'Contactar al dador directamente',
  'Buscar y filtrar ofertas',
  'Agregar equipos',
  'Atención preferencial',
];

class _SubscriptionInfo extends StatelessWidget {
  const _SubscriptionInfo({
    required Subscription subscription,
  }) : _subscription = subscription;

  final Subscription _subscription;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.defaultRadius * 2),
            border: Border.all(
              width: 2,
              color: AppTheme.primary.withOpacity(0.2),
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppTheme.padding,
            vertical: AppTheme.padding,
          ),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Membresía:',
                style: AppTheme.lightTheme.textTheme.displayMedium!.copyWith(
                  color: AppTheme.dark.withOpacity(0.4),
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                _subscription.membership.name,
                style: AppTheme.lightTheme.textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppTheme.padding / 4),
              Text(
                _subscription.membership.price == null
                    ? 'Gratis'
                    : '${_subscription.membership.price} ARS/mes',
                style: AppTheme.lightTheme.textTheme.displayMedium!.copyWith(
                  color: AppTheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              _subscription.membership.price == null
                  ? Container()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: AppTheme.padding),
                        ...List.generate(
                          subscriptionAttributes.length,
                          (index) => Text(
                            '✅ ${subscriptionAttributes[index]}',
                            style: AppTheme.lightTheme.textTheme.headlineMedium!
                                .copyWith(
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ),
                        SizedBox(height: AppTheme.padding),
                        SectionHeader(
                            title: 'Proximo cobro', hasPadding: false),
                        SizedBox(height: AppTheme.padding / 6),
                        Text(
                          _subscription.lastSubscription
                                  ?.nextMonth()
                                  .readable() ??
                              '',
                          style: AppTheme.lightTheme.textTheme.displaySmall!
                              .copyWith(
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ],
                    )
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required UserModel user,
  }) : _user = user;

  final UserModel _user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileAvatar(
          userName: _user.name,
          showAddImageAction: true,
          imageUrl: _user.profilePhotoURL,
        ),
        SizedBox(width: AppTheme.padding),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_user.name.split(" ")[0]} ${_user.name.split(" ")[1]}',
              style: AppTheme.lightTheme.textTheme.displayMedium,
            ),
            Text(
              '${_user.email}',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            Text(
              'Teléfono: ${_user.phoneNumber}',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            Text(
              'DNI: ${_user.dni}',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}

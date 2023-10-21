import 'package:cargaapp_mobile/backend/services/auth_service.dart';
import 'package:cargaapp_mobile/backend/services/subscription_service.dart';
import 'package:cargaapp_mobile/screens/miscellany/full_screen_process_status.dart';
import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:provider/provider.dart';

class PayMembershipScreen extends StatefulWidget {
  const PayMembershipScreen({Key? key}) : super(key: key);

  @override
  State<PayMembershipScreen> createState() => PayMembershipScreenState();
}

class PayMembershipScreenState extends State<PayMembershipScreen> {
  bool isLightTheme = true;
  String cardNumber = '5120694470616271';
  String expiryDate = '11/25';
  String cardHolderName = 'APRO';
  String cvvCode = '123';
  bool isCvvFocused = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<AuthService>(context);

    final userEmail = _authService.user?.email as String;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Membresía a Carga App'),
            SizedBox(height: AppTheme.padding / 4),
            Text(
              "Suscripción con tarjeta de crédito",
              style: AppTheme.lightTheme.textTheme.headlineMedium!.copyWith(
                color: AppTheme.dark.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CreditCardWidget(
                    // cardType: CardType.mastercard,
                    cardNumber: cardNumber,
                    expiryDate: expiryDate,
                    cardHolderName: cardHolderName,
                    cvvCode: cvvCode,
                    bankName: ' ',
                    showBackView: isCvvFocused,
                    obscureCardNumber: true,
                    obscureCardCvv: false,
                    isHolderNameVisible: true,
                    cardBgColor: AppTheme.dark,
                    isSwipeGestureEnabled: false,
                    onCreditCardWidgetChange:
                        (CreditCardBrand creditCardBrand) {},
                  ),
                  CreditCardForm(
                    formKey: formKey,
                    cardNumber: cardNumber,
                    cvvCode: cvvCode,
                    cardHolderName: cardHolderName,
                    expiryDate: expiryDate,
                    inputConfiguration: const InputConfiguration(
                      cardNumberDecoration: InputDecoration(
                        labelText: 'Número de tarjeta',
                        hintText: 'XXXX XXXX XXXX XXXX',
                      ),
                      expiryDateDecoration: InputDecoration(
                        labelText: 'Fecha',
                        hintText: 'XX/XX',
                      ),
                      cvvCodeDecoration: InputDecoration(
                        labelText: 'CVV',
                        hintText: 'XXX',
                      ),
                      cardHolderDecoration: InputDecoration(
                        labelText: 'Nombre en tarjeta',
                      ),
                    ),
                    onCreditCardModelChange: onCreditCardModelChange,
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppTheme.padding / 2,
                    vertical: AppTheme.padding * 2,
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      isLoading = true;
                      setState(() {});

                      final subscriptionId = await _onValidate(
                        email: userEmail,
                        userId: _authService.user?.id as String,
                      );

                      ScreenArguments args;
                      if (subscriptionId == null) {
                        args = ScreenArguments(
                          'Error en transacción',
                          'Hubo un error al momento de procesar el pago. Por favor, verifica el estado de tu tarjeta y vuelve a intentar.',
                          Icons.error_outline,
                          true,
                          () {},
                          'Volver a intentar',
                          'Reportar un problema',
                          () {},
                        );
                      }

                      isLoading = false;
                      setState(() {});

                      args = ScreenArguments(
                        '¡Pago exitoso!',
                        'Te has suscrito a la membresía \ncorrectamente, puedes volver a la app.',
                        Icons.check_circle,
                        false,
                        () => Navigator.of(context).pushNamedAndRemoveUntil(
                          '/app',
                          (route) => false,
                        ),
                        'Volver a la app',
                        'Reportar un problema',
                        () {},
                      );

                      Navigator.of(context).pushNamed(
                        '/payment_status',
                        arguments: args,
                      );
                    },
                    child: isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: AppTheme.base,
                            ),
                          )
                        : Text('Pagar ~ 1600 ARS'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<String?> _onValidate({
    required String email,
    required String userId,
  }) async {
    final subscriptionService = SubscriptionService();

    if (formKey.currentState?.validate() ?? false) {
      try {
        final creditCard = CreditCardModel(
          cardNumber,
          expiryDate,
          cardHolderName,
          cvvCode,
          isCvvFocused,
        );

        final cardTokenId = await subscriptionService.createCardToken(
          creditCard,
        );

        // TODO: replace planId based on user.membership.id or something
        final subscriptionId = await subscriptionService.subscribeToPlan(
          planId: "2c9380848b2a4561018b32315c380432",
          cardTokenId: cardTokenId,
          email: email, //"test_user_1908242373@testuser.com",
          userId: userId,
        );

        if (subscriptionId.isNotEmpty) {
          //   TODO: navigate to subscription suscceful
          return subscriptionId;
        }

        return null;
      } catch (e) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('Hubo un error al verificar la tarjeta de crédito'),
            ),
          );
        return null;
      }
    } else {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Verifica los datos de la tarjeta'),
          ),
        );
      return null;
    }
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}

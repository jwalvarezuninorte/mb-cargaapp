import 'package:cargaapp_mobile/backend/models/subscription.dart';
import 'package:cargaapp_mobile/backend/services/api.dart';
import 'package:cargaapp_mobile/backend/services/supabase_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class SubscriptionService extends ChangeNotifier {
  final supabase = SupabaseConfig().supabase;
  Subscription? _subscription;

  Subscription? get subscription => _subscription;

  set subscription(Subscription? value) {
    _subscription = value;
    notifyListeners();
  }

  Future<String> createCardToken(CreditCardModel creditCard) async {
    try {
      final response = await dio.post(
        'https://api.mercadopago.com/v1/card_tokens',
        queryParameters: {"public_key": "<PUBLIC_KEY>"},
        data: {
          "card_number": creditCard.cardNumber,
          "cardholder": {
            "name": creditCard.cardHolderName,
            "identification": {"type": "CC", "number": "123456789"}
          },
          "security_code": creditCard.cvvCode,
          "expiration_year": '20' + creditCard.expiryDate.split('/')[1],
          "expiration_month": creditCard.expiryDate.split('/')[0]
        },
      );

      if (response.statusCode == 201) {
        return response.data['id'];
      }

      throw Exception('No se pudo crear el token de la TC');
    } catch (e) {
      print(e);
      throw Exception('Parece que hay un problema con tu tarjeta');
    }
  }

  Future<String> subscribeToPlan({
    required String planId,
    required String cardTokenId,
    required String email,
    required String userId,
  }) async {
    try {
      final response = await dio.post(
        'https://api.mercadopago.com/preapproval',
        data: {
          "back_url": "https://www.mercadopago.com.co",
          "status": "authorized",
          "card_token_id": cardTokenId,
          "preapproval_plan_id": planId,
          "payer_email": "test_user_1908242373@testuser.com",
        },
      );

      if (response.statusCode == 201) {
        final supabaseResponse = await supabase
            .from('subscriptions')
            .update({
              "mp_preapproval_id": response.data['id'],
              "is_active":
                  response.data['status'] == 'authorized' ? true : false,
              "last_subscription": DateTime.now().toUtc().toString(),
            })
            .eq('user_id', userId)
            .single();

        return response.data['id'];
      }

      throw Exception('No se pudo crear la suscripción');
    } catch (e) {
      print(e);
      throw Exception('Hubo un error al momento de hacer la suscripción');
    }
  }
}

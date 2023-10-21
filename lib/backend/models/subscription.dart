import 'package:cargaapp_mobile/backend/models/user.dart';

class Subscription {
  final String id;
  final Membership membership;
  final DateTime? lastSubscription;
  final bool isActive;

  Subscription({
    required this.id,
    required this.membership,
    required this.lastSubscription,
    required this.isActive,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      membership: Membership.fromJson(json['membership']),
      lastSubscription: json['last_subscription'] != null
          ? DateTime.parse(json['last_subscription'])
          : null,
      isActive: json['is_active'] ?? false,
    );
  }
}

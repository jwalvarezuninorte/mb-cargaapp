import 'package:cargaapp_mobile/backend/models/subscription.dart';

class MembershipResponse {
  final List<Membership> memberships;

  MembershipResponse({
    required this.memberships,
  });

  factory MembershipResponse.fromJson(Map<String, dynamic> json) =>
      MembershipResponse(
        memberships: List<Membership>.from(
          json["response"].map(
            (x) => Membership.fromJson(x),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "response": List<dynamic>.from(
          memberships.map(
            (x) => x.toJson(),
          ),
        ),
      };
}

class Membership {
  final String id;
  final String name;
  final double? price;
  final String? iconURL;

  // final DateTime createdAt;

  Membership({
    required this.id,
    required this.name,
    // required this.createdAt,
    required this.iconURL,
    this.price,
  });

  factory Membership.fromJson(Map<String, dynamic> membership) => Membership(
      id: membership['id'],
      name: membership['name'],
      price: membership['price'],
      iconURL: membership['icon_url']
      // createdAt: DateTime.parse(membership['created_at']),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "icon_url": iconURL,
      };
}

class UserModel {
  final String id;
  final String email;
  String name;
  String phoneNumber;
  String dni;
  Subscription subscription;

  String? profilePhotoURL;

  UserModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.dni,
    required this.subscription,
    required this.profilePhotoURL,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      dni: json['dni'],
      subscription: Subscription.fromJson(json['subscription']),
      profilePhotoURL: json['photo'],
      email: json['email'],
    );
  }
}

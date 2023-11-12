import 'dart:io';

import 'package:cargaapp_mobile/backend/models/subscription.dart';
import 'package:cargaapp_mobile/backend/services/supabase_config.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user.dart';

class AuthService extends ChangeNotifier {
  // new code
  final supabase = SupabaseConfig().supabase;
  User? _supaUser;

  UserModel? _user;

  User? get supaUser => this._supaUser;

  UserModel? get user => this._user;

  set user(UserModel? user) {
    this._user = user;
    notifyListeners();
  }

  set supaUser(User? user) {
    this._supaUser = user;
    notifyListeners();
  }

  updateUserSubscription(Subscription subscription) {
    _user?.subscription = subscription;
    notifyListeners();
  }

  // membership code
  List<Membership> _memberships = [];

  List<Membership> get memberships => _memberships;

  set memberships(List<Membership> value) {
    _memberships = value;
    notifyListeners();
  }

  Membership? _selectedMembership;

  Membership? get selectedMembership => _selectedMembership;

  set selectedMembership(Membership? value) {
    _selectedMembership = value;
    notifyListeners();
  }

  // old code
  Map<String, dynamic> _jsonUser = {}; // temporal user for register
  // UserModel? _user;

  Map<String, dynamic> get jsonUser => this._jsonUser;

  set jsonUser(Map<String, dynamic> jsonUser) {
    _jsonUser = jsonUser;
    notifyListeners();
  }

  Future<List<Membership>> getMemberships() async {
    final List<Map<String, dynamic>> response =
        await supabase.from('memberships').select();
    _memberships =
        List<Membership>.from(response.map((x) => Membership.fromJson(x)));

    return _memberships;
  }

  Future<User> register() async {
    final AuthResponse response = await supabase.auth.signUp(
      email: jsonUser["email"],
      password: jsonUser["password"],
      // TODO: Add additional data here (phone, address, dni, etc)
      data: {
        'dni': jsonUser["dni"],
        "phone_number": jsonUser["phone_number"],
        "id_user_type": jsonUser["id_user_type"],
        // "profile_photo_url": jsonUser["profile_photo_url"],
        "name": jsonUser["name"],
      },
    );

    final User? user = response.user;

    if (user == null) throw Exception("");

    if (user.userMetadata != null) {
      // _user = UserResponse.fromMap(response.data).user;
      // _user = await getUserDetail();

      return user;
    } else {
      throw Exception('Error al registrar usuario');
    }
  }

  Future<User> verify() async {
    final AuthResponse response = await supabase.auth.verifyOTP(
      type: OtpType.email,
      token: jsonUser["verification_code"],
      email: jsonUser["email"],
    );

    final User? user = response.user;

    if (user != null) {
      // _user = UserResponse.fromMap(response.data).user;
      return user;
    } else {
      throw Exception('Error al verificar usuario');
    }
  }

  Future<void> login({
    required String email,
    required String password,
    required String deviceToken,
  }) async {
    final AuthResponse response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final User? user = response.user;

    if (user != null && response.session != null) {
      _user = await getUserDetail();
      _supaUser = response.session!.user;
    } else {
      throw Exception('Error al registrar usuario');
    }
  }

  Future<UserModel> getUserDetail({String? id}) async {
    String userId = id ?? supabase.auth.currentSession!.user.id;

    final Map<String, dynamic> response = await supabase
        .from('users')
        .select('*, subscription:subscription_id'
            '(id, is_active, last_subscription, '
            'membership:membership_id(id, name, icon_url, price))')
        .eq('id', userId)
        .single();

    return UserModel.fromJson(response);
  }

  Future<void> logout() async {
    supabase.auth.signOut();
    // TODO: verify, i think notifyListeners is optional
    notifyListeners();
  }

  Future<void> updateProfilePicture({
    required PlatformFile profilePhoto,
  }) async {
    final File avatarFile = File(profilePhoto.path as String);

    String path;

    if (_user!.profilePhotoURL == null) {
      path = await supabase.storage.from('profile-photos').upload(
            'avatar1.png',
            avatarFile,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: false,
            ),
          );
    } else {
      path = await supabase.storage.from('profile-photos').update(
            'avatar1.png',
            avatarFile,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: false,
            ),
          );
    }

    if (path.isNotEmpty) {
      _user!.profilePhotoURL =
          "https://jxdroaxdrmeurapnjmdb.supabase.co/storage/v1/object/public/" +
              path;
      await supabase.from('users').update({
        'photo':
            "https://jxdroaxdrmeurapnjmdb.supabase.co/storage/v1/object/public/" +
                path,
      }).eq('id', _user!.id);

      notifyListeners();
    }
  }

  Future<bool> updateUserInfo({
    required String fullName,
    required String phoneNumber,
    required String dni,
  }) async {
    await supabase.from('users').update({
      'name': fullName,
      'phone_number': phoneNumber,
      'dni': dni,
    }).eq('id', _user!.id);

    _user!.name = fullName;
    _user!.phoneNumber = phoneNumber;
    _user!.dni = dni;

    notifyListeners();

    return true;
  }
}

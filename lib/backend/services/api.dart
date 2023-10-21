import 'package:cargaapp_mobile/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class API extends ChangeNotifier {}

Dio dio = Dio(
  BaseOptions(
    baseUrl: Constants.baseUrl,
    validateStatus: (status) {
      return status! < 500;
    },
    headers: <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
      // TODO: get this from .env file
      "Authorization": "Bearer <API_KEY_HERE>",
    },
  ),
);

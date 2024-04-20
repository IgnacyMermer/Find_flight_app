

import 'package:dio/dio.dart';
import 'package:lot_recrutation_app/Keys/Api.dart';

class TokenProvider{
  static String? token_;
  static DateTime? tokenCreatedTime_;

  static Future<String> createToken(Dio dio)async{
    final result = await dio.post('https://test.api.amadeus.com/v1/security/oauth2/token',
        options: Options(
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
          },
          //encoding: Encoding.getByName('utf-8'),
        ),
        data: {
          'grant_type': 'client_credentials',
          'client_id': apiKey,
          'client_secret': secretKey
        }
    );

    Map<String, dynamic> data = result.data;
    return data['access_token'];

  }
}
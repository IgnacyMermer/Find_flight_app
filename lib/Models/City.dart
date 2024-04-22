import 'package:dio/dio.dart';
import 'package:lot_recrutation_app/Providers/TokenProvider.dart';

class City{
  static Future<List<Map<String, String>>> getCities(String keyword)async{
    Dio dio = Dio();
    try {
      if(TokenProvider.token_==null){
        TokenProvider.token_ = await TokenProvider.createToken(dio);
        TokenProvider.tokenCreatedTime_=DateTime.now();
      }
      else if((TokenProvider.tokenCreatedTime_??DateTime(2023, 1, 1)).isBefore(DateTime.now().subtract(Duration(minutes: 30)))){
        TokenProvider.token_ = await TokenProvider.createToken(dio);
        TokenProvider.tokenCreatedTime_=DateTime.now();
      }

      final data = await dio.get(
          'https://test.api.amadeus.com/v1/reference-data/locations?subType=AIRPORT&keyword=${keyword}',
          options: Options(headers: {
            'Authorization': 'Bearer ${TokenProvider.token_}'
          }));
      List<dynamic> responseData = data.data['data'];
      List<Map<String, String>> cities = [];
      responseData.forEach((element) {
        cities.add({'name':'${element['name']} (${element['id']}) - ${element['address']['cityName']}',
          'id': '${element['id']}'});
      });
      return cities;
    }
    catch(e){
      print(e);
    }
    return [];
  }
}
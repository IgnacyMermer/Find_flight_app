
import 'package:dio/dio.dart';
import 'package:lot_recrutation_app/Models/Flight.dart';
import 'package:lot_recrutation_app/Models/FlightSegment.dart';
import 'package:lot_recrutation_app/Providers/TokenProvider.dart';

class Flights{
  static Future<List<Flight>> getFlights(String departureId, String arrivalId, String date,
      int adults, int children, int infants, int page)async{

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
      final result = await dio.get(
          'https://test.api.amadeus.com/v2/shopping/flight-offers?originLocationCode=${departureId
              .substring(1)}&destinationLocationCode=${arrivalId.substring(
              1)}&departureDate=${date}&adults=${adults}&children=${children}&infants=${infants}'
              '&nonStop=false&max=${page*10}',
          options: Options(headers: {
            'Authorization': 'Bearer ${TokenProvider.token_}'
          }));

      List<Flight> flights = [];

      List<dynamic> data = result.data['data'];
      data.forEach((element) {
        List<FlightSegment> segments = [];
        element['itineraries'][0]['segments'].forEach((elementSegm) {
          segments.add(
              FlightSegment(elementSegm['departure']['iataCode'].toString(),
                  elementSegm['departure']['terminal'].toString(),
                  elementSegm['departure']['at'].toString(),
                  elementSegm['arrival']['iataCode'].toString(),
                  elementSegm['arrival']['terminal'].toString(),
                  elementSegm['arrival']['at'].toString(),
                  elementSegm['duration'].toString(),
                  elementSegm['aircraft']['code'].toString()
              ));
        });

        flights.add(Flight(element['lastTicketingDate'], element['numberOfBookableSeats'],
            element['itineraries'][0]['duration'], element['price']['currency'], element['price']['total'],
            segments));
      });
      //gettingNewFlights=false;
      return flights;
    }
    catch(e){
      print(e);
      return [];
    }
  }
}
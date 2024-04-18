import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lot_recrutation_app/Models/Flight.dart';
import 'package:lot_recrutation_app/Models/FlightSegment.dart';
import 'package:lot_recrutation_app/Providers/HomePageProvider.dart';
import 'package:provider/provider.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  
  @override
  Widget build(BuildContext context) {
    final homePageProvider = Provider.of<HomePageProvider>(context);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        Navigator.of(context).pop();
      },
      child: Scaffold(
        body: Container(
          child: ListView(
            children: [

              SizedBox(height: 20),

              FutureBuilder(
                future: getFlights(homePageProvider.airportFromId??'', homePageProvider.airportToId??'',
                homePageProvider.oneFlightDate.toString().substring(0, 10), homePageProvider.adults),
                builder: ((BuildContext context, AsyncSnapshot<List<Flight>> snapshot){
                  if(snapshot.hasData){
                    return Container(
                      child: ListView(
                        shrinkWrap: true,
                        children: snapshot.data!.map((e) {
                          return Container(
                            child: Row(
                              children: [
                                Text(
                                  '${e.lastTicketingDate}'
                                ),
                                Text(
                                    '${e.segments[0].departureTime}'
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                  else{
                    return SpinKitFoldingCube(color: Colors.black,);
                  }
                })
              )

            ],
          ),
        ),
      ),
    );
  }


  Future<List<Flight>> getFlights(String departureId, String arrivalId, String date,
      int adults)async{

    print('alal');

    Dio dio = Dio();

    try {
      final result = await dio.get(
          'https://test.api.amadeus.com/v2/shopping/flight-offers?originLocationCode=${departureId
              .substring(1)}&destinationLocationCode=${arrivalId.substring(
              1)}&departureDate=${date}&adults=${adults}&nonStop=false&max=250',
          options: Options(headers: {
            'Authorization': 'Bearer Vabeg8tM7ulixLFhbGtg5onPyd0z'
          }));

      List<Flight> flights = [];

      List<dynamic> data = result.data['data'];
      data.forEach((element) {
        List<FlightSegment> segments = [];
        print(element['itineraries'][0]);
        element['itineraries'][0]['segments'].forEach((elementSegm) {
          segments.add(
              FlightSegment(elementSegm['departure']['iataCode'],
                  elementSegm['departure']['terminal'],
                  elementSegm['departure']['at'],
                  elementSegm['arrival']['iataCode'],
                  elementSegm['arrival']['Terminal'],
                  elementSegm['arrival']['at'],
                  elementSegm['duration']));
        });

        flights.add(Flight(element['lastTicketingDate'], element['numberOfBookableSeats'], segments));
      });

      return flights;
    }
    catch(e){
      print(e);
      return [];
    }
  }

}

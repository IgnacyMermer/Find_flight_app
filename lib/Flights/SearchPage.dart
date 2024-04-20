import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lot_recrutation_app/Models/Flight.dart';
import 'package:lot_recrutation_app/Models/FlightSegment.dart';
import 'package:lot_recrutation_app/Providers/FlightsProvider.dart';
import 'package:lot_recrutation_app/Providers/HomePageProvider.dart';
import 'package:lot_recrutation_app/Providers/TokenProvider.dart';
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
    final flightsProvider = Provider.of<FlightsProvider>(context);
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
                    //flightsProvider.flights=snapshot.data!;
                    return Container(
                      padding: EdgeInsets.all(20),
                      child: ListView(
                        shrinkWrap: true,
                        children: snapshot.data!.map((e) {
                          return Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(e.segments[0].departureTerminal??'',
                                          style: TextStyle(color: Colors.black))
                                    ),
                                    Expanded(
                                      child: Text(e.segments[e.segments.length-1].arrivalTerminal??'',
                                          style: TextStyle(color: Colors.black))
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Icon(
                                        Icons.airplanemode_active
                                      )
                                    ),
                                    Expanded(
                                      child: Text('Czas', style: TextStyle(color: Colors.black))
                                    ),
                                    Expanded(
                                      child: Icon(
                                        Icons.control_point_sharp
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text('Samolot typ', style: TextStyle(color: Colors.black))
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: (){

                                        },
                                        child: Text('Szczegóły lotu', style: TextStyle(color: Colors.black)),
                                      )
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text('Bilety dostępne do', style: TextStyle(color: Colors.black)),
                                        Text(e.lastTicketingDate, style: TextStyle(color: Colors.black))
                                      ]
                                    ),
                                    Column(
                                      children: [
                                        Text('Cena za jedną osobę', style: TextStyle(color: Colors.black)),
                                        Text('(Cena)', style: TextStyle(color: Colors.black))
                                      ],
                                    )
                                  ],
                                )
                              ],
                            )
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
              1)}&departureDate=${date}&adults=${adults}&nonStop=false&max=250',
          options: Options(headers: {
            'Authorization': 'Bearer ${TokenProvider.token_}'
          }));

      List<Flight> flights = [];
      print(result);

      List<dynamic> data = result.data['data'];
      data.forEach((element) {
        List<FlightSegment> segments = [];
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

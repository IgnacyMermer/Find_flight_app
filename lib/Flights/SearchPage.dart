import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lot_recrutation_app/Flights/FlightDetails.dart';
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

  late ScrollController scrollController;
  Future<List<Flight>>? flights;
  bool gettingNewFlights=false;
  
  int page = 1;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(()=>onScroll(context));
    final homePageProvider = Provider.of<HomePageProvider>(context, listen: false);
    flights = getFlights(homePageProvider.airportFromId??'', homePageProvider.airportToId??'',
        homePageProvider.oneFlightDate.toString().substring(0, 10), homePageProvider.adults);
  }

  void onScroll(BuildContext context) {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent&&(!gettingNewFlights)) {
      setState(() {
        gettingNewFlights=true;
        page+=1;
        final homePageProvider = Provider.of<HomePageProvider>(context, listen: false);
        flights = getFlights(homePageProvider.airportFromId??'', homePageProvider.airportToId??'',
            homePageProvider.oneFlightDate.toString().substring(0, 10), homePageProvider.adults);
      });
    }
  }

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
        appBar: AppBar(
          title: Text('Znalezione loty'),
        ),
        body: Container(
          child: ListView(
            controller: scrollController,
            children: [

              SizedBox(height: 20),

              FutureBuilder(
                future: flights,
                builder: ((BuildContext context, AsyncSnapshot<List<Flight>> snapshot){
                  if(snapshot.hasData){
                    //flightsProvider.flights=snapshot.data!;
                    return Container(
                      padding: EdgeInsets.all(20),
                      child: ListView(

                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        children: snapshot.data!.map((e) {
                          return Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: Column(
                              //shrinkWrap: true,
                              //physics: NeverScrollableScrollPhysics(),
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Icon(
                                              Icons.airplanemode_active
                                          ),
                                          Text(
                                            e.segments[0].departureTime.toString()
                                              .substring(0, 16).replaceAll('T', ' '),
                                            style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500),
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      )
                                    ),
                                    Expanded(
                                      child: Text('Czas: ${e.time.replaceAll('PT', '')} '
                                          '${e.segments.length>1?' - ${e.segments.length-1} ${e.segments.length-1==1?'przesiadka':'przesiadki'}':''}',
                                      style: TextStyle(color: Colors.black, fontSize: 17),
                                      textAlign: TextAlign.center)
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Icon(
                                              Icons.control_point_sharp
                                          ),
                                          Text(
                                            e.segments[e.segments.length-1].arrivalTime.toString()
                                                .substring(0, 16).replaceAll('T', ' '),
                                            style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500),
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      )
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text('Samolot typ: ${e.segments.map((element) {
                                        return element.airplaneType??'';
                                      })}',
                                        style: TextStyle(color: Colors.black, fontSize: 15))
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: (){
                                          flightsProvider.flightDetails=e;
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const FlightDetails()));
                                        },
                                        child: Text('Szczegóły lotu', style: TextStyle(color: Colors.white)),
                                      )
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                          children: [
                                            Text('Bilety dostępne do',
                                                style: TextStyle(color: Colors.black, fontSize: 18),
                                                textAlign: TextAlign.center),
                                            Text(e.lastTicketingDate,
                                                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
                                                textAlign: TextAlign.center)
                                          ]
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text('Cena za jedną osobę',
                                            style: TextStyle(color: Colors.black, fontSize: 18),
                                            textAlign: TextAlign.center),
                                          Text('${e.totalPrice} ${e.currency}',
                                              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
                                              textAlign: TextAlign.center)
                                        ],
                                      )
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
              1)}&departureDate=${date}&adults=${adults}&nonStop=false&max=${page*10}',
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
            element['itineraries'][0]['duration'], element['price']['base'],
            element['price']['currency'], element['price']['total'], segments));
      });
      gettingNewFlights=false;
      return flights;
    }
    catch(e){
      print(e);
      return [];
    }
  }

}

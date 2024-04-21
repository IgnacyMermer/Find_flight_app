import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lot_recrutation_app/Flights/FlightDetails.dart';
import 'package:lot_recrutation_app/Flights/Flights.dart';
import 'package:lot_recrutation_app/Models/Flight.dart';
import 'package:lot_recrutation_app/Models/FlightSegment.dart';
import 'package:lot_recrutation_app/Providers/FlightsProvider.dart';
import 'package:lot_recrutation_app/Providers/HomePageProvider.dart';
import 'package:lot_recrutation_app/Providers/TokenProvider.dart';
import 'package:provider/provider.dart';


class SearchPage extends StatefulWidget {
  final bool toTarget, oneWayFlight;
  final Future<List<Flight>> Function(String, String, String, int, int) getFlights;
  const SearchPage({super.key, required this.toTarget, required this.oneWayFlight,
  required this.getFlights});

  @override
  State<SearchPage> createState() => _SearchPageState();
}


class _SearchPageState extends State<SearchPage> {

  late ScrollController scrollController;
  Future<List<Flight>>? flights;

  int page = 1;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(()=>onScroll(context));
    final homePageProvider = Provider.of<HomePageProvider>(context, listen: false);
    flights = widget.getFlights(homePageProvider.airportFromId??'', homePageProvider.airportToId??'',
        (widget.oneWayFlight?homePageProvider.oneFlightDate:(widget.toTarget?homePageProvider.fromDate:
        homePageProvider.toDate)).toString().substring(0, 10), homePageProvider.adults, page);
  }

  void onScroll(BuildContext context) {
    final homePageProvider = Provider.of<HomePageProvider>(context, listen: false);
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent&&(!homePageProvider.gettingFlights)) {
      setState(() {
        homePageProvider.gettingFlights=true;
        page+=1;
        flights = widget.getFlights(homePageProvider.airportFromId??'', homePageProvider.airportToId??'',
            (widget.oneWayFlight?homePageProvider.oneFlightDate:(widget.toTarget?homePageProvider.fromDate:
            homePageProvider.toDate)).toString().substring(0, 10), homePageProvider.adults, page);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    return Container(
                      padding: EdgeInsets.all(20),
                      child: ListView(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        children: snapshot.data!.map((e) {
                          return Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            padding: EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          const Icon(
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
                                          const Icon(
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
                                          Navigator.of(context).push(MaterialPageRoute(builder:
                                              (context)=>FlightDetails(toTarget: widget.toTarget, getFlights: widget.getFlights)));
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
                                            const Text('Bilety dostępne do',
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
                                          const Text('Cena za jedną osobę',
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
                    return const SpinKitFoldingCube(color: Colors.black,);
                  }
                })
              )
            ],
          ),
        ),
      ),
    );
  }
}

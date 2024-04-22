import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lot_recrutation_app/Flights/FlightCard.dart';
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
  final Future<List<Flight>> Function(String, String, String, int, int, int, int) getFlights;
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
        homePageProvider.toDate))?.toString().substring(0, 10)??'', homePageProvider.adults, homePageProvider.children,
        homePageProvider.babies, page);
  }

  void onScroll(BuildContext context) {
    final homePageProvider = Provider.of<HomePageProvider>(context, listen: false);
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent&&(!homePageProvider.gettingFlights)) {
      setState(() {
        homePageProvider.gettingFlights=true;
        page+=1;
        flights = widget.getFlights(homePageProvider.airportFromId??'', homePageProvider.airportToId??'',
            (widget.oneWayFlight?homePageProvider.oneFlightDate:(widget.toTarget?homePageProvider.fromDate:
            homePageProvider.toDate)).toString().substring(0, 10), homePageProvider.adults, homePageProvider.children,
            homePageProvider.babies, page);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    if(snapshot.data!.length==0){
                      return Center(
                        child: Text('Nie znaleziono żadnych połączeń',
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.black),
                          textAlign: TextAlign.center),
                      );
                    }
                    return Container(
                      padding: EdgeInsets.all(20),
                      child: ListView(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        children: snapshot.data!.map((e) {
                          return FlightCard(flight: e, toTarget: widget.toTarget,
                              getFlights: widget.getFlights);
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

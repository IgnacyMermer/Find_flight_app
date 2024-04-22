import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lot_recrutation_app/Database/Database.dart';
import 'package:lot_recrutation_app/Flights/Flights.dart';
import 'package:lot_recrutation_app/Flights/SearchPage.dart';
import 'package:lot_recrutation_app/HomePage/AirportsFields.dart';
import 'package:lot_recrutation_app/HomePage/ChooseDatesRange.dart';
import 'package:lot_recrutation_app/HomePage/ChooseFlightDate.dart';
import 'package:lot_recrutation_app/HomePage/PassengersData.dart';
import 'package:lot_recrutation_app/Models/Flight.dart';
import 'package:lot_recrutation_app/Providers/FlightsProvider.dart';
import 'package:lot_recrutation_app/Providers/HomePageProvider.dart';
import 'package:lot_recrutation_app/Providers/TokenProvider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool oneWay = false;
  FocusNode focusNodeFromDate=FocusNode(), focusNodeToDate=FocusNode();
  TextEditingController flyFromController = new TextEditingController();
  TextEditingController flyToController = new TextEditingController();
  bool showFromWhereCities = false, showToWhereCities = false;
  DateTime lastCall = DateTime.now();
  Timer? timer;

  Future<List<Map<String, String>>>? cities;

  void flyFromListener(){
    timer?.cancel();
    timer = Timer(Duration(seconds: 1), ()
    {
      setState(() {
        showFromWhereCities = true;
        showToWhereCities = false;
        cities = getCities(flyFromController.text);
      });
    });
  }

  void flyToListener(){
    timer?.cancel();
    timer = Timer(Duration(seconds: 1), ()
    {
      setState(() {
        showFromWhereCities = false;
        showToWhereCities = true;
        cities = getCities(flyToController.text);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    flyFromController.addListener(flyFromListener);
    flyToController.addListener(flyToListener);
  }

  void changeSelectedManyWay(int position) {
    setState(() {
      oneWay = !oneWay;
    });
  }

  void removeFocuses(){
    focusNodeFromDate.unfocus();
    focusNodeToDate.unfocus();
    setState(() {
      showToWhereCities=false;
      showFromWhereCities=false;
    });
  }

  @override
  Widget build(BuildContext context) {

    final homePageProvider = Provider.of<HomePageProvider>(context);
    final flightsProvider = Provider.of<FlightsProvider>(context);

    void swapController(){
      setState(() {
        var temp = flyFromController.text;
        flyFromController.text=flyToController.text;
        flyToController.text=temp;
        String? tempId = homePageProvider.airportFromId;
        homePageProvider.airportFromId=homePageProvider.airportToId;
        homePageProvider.airportToId=tempId;
      });
    }


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
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [

              SizedBox(height: 20),

              Container(
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 300),
                      left: oneWay ? 0 : 180, // Assumes the container is 300px wide
                      right: oneWay ? 180 : 0,
                      child: Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white60,
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            onTap: () => changeSelectedManyWay(1),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                              alignment: Alignment.center,
                              child: Text(
                                "W jedną stronę",
                                style: TextStyle(color: Colors.black,
                                    fontSize: 20, fontWeight: FontWeight.w600
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => changeSelectedManyWay(2),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                              alignment: Alignment.center,
                              child: Text(
                                "W dwie strony",
                                style: TextStyle(color: Colors.black,
                                    fontSize: 20, fontWeight: FontWeight.w600
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AirportFields(focus1: focusNodeFromDate, focus2: focusNodeToDate,
                      flyFromController: flyFromController, flyToController: flyToController,
                      swapController: swapController),
                      oneWay?ChooseFlightDate(removeFocuses: removeFocuses)
                          :ChooseDatesRange(removeFocuses: removeFocuses),

                      PassengersData(removeFocuses: removeFocuses),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(10))
                        ),
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 60),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.all(15))
                          ),
                          onPressed: (){
                            Future<List<Flight>> getFlights(String departureId, String arrivalId, String date,
                                int adults, int children, int infants, int page)async {
                              final result = await Flights.getFlights(departureId, arrivalId, date, adults, children, infants, page);
                              homePageProvider.gettingFlights=false;
                              return result;

                            }
                            if(homePageProvider.airportFromId!=null&&
                                homePageProvider.airportToId!=null&&
                                ((oneWay&&homePageProvider.oneFlightDate!=null)||
                                    ((!oneWay)&&homePageProvider.toDate!=null&&
                                    homePageProvider.fromDate!=null))) {

                              flightsProvider.toAndFromFlights = !oneWay;
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      SearchPage(toTarget: true,
                                          oneWayFlight: oneWay, getFlights: getFlights)
                              ));
                            }
                          },
                          child: Text('Szukaj', style: TextStyle(fontSize: 25)))
                      )

                    ],
                  ),
                  showFromWhereCities?Container(
                    child: FutureBuilder(
                      future: cities,
                      builder: ((context, AsyncSnapshot<List<Map<String, String>>> snapshot){
                        return Positioned(
                            right: 20,
                            left: 20,
                            top: 90,
                            child: Container(
                              width: 140,
                              height: 200,
                              child: ListView(
                                shrinkWrap: true,
                                children: (snapshot.data??[]).map((e) {
                                  return GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        showFromWhereCities=false;
                                        showToWhereCities=false;
                                        flyFromController.text = e['name']!;
                                        homePageProvider.airportFromId=e['id']!;
                                      });
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      padding: EdgeInsets.all(5),
                                      child: Text(e['name']!,
                                        style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500))
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                        );
                      }),
                    ),
                  ):SizedBox(),
                  showToWhereCities?Container(
                    child: FutureBuilder(
                      future: cities,
                      builder: ((context, AsyncSnapshot<List<Map<String, String>>> snapshot){
                        return Positioned(
                            right: 20,
                            left: 20,
                            top: 215,
                            child: Container(
                              width: 140,
                              height: 200,
                              child: ListView(
                                shrinkWrap: true,
                                children: (snapshot.data??[]).map((e) {
                                  return GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        showFromWhereCities=false;
                                        showToWhereCities=false;
                                        flyToController.text = e['name']!;
                                        homePageProvider.airportToId=e['id']!;
                                      });
                                    },
                                    child: Container(
                                        width: 50,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        padding: EdgeInsets.all(5),
                                        child: Text(e['name']!,
                                          style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500))
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                        );
                      }),
                    ),
                  ):SizedBox(),
                ],
              ),
              SizedBox(height: 15),

              ElevatedButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.all(15))
                ),
                onPressed: (){
                  flightsProvider.toAndFromFlights = !oneWay;
                  Future<List<Flight>> getFlights(String departureId, String arrivalId, String date,
                      int adults, int children, int infants, int page)async {
                    await LocalDatabase.checkDatabase();
                    final result = await LocalDatabase.getData();
                    homePageProvider.gettingFlights=false;
                    return result;

                  }
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          SearchPage(toTarget: false, oneWayFlight: true,
                              getFlights: getFlights))
                  );

                },
                child: Text('Zapisane loty', style: TextStyle(fontSize: 25))
              )
            ],
          ),
        ),
      )
    );
  }

  Future<List<Map<String, String>>> getCities(String keyword)async{
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

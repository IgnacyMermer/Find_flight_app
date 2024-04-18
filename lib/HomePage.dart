import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lot_recrutation_app/Flights/SearchPage.dart';
import 'package:lot_recrutation_app/HomePage/AirportsFields.dart';
import 'package:lot_recrutation_app/HomePage/ChooseDatesRange.dart';
import 'package:lot_recrutation_app/HomePage/ChooseFlightDate.dart';
import 'package:lot_recrutation_app/HomePage/PassengersData.dart';
import 'package:lot_recrutation_app/Providers/HomePageProvider.dart';
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

  Future<List<Map<String, String>>>? cities;

  void flyFromListener(){
    setState(() {
      showFromWhereCities=true;
      showToWhereCities=false;
      cities = getCities(flyFromController.text);
    });
  }

  void flyToListener(){
    setState(() {
      showFromWhereCities=false;
      showToWhereCities=true;
      cities = getCities(flyToController.text);
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
                          color: Colors.blue,
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
                                style: TextStyle(color: Colors.white,
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
                                style: TextStyle(color: Colors.white,
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
                      SizedBox(height: 20),
                      oneWay?ChooseFlightDate(removeFocuses: removeFocuses)
                          :ChooseDatesRange(removeFocuses: removeFocuses),

                      PassengersData(),

                      ElevatedButton(
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const SearchPage()));
                        },
                        child: Text('Szukaj'))

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
                                      child: Text(e['name']!, style: TextStyle(color: Colors.black))
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
                                        print(homePageProvider.airportToId);
                                        print('homePageProvider.airportToId');
                                        print(e['id']);
                                      });
                                    },
                                    child: Container(
                                        width: 50,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Text(e['name']!, style: TextStyle(color: Colors.black))
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
            ],
          ),
        ),
      )
    );
  }

  Future<List<Map<String, String>>> getCities(String keyword)async{
    Dio dio = Dio();
    try {
      final data = await dio.get(
          'https://test.api.amadeus.com/v1/reference-data/locations?subType=AIRPORT&keyword=${keyword}',
          options: Options(headers: {
            'Authorization': 'Bearer ouNuCGGcAcYyy83i6Z9BabUtIwpP'
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

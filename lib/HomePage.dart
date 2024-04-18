import 'package:flutter/material.dart';
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

  void changeSelectedManyWay(int position) {
    setState(() {
      oneWay = !oneWay;
    });
  }

  void removeFocuses(){
    focusNodeFromDate.unfocus();
    focusNodeToDate.unfocus();
  }

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

              AirportFields(focus1: focusNodeFromDate, focus2: focusNodeToDate),

              oneWay?ChooseFlightDate(removeFocuses: removeFocuses)
                  :ChooseDatesRange(removeFocuses: removeFocuses),

              PassengersData()

            ],
          ),
        ),
      )
    );
  }
}

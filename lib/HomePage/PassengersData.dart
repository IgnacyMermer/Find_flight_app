import 'package:flutter/material.dart';
import 'package:lot_recrutation_app/Providers/HomePageProvider.dart';
import 'package:provider/provider.dart';

class PassengersData extends StatelessWidget {
  final void Function() removeFocuses;
  const PassengersData({super.key, required this.removeFocuses});

  @override
  Widget build(BuildContext context) {
    final homePageProvider = Provider.of<HomePageProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white60,
      ),
      padding: EdgeInsets.all(20),
      child: ElevatedButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.all(15))
        ),
        child: Text('Dane podróżnych', style: TextStyle(fontSize: 25)),
        onPressed: ()async{

          removeFocuses();

          Map<String, int> userChosenPassengersData = await passengersDataConfigurator(context, {'adults': homePageProvider.adults,
            'teenagers': homePageProvider.teenagers, 'children': homePageProvider.children,
            'babies': homePageProvider.babies, 'flightClass': homePageProvider.flightClass_});

          homePageProvider.adults=userChosenPassengersData['adults']!;
          homePageProvider.teenagers=userChosenPassengersData['teenagers']!;
          homePageProvider.children=userChosenPassengersData['children']!;
          homePageProvider.babies=userChosenPassengersData['babies']!;
          homePageProvider.flightClass=userChosenPassengersData['flightClass']!;

        },
      ),
    );
  }

  Future<Map<String, int>> passengersDataConfigurator(BuildContext context, Map<String, int> chosenPassengersData) async{
    Map<String, int> editablePassengerData=chosenPassengersData;
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState){
            return Container(
              padding: EdgeInsets.all(15),
              height: 1000,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Wybierz klasę podróży i ilość pasażerów', style: Theme.of(context).textTheme.headline6),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                    child: Row(
                      children: [
                        Icon(Icons.person),
                        Expanded(
                          child:Column(
                            children: [
                              Text('Dorośli'),
                              Text('powyżej 16 lat')
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: (){
                              if(editablePassengerData['adults']!=0){
                                setState((){
                                  editablePassengerData['adults']=editablePassengerData['adults']!-1;
                                });
                              }
                            },
                            icon: Icon(Icons.remove)
                        ),
                        Text(editablePassengerData['adults'].toString()),
                        IconButton(
                            onPressed: (){
                              setState((){
                                editablePassengerData['adults']=editablePassengerData['adults']!+1;
                              });
                            },
                            icon: Icon(Icons.add)
                        ),

                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                    child: Row(
                      children: [
                        Icon(Icons.person),
                        Expanded(
                          child:Column(
                            children: [
                              Text('Nastolatkowie'),
                              Text('12-16 lat')
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: (){
                              if(editablePassengerData['teenagers']!=0){
                                setState((){
                                  editablePassengerData['teenagers']=editablePassengerData['teenagers']!-1;
                                });
                              }
                            },
                            icon: Icon(Icons.remove)
                        ),
                        Text(editablePassengerData['teenagers'].toString()),
                        IconButton(
                            onPressed: (){
                              setState((){
                                editablePassengerData['teenagers']=editablePassengerData['teenagers']!+1;
                              });
                            },
                            icon: Icon(Icons.add)
                        ),

                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                    child: Row(
                      children: [
                        Icon(Icons.person),
                        Expanded(
                          child:Column(
                            children: [
                              Text('Dzieci'),
                              Text('2-12 lat')
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: (){
                              if(editablePassengerData['children']!=0){
                                setState((){
                                  editablePassengerData['children']=editablePassengerData['children']!-1;
                                });
                              }
                            },
                            icon: Icon(Icons.remove)
                        ),
                        Text(editablePassengerData['children'].toString()),
                        IconButton(
                            onPressed: (){
                              setState((){
                                editablePassengerData['children']=editablePassengerData['children']!+1;
                              });
                            },
                            icon: Icon(Icons.add)
                        ),

                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                    child: Row(
                      children: [
                        Icon(Icons.person),
                        Expanded(
                          child:Column(
                            children: [
                              Text('Niemowlęta'),
                              Text('poniżej 2 lat')
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: (){
                              if(editablePassengerData['babies']!=0){
                                setState((){
                                  editablePassengerData['babies']=editablePassengerData['babies']!-1;
                                });
                              }
                            },
                            icon: Icon(Icons.remove)
                        ),
                        Text(editablePassengerData['babies'].toString()),
                        IconButton(
                            onPressed: (){
                              setState((){
                                editablePassengerData['babies']=editablePassengerData['babies']!+1;
                              });
                            },
                            icon: Icon(Icons.add)
                        ),

                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: editablePassengerData['flightClass']==1?MaterialStateProperty.all(Colors.white)
                                      :MaterialStateProperty.all(Colors.transparent),
                                  foregroundColor: editablePassengerData['flightClass']==1?MaterialStateProperty.all(Colors.black)
                                      :MaterialStateProperty.all(Colors.white)
                              ),
                              child: Text('Klasa economy', style: TextStyle(fontSize: 11)),
                              onPressed: (){
                                setState((){
                                  if(editablePassengerData['flightClass']==1){
                                    editablePassengerData['flightClass']=-1;
                                  }
                                  else {
                                    editablePassengerData['flightClass'] = 1;
                                  }
                                });
                              },
                            )
                        ),
                        Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: editablePassengerData['flightClass']==2?MaterialStateProperty.all(Colors.white)
                                    :MaterialStateProperty.all(Colors.transparent),
                                foregroundColor: editablePassengerData['flightClass']==2?MaterialStateProperty.all(Colors.black)
                                    :MaterialStateProperty.all(Colors.white)
                              ),
                              child: Text('Klasa premium economy', style: TextStyle(fontSize: 11)),
                              onPressed: (){
                                setState((){
                                  if(editablePassengerData['flightClass']==2){
                                    editablePassengerData['flightClass']=-1;
                                  }
                                  else {
                                    editablePassengerData['flightClass'] = 2;
                                  }
                                });
                              },
                            )
                        ),
                        Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: editablePassengerData['flightClass']==3?MaterialStateProperty.all(Colors.white)
                                      :MaterialStateProperty.all(Colors.transparent),
                                  foregroundColor: editablePassengerData['flightClass']==3?MaterialStateProperty.all(Colors.black)
                                      :MaterialStateProperty.all(Colors.white)
                              ),
                              child: Text('Klasa bisnes', style: TextStyle(fontSize: 11)),
                              onPressed: (){
                                setState((){
                                  if(editablePassengerData['flightClass']==3){
                                    editablePassengerData['flightClass']=-1;
                                  }
                                  else {
                                    editablePassengerData['flightClass'] = 3;
                                  }
                                });
                              },
                            )
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        );
      },
    );
    return editablePassengerData;
  }

}

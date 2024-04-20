import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lot_recrutation_app/Models/Flight.dart';
import 'package:lot_recrutation_app/Providers/FlightsProvider.dart';
import 'package:provider/provider.dart';

class FlightDetails extends StatefulWidget {
  const FlightDetails({super.key});

  @override
  State<FlightDetails> createState() => _FlightDetailsState();
}

class _FlightDetailsState extends State<FlightDetails> {
  @override
  Widget build(BuildContext context) {
    final flightsProvider = Provider.of<FlightsProvider>(context);
    Flight? flight = flightsProvider.flightDetails;
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
          title: Text('Szczegóły'),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [
              Text('Trasa', 
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.black),
                  textAlign: TextAlign.center),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(flight?.segments[0].departureCode??'',
                            style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center),
                        Text(flight?.segments[0].departureTime?.substring(0, 16).replaceAll('T', ' ')??'',
                            style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center),
                        Text('Terminal: ${flight?.segments[0].departureTerminal}',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        textAlign: TextAlign.center)
                      ],
                    )
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Icon(Icons.arrow_right_alt_outlined, size: 50, color: Colors.black),
                        Text('${(flight?.segments.length??1)==2?((flight?.segments.length??1)-1).toString():''} '
                            '${(flight?.segments.length??1)==1?'':(flight?.segments.length==2?'przesiadka': 'przesiadki')}',
                        style: TextStyle(color: Colors.black, fontSize: 20)),
                        ElevatedButton(
                          onPressed: ()async{
                            await showToureDetails(context, flight);
                          },
                          child: Text('Szczegóły')
                        )
                      ],
                    )
                  ),
                  Expanded(
                      child: Column(
                        children: [
                          Text(flight?.segments[(flight.segments.length)-1].arrivalCode??'',
                              style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center),
                          Text(flight?.segments[(flight.segments.length)-1].arrivalTime?.substring(0, 16).replaceAll('T', ' ')??'',
                              style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center),
                          Text('Terminal: ${flight?.segments[flight.segments.length-1].arrivalTerminal}',
                              style: TextStyle(color: Colors.black, fontSize: 16),
                              textAlign: TextAlign.center)
                        ],
                      )
                  )
                ],
              ),

              SizedBox(height: 10),

              Text('Cena (jedna osoba dorosła): ${flight?.price??'0'} ${flight?.currency??'EUR'}',
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500)),

              SizedBox(height: 10),

              Text('Wartość biletów: ${flight?.totalPrice??'0'} ${flight?.currency??'EUR'}',
                  style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500)),

              SizedBox(height: 5),

              Text((flight?.numberOfBookableSeats??0)==0?'Niedostępne':'Dostępne jeszcze: ${flight?.numberOfBookableSeats} '
                  '${flight?.numberOfBookableSeats==1?'bilet':((flight?.numberOfBookableSeats??0)<5?'bilety':'biletów')}',
              style: TextStyle(color: Colors.black, fontSize: 16))

            ],
          ),
        ),

      ),
    );
  }

  Future<void> showToureDetails(BuildContext context, Flight? flight)async{
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context){
        return Container(
          height: 800,
          padding: EdgeInsets.all(20),
          child: ListView(
            shrinkWrap: true,
            children: flight!=null?flight.segments.map((e) {
              return Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text('Lotnisko - Wylot'),
                              Text('${e.departureCode}-${e.departureTerminal}')
                            ],
                          )
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text('Wylot'),
                              Text('${e.departureTime?.substring(0,16).replaceAll('T', ' ')}')
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                              children: [
                                Text('Lotnisko - Przylot'),
                                Text('${e.arrivalCode}-${e.arrivalTerminal}')
                              ],
                            )
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text('Przylot'),
                              Text('${e.arrivalTime?.substring(0,16).replaceAll('T', ' ')}')
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Divider(height: 2, thickness: 10,),
                    SizedBox(height: 20),
                  ],
                ),
              );
            }).toList():[],
          ),
        );
      }
    );
  }
}

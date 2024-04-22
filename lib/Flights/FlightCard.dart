import 'package:flutter/material.dart';
import 'package:lot_recrutation_app/Flights/FlightDetails.dart';
import 'package:lot_recrutation_app/Models/Flight.dart';
import 'package:lot_recrutation_app/Providers/FlightsProvider.dart';
import 'package:provider/provider.dart';

class FlightCard extends StatelessWidget {
  final Flight flight;
  final bool toTarget;
  final Future<List<Flight>> Function(String, String, String, int, int, int, int) getFlights;
  const FlightCard({super.key, required this.flight, required this.toTarget,
    required this.getFlights});

  @override
  Widget build(BuildContext context) {
    final flightsProvider = Provider.of<FlightsProvider>(context);
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
                          flight.segments[0].departureTime.toString()
                              .substring(0, 16).replaceAll('T', ' '),
                          style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        )
                      ],
                    )
                ),
                Expanded(
                    child: Text('Czas: ${flight.time.replaceAll('PT', '')} '
                        '${flight.segments.length>1?' - ${flight.segments.length-1} '
                        '${flight.segments.length-1==1?'przesiadka':'przesiadki'}':''}',
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
                          flight.segments[flight.segments.length-1].arrivalTime.toString()
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
                    child: Text('Samolot typ: ${flight.segments.map((element) {
                      return element.airplaneType??'';
                    })}',
                        style: TextStyle(color: Colors.black, fontSize: 15))
                ),
                Expanded(
                    child: ElevatedButton(
                      onPressed: (){
                        flightsProvider.flightDetails=flight;
                        Navigator.of(context).push(MaterialPageRoute(builder:
                            (context)=>FlightDetails(toTarget: toTarget, getFlights: getFlights)));
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
                        Text(flight.lastTicketingDate,
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
                        Text('${flight.totalPrice} ${flight.currency}',
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
  }
}

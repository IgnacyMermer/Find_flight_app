import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          child: ListView(
            children: [

            ],
          ),
        ),

      ),
    );
  }
}

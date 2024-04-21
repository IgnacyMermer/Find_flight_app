import 'package:flutter/material.dart';

class SavesFlights extends StatefulWidget {
  const SavesFlights({super.key});

  @override
  State<SavesFlights> createState() => _SavesFlightsState();
}

class _SavesFlightsState extends State<SavesFlights> {
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
          title: Text('Zapisane loty'),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [

            ],
          ),
        ),
      )
    );
  }
}

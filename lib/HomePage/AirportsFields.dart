import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lot_recrutation_app/Providers/HomePageProvider.dart';
import 'package:provider/provider.dart';

class AirportFields extends StatelessWidget {
  TextEditingController flyFromController, flyToController;
  FocusNode focus1, focus2;
  final void Function() swapController;
  AirportFields({required this.focus1, required this.focus2, required this.flyFromController,
  required this.flyToController, required this.swapController});
  //const AirportFields({super.key});

  @override
  Widget build(BuildContext context) {
    final homePageProvider = Provider.of<HomePageProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          //Expanded(
            //child: Column(
              //children: [
                TextFormField(
                  focusNode: focus1,
                  style: TextStyle(fontSize: 20,color: Colors.blueGrey[800]),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    labelText: 'Skąd',
                    filled: true,
                    labelStyle: TextStyle(color: Colors.blueGrey[800]),
                  ),
                  controller: flyFromController,
                ),
              //],
            //)
          //),
          IconButton(
              onPressed: (){
                swapController();
              },
              icon: Icon(Icons.swap_horizontal_circle, size: 40,)
          ),
          //Expanded(
            //child:
            TextFormField(
              focusNode: focus2,
              style: TextStyle(fontSize: 20,color: Colors.blueGrey[800]),
              decoration: InputDecoration(
                fillColor: Colors.white,
                labelText: 'Dokąd',
                filled: true,
                labelStyle: TextStyle(color: Colors.blueGrey[800]),
              ),
              controller: flyToController,
            ),
          //),
        ],
      ),
    );
  }
}

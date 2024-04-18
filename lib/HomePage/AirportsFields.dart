import 'package:flutter/material.dart';
import 'package:lot_recrutation_app/Providers/HomePageProvider.dart';
import 'package:provider/provider.dart';

class AirportFields extends StatelessWidget {
  FocusNode focus1, focus2;
  AirportFields({required this.focus1, required this.focus2});
  //const AirportFields({super.key});

  @override
  Widget build(BuildContext context) {
    final homePageProvider = Provider.of<HomePageProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              focusNode: focus1,
              style: TextStyle(fontSize: 20,color: Colors.blueGrey[800]),
              decoration: InputDecoration(
                fillColor: Colors.white,
                labelText: 'Skąd',
                filled: true,
                labelStyle: TextStyle(color: Colors.blueGrey[800]),
              ),
              controller: homePageProvider.flyFromController,
            ),
          ),
          IconButton(
              onPressed: (){
                String temp = homePageProvider.flyFromController.text;
                homePageProvider.flyFromController = TextEditingController.fromValue(TextEditingValue(text: homePageProvider.flyToController_.text));
                homePageProvider.flyToController = TextEditingController.fromValue(TextEditingValue(text: temp));
              },
              icon: Icon(Icons.swap_horizontal_circle, size: 40,)
          ),
          Expanded(
            child: TextFormField(
              focusNode: focus2,
              style: TextStyle(fontSize: 20,color: Colors.blueGrey[800]),
              decoration: InputDecoration(
                fillColor: Colors.white,
                labelText: 'Dokąd',
                filled: true,
                labelStyle: TextStyle(color: Colors.blueGrey[800]),
              ),
              controller: homePageProvider.flyToController,
            ),
          ),
        ],
      ),
    );
  }
}

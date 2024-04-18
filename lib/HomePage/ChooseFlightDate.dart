import 'package:flutter/material.dart';
import 'package:lot_recrutation_app/Providers/HomePageProvider.dart';
import 'package:provider/provider.dart';

class ChooseFlightDate extends StatelessWidget {
  //const ChooseFlightDate({super.key});
  final void Function() removeFocuses;
  ChooseFlightDate({required this.removeFocuses});

  @override
  Widget build(BuildContext context) {
    final homePageProvider = Provider.of<HomePageProvider>(context);
    return Placeholder(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        padding: EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: ()async{
              //FocusScope.of(context).unfocus();
              removeFocuses();
              DateTime? newOneFlightDate = await pickFromDate(context, homePageProvider.oneFlightDate);
              homePageProvider.oneFlightDate=newOneFlightDate;
            },
            child: Text(homePageProvider.oneFlightDate!=null?homePageProvider.oneFlightDate?.toLocal().toString().substring(0,10)??'':'Data wylotu'),
          )
      ),
    );
  }

  Future<DateTime?> pickFromDate(BuildContext context, DateTime? date)async{
    final DateTime? picked = await showDatePicker(
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)),
        context: context,
        initialDate: date??DateTime.now()
    );

    if (picked != null &&
        picked != date) {
        date=picked;
    }
    return date;
  }
}

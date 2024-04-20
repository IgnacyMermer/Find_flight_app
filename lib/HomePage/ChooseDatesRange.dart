import 'package:flutter/material.dart';
import 'package:lot_recrutation_app/Providers/HomePageProvider.dart';
import 'package:provider/provider.dart';

class ChooseDatesRange extends StatelessWidget {
  //final Future<Map<String, DateTime?>> Function(BuildContext context, DateTime? fromDate, DateTime? toDate) pickDateRange;
  final void Function() removeFocuses;
  ChooseDatesRange({required this.removeFocuses});
  //ChooseDatesRange({super.key});

  @override
  Widget build(BuildContext context) {
    final homePageProvider = Provider.of<HomePageProvider>(context);
    return Container(
        decoration: BoxDecoration(
          color: Colors.white60,
        ),
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(15))
                  ),
                  onPressed: ()async{
                    FocusScope.of(context).unfocus();
                    removeFocuses();
                    Map<String, DateTime?> map = await pickDateRange(context, homePageProvider.fromDate, homePageProvider.toDate);
                    homePageProvider.fromDate=map['fromDate'];
                    homePageProvider.toDate=map['toDate'];
                  },
                  child: Text(homePageProvider.fromDate!=null?homePageProvider.fromDate?.toLocal().toString().substring(0,10)??'':'Data wylotu',
                      style: TextStyle(fontSize: 20)),
                )
            ),
            Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(15))
                  ),
                  onPressed: ()async{
                    FocusScope.of(context).unfocus();
                    removeFocuses();
                    Map<String, DateTime?> map = await pickDateRange(context, homePageProvider.fromDate, homePageProvider.toDate);
                    homePageProvider.fromDate=map['fromDate'];
                    homePageProvider.toDate=map['toDate'];
                  },
                  child: Text(homePageProvider.toDate!=null?homePageProvider.toDate?.toLocal().toString().substring(0,10)??'':'Data wylotu',
                      style: TextStyle(fontSize: 20)),
                )
            )
          ],
        ),

    );
  }

  Future<Map<String, DateTime?>> pickDateRange(BuildContext context, DateTime? fromDate, DateTime? toDate)async{
    final DateTimeRange? picked = await showDateRangePicker(
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      initialDateRange: fromDate!=null&&toDate!=null?DateTimeRange(start: fromDate??DateTime.now(), end: toDate??DateTime.now())
      :null,
      context: context,
      barrierColor: Colors.black,

    );

    DateTime? newFromDate = fromDate, newToDate = toDate;
    if (picked != null) {
      newFromDate=picked.start;
      newToDate = picked.end;
    }
    return {'fromDate': newFromDate, 'toDate': newToDate};
  }
}

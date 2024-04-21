import 'package:lot_recrutation_app/Models/Flight.dart';
import 'package:lot_recrutation_app/Models/FlightSegment.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class LocalDatabase{

  static Database? database;

  static Future<void> checkDatabase()async{
    if(database==null){
      //var databasesPath = await getDatabasesPath();

      database  = await openDatabase('lot.db', version: 1,
          onCreate: (Database db, int version) async {
            await db.execute(
                'CREATE TABLE SAVES (id TEXT, lastTicketingDate TEXT, '
                    'time TEXT, price TEXT, currency TEXT, totalPrice TEXT, numberOfBookableSeats INTEGER)');
            await db.execute('CREATE TABLE SAVES_SEGMENTS(id INTEGER, departureCode TEXT, departureTerminal TEXT, '
                'departureTime TEXT, arrivalCode TEXT, arrivalTerminal TEXT, arrivalTime TEXT, duration TEXT, '
                'airplaneType TEXT)');
          });
    }
  }

  static Future<void> insertFlight(Flight? flight)async{

    var uuid = Uuid();
    String id = uuid.v4();

    await database?.rawInsert('INSERT INTO SAVES(id, lastTicketingDate, time, price, currency, '
        'totalPrice, numberOfBookableSeats) VALUES (?, ?, ?, ?, ?, ?, ?)', [id, flight?.lastTicketingDate,
    flight?.time, flight?.price, flight?.currency, flight?.totalPrice, flight?.numberOfBookableSeats]);

    for(int i=0; i<(flight?.segments.length??0); i++){
      var segment = flight?.segments[i];
      await database?.rawInsert('INSERT INTO SAVES_SEGMENTS(id, departureCode, departureTerminal, '
          'departureTime, arrivalCode, arrivalTerminal, arrivalTime, duration, '
          'airplaneType) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)', [id, segment?.departureCode, segment?.departureTerminal,
          segment?.departureTime, segment?.arrivalCode, segment?.arrivalTerminal, segment?.arrivalTime,
          segment?.duration, segment?.airplaneType]);
    }

  }

  static Future<List<Flight>> getData()async{
    final result = await database?.rawQuery('SELECT * FROM SAVES');
    final resultSegments = await database?.rawQuery('SELECT * FROM SAVES_SEGMENTS');
    List<Flight> flights = [];
    print('result');
    print(result);
    print(resultSegments);
    result?.forEach((element) {
      List<FlightSegment> segments = [];
      String id = element['id'].toString();
      print(id);
      resultSegments?.forEach((elementSegm) {
        if(elementSegm['id'].toString()==id) {
          segments.add(
              FlightSegment(
                  elementSegm['departureCode'].toString(),
                  elementSegm['departureTerminal'].toString(),
                  elementSegm['departureTime'].toString(),
                  elementSegm['arrivalCode'].toString(),
                  elementSegm['arrivalTerminal'].toString(),
                  elementSegm['arrivalTime'].toString(),
                  elementSegm['duration'].toString(),
                  elementSegm['airplaneType'].toString()
              ));
        }
      });

      if(segments.length!=0) {
        flights.add(Flight(
            element['lastTicketingDate'].toString(),
            int.parse(element['numberOfBookableSeats'].toString()),
            element['time'].toString(),
            element['price'].toString(),
            element['currency'].toString(),
            element['totalPrice'].toString(),
            segments));
      }
    });
    return flights;

  }

}
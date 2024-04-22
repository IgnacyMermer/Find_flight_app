import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:lot_recrutation_app/Database/Database.dart';
import 'package:lot_recrutation_app/Flights/Flights.dart';
import 'package:lot_recrutation_app/Models/City.dart';
import 'package:lot_recrutation_app/Models/Flight.dart';


void main() {
  setUpAll(() => HttpOverrides.global = null);

  test('checkIfFindAirports', ()async{
    List<Map<String, String>> airports = await City.getCities('london');
    expect(airports.isNotEmpty, true);
    expect(airports[0]['name'], 'HEATHROW (ALHR) - LONDON');
    String airportId1=airports[0]['id']??'';
    expect(airportId1=='ALHR', true);
    sleep(Duration(seconds: 1));
    airports = await City.getCities('Rome');
    expect(airports.isNotEmpty, true);
    expect(airports[0]['name'], 'FIUMICINO (AFCO) - ROME');
    String airportId2=airports[0]['id']??'';
    expect(airportId2=='AFCO', true);
  });


  test('notEmptyListsFlights', () async {
    sleep(Duration(seconds: 1));
    List<Map<String, String>> airports = await City.getCities('london');
    expect(airports.isNotEmpty, true);
    expect(airports[0]['name'], 'HEATHROW (ALHR) - LONDON');
    String airportId1=airports[0]['id']??'';
    sleep(Duration(seconds: 1));
    airports = await City.getCities('Rome');
    expect(airports.isNotEmpty, true);
    expect(airports[0]['name'], 'FIUMICINO (AFCO) - ROME');
    String airportId2=airports[0]['id']??'';

    final result = await Flights.getFlights(airportId1, airportId2, '2024-04-24', 1, 1, 0, 1);
    expect(result.isNotEmpty, true);
  });


  test('result page test', () async {
    List<Map<String, String>> airports = await City.getCities('london');
    expect(airports.isNotEmpty, true);
    expect(airports[0]['name'], 'HEATHROW (ALHR) - LONDON');
    String airportId1=airports[0]['id']??'';
    airports = await City.getCities('Rome');
    expect(airports.isNotEmpty, true);
    expect(airports[0]['name'], 'FIUMICINO (AFCO) - ROME');
    String airportId2=airports[0]['id']??'';

    final result = await Flights.getFlights(airportId1, airportId2, '2024-04-24', 1, 1, 0, 1);
    sleep(Duration(milliseconds: 400));
    final result2 = await Flights.getFlights(airportId1, airportId2, '2024-04-24', 1, 1, 0, 2);
    expect(result.length==result2.length, false);
  });
}

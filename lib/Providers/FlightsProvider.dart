
import 'package:flutter/material.dart';
import 'package:lot_recrutation_app/Models/Flight.dart';



class FlightsProvider extends ChangeNotifier{

  List<Flight> flights_ = [];
  Flight? flightDetails_;
  bool? toAndFromFlights_;

  List<Flight> get flights => flights_;
  Flight? get flightDetails=>flightDetails_;
  bool? get toAndFromFlights=>toAndFromFlights_;

  set flights(List<Flight> newFlights){
    flights_=newFlights;
    notifyListeners();
  }

  void addFlights(List<Flight> newFlights){
    flights_.addAll(newFlights);
    notifyListeners();
  }

  set toAndFromFlights(bool? newToAndFromFlights){
    toAndFromFlights_=newToAndFromFlights;
    notifyListeners();
  }

  set flightDetails(Flight? newFlight){
    flightDetails_=newFlight;
    notifyListeners();
  }



}

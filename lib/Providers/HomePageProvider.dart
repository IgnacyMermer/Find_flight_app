import 'package:flutter/cupertino.dart';

class HomePageProvider extends ChangeNotifier{
  DateTime? fromDate_, toDate_, oneFlightDate_;
  int adults_=1, children_=0, babies_=0, flightClass_=-1;
  String airport_='', airportShortcut_='';
  bool isLoadingCities_=false, gettingFlights_=false;

  String? airportFromId_, airportToId_;

  DateTime? get fromDate=>fromDate_;
  DateTime? get toDate=>toDate_;
  DateTime? get oneFlightDate=>oneFlightDate_;
  int get adults=>adults_;
  int get children=>children_;
  int get babies=>babies_;
  int get flightClass=>flightClass_;
  String get airport=>airport_;
  String get airportShortcut=>airportShortcut_;
  bool get isLoadingCities=>isLoadingCities_;
  String? get airportFromId=>airportFromId_;
  String? get airportToId=>airportToId_;
  bool get gettingFlights=>gettingFlights_;


  set fromDate(DateTime? newFromDate){
    fromDate_=newFromDate;
    notifyListeners();
  }

  set toDate(DateTime? newToDate){
    toDate_=newToDate;
    notifyListeners();
  }

  set oneFlightDate(DateTime? newFromDate){
    oneFlightDate_=newFromDate;
    notifyListeners();
  }

  set adults(int newAdults){
    adults_=newAdults;
    notifyListeners();
  }

  set children(int newChildren){
    children_=newChildren;
    notifyListeners();
  }

  set babies(int newBabies){
    babies_=newBabies;
    notifyListeners();
  }

  set flightClass(int newFlightClass){
    flightClass_=newFlightClass;
    notifyListeners();
  }

  set airport(String newAirport){
    airport_=newAirport;
    notifyListeners();
  }

  set airportShortcut(String newAirport){
    airportShortcut_=newAirport;
    notifyListeners();
  }

  set isLoadingCities(bool newIsLoadingCities){
    isLoadingCities_=newIsLoadingCities;
    notifyListeners();
  }

  set airportFromId(String? newAirportFromId){
    airportFromId_=newAirportFromId;
    notifyListeners();
  }

  set airportToId(String? newAirportToId){
    airportToId_=newAirportToId;
    notifyListeners();
  }

  set gettingFlights(bool newGettingFlights){
    gettingFlights_=newGettingFlights;
    notifyListeners();
  }


}

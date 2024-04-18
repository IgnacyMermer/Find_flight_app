import 'package:flutter/cupertino.dart';

class HomePageProvider extends ChangeNotifier{
  DateTime? fromDate_, toDate_, oneFlightDate_;
  TextEditingController flyFromController_ = new TextEditingController();
  TextEditingController flyToController_ = new TextEditingController();
  int adults_=1, teenagers_=0, children_=0, babies_=0, flightClass_=-1;

  DateTime? get fromDate=>fromDate_;
  DateTime? get toDate=>toDate_;
  DateTime? get oneFlightDate=>oneFlightDate_;
  TextEditingController get flyFromController => flyFromController_;
  TextEditingController get flyToController => flyToController_;
  int get adults=>adults_;
  int get teenagers=>teenagers_;
  int get children=>children_;
  int get babies=>babies_;
  int get flightClass=>flightClass_;


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

  set flyFromController(TextEditingController newController){
    flyFromController_=newController;
    notifyListeners();
  }

  set flyToController(TextEditingController newController){
    flyToController_=newController;
    notifyListeners();
  }

  set adults(int newAdults){
    adults_=newAdults;
    notifyListeners();
  }

  set teenagers(int newTeenagers){
    teenagers_=newTeenagers;
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


}
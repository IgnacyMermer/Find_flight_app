
import 'FlightSegment.dart';

class Flight{

  String lastTicketingDate, time, currency, totalPrice;
  int numberOfBookableSeats;
  List<FlightSegment> segments;

  Flight(this.lastTicketingDate, this.numberOfBookableSeats, this.time,
    this.currency, this.totalPrice, this.segments);

}
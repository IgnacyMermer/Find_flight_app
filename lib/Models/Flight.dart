
import 'FlightSegment.dart';

class Flight{

  String lastTicketingDate, time, price, currency, totalPrice;
  int numberOfBookableSeats;
  List<FlightSegment> segments;

  Flight(this.lastTicketingDate, this.numberOfBookableSeats, this.time, this.price,
    this.currency, this.totalPrice, this.segments);

}
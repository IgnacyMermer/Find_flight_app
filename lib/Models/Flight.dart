
import 'FlightSegment.dart';

class Flight{

  String lastTicketingDate;
  int numberOfBookableSeats;
  List<FlightSegment> segments;

  Flight(this.lastTicketingDate, this.numberOfBookableSeats,
    this.segments);

}
import 'Trip.dart';

class TripList {
  List<Trip> _trips=[];

  TripList();

  TripList.empty() {
    this._trips = [];
  }

  TripList.from(this._trips);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {'trips': _trips};
    return map;
  }

  factory TripList.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw FormatException("Null JSON.");
    }
    List<Trip> list = [];
    json['trips'].forEach((trip) {
      list.add(Trip.fromJson(trip));
    });
    return TripList.from(list);
  }

  List<Trip> get trips => _trips;
}

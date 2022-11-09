class TripDestination {
  String country='';
  String date='';

  TripDestination();

  TripDestination.from(this.country, this.date);

  factory TripDestination.empty() {
    return TripDestination.from("", "");
  }

  factory TripDestination.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw FormatException("Null JSON.");
    }
    return TripDestination.from(json['country'], json['date']);
  }

  factory TripDestination.copyOf(TripDestination other) {
    if (other == null) {
      return TripDestination.empty();
    } else {
      return TripDestination.from(other.country, other.date);
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {'country': country, 'date': date};
    return map;
  }

  operator ==(other) =>
      (other is TripDestination) &&
      (country == other.country) &&
      (date == other.date);

  int get hashCode => country.hashCode ^ date.hashCode;
}

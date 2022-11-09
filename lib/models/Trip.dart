import '../constants/Dates.dart';
import '../services/CountriesService.dart';
import '../services/DateService.dart';
//import '../widgets/controls/DateRangeWidget.dart';

import '../widgets/controls/DateRangeWidget.dart';
import 'Prescription.dart';
import 'PrescriptionAlert.dart';
import 'TripDestination.dart';

class Trip {
  String departureDate="";
  List<TripDestination> destinations=[];
  String returnDate="";
  String? notes;
  String? timeZoneName;
  String? timeZoneOffset;

  Trip();

  Trip.from(this.departureDate, this.destinations, this.returnDate, this.notes,
      this.timeZoneName, this.timeZoneOffset);

  factory Trip.empty() {
    return Trip.from("", [], "", "", "", "");
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'departureDate': departureDate,
      'destinations': destinations,
      'returnDate': returnDate,
      'notes': notes,
      'timeZoneName': timeZoneName,
      'timeZoneOffset': timeZoneOffset,
    };
    return map;
  }

  factory Trip.fromJson(Map<String, dynamic> json) {
    if (json == Null as Map) {
      throw FormatException("Null JSON.");
    }
    List<TripDestination> destinationsList = [];
    json['destinations'].forEach((destinaton) {
      destinationsList.add(TripDestination.fromJson(destinaton));
    });
    return Trip.from(
        json['departureDate'],
        destinationsList,
        json['returnDate'],
        json['notes'],
        json['timeZoneName'],
        json['timeZoneOffset']);
  }

  factory Trip.copyOf(Trip other) {
    if (other == Null as Trip) {
      return Trip.empty();
    } else {
      List<TripDestination> destinationsCopy = [];
      for (TripDestination item in other.destinations) {
        destinationsCopy.add(TripDestination.copyOf(item));
      }
      return Trip.from(other.departureDate, destinationsCopy, other.returnDate,
          other.notes, other.timeZoneName, other.timeZoneOffset);
    }
  }

  get dates {
    return "${departureDate} : ${returnDate}";
  }

  get countries {
    if ((departureDate == null) ||
        (departureDate.isEmpty) ||
        (destinations.length == 0) ||
        (returnDate == null) ||
        (returnDate.isEmpty)) {
      return "";
    } else {
      return calculateCountryNames(destinations);
    }
  }

  get current {
    return !previous;
  }

  get previous {
    return DATE_FORMAT.parse(returnDate).isBefore(DateTime.now());
  }

  get dateRange {
    return DateRange.fromStrings(departureDate, returnDate);
  }

  static void checkDestinationsInDateRange(
      List<TripDestination> destinations, DateRange dateRange) {
    for (int i = destinations.length - 1; i >= 0; i--) {
      DateTime dt = DateService.parseBeginning(destinations[i].date);
      if (DateService.isDateOutsideDateRange(dt, dateRange)) {
        destinations.removeAt(i);
      }
    }
  }

  static String calculateCountryNames(List<TripDestination> destinations) {
    destinations.sort((a, b) {
      DateTime aDate = DATE_FORMAT.parse(a.date);
      DateTime bDate = DATE_FORMAT.parse(b.date);
      return aDate.compareTo(bDate);
    });
    var countryNames = "";
    destinations.forEach((destination) {
      var country = destination.country;
      if (!countryNames.endsWith(country)) {
        if (countryNames.length > 0) {
          countryNames += ", ";
        }
        countryNames += country;
      }
    });
    return countryNames;
  }

  static String calculateCountryCodeForDay(
      List<TripDestination> destinations, DateRange dateRange, DateTime dt) {
    return CountriesService.getCountryCode(
        calculateCountryNameForDay(destinations, dateRange, dt));
  }

  static String calculateCountryNameForDay(
      List<TripDestination> destinations, DateRange dateRange, DateTime dt) {
    if (destinations.length == 0) {
      return "";
    }
    if (DateService.isDateOutsideDateRange(dt, dateRange)) {
      return "";
    }
    return calculateCountryBefore(destinations, dt);
  }

  static String calculateCountryBefore(
      List<TripDestination> destinations, DateTime day) {
    String lastCountry = "";
    sortTripDestinations(destinations);
    for (int i = 0, ii = destinations.length; i < ii; i++) {
      DateTime dt = DATE_FORMAT.parse(destinations[i].date);
      if (dt.isAfter(day)) {
        return lastCountry;
      }
      String country = destinations[i].country;
      lastCountry = country;
    }
    return lastCountry;
  }

  static List<Prescription> calculatePrescriptionsForDate(
      List<Prescription> prescriptions, DateTime dt) {
    String formattedDate = DateService.format(dt);
    List<Prescription> prescriptionsForDate = [];
    for (Prescription prescription in prescriptions) {
      for (PrescriptionAlert alert in prescription.alerts) {
        if (alert.datetime!.startsWith(formattedDate)) {
          prescriptionsForDate.add(prescription);
          break;
        }
      }
    }
    return prescriptionsForDate;
  }

  static sortTripDestinations(List<TripDestination> destinations) {
    destinations.sort((a, b) {
      DateTime aDate = DATE_FORMAT.parse(a.date);
      DateTime bDate = DATE_FORMAT.parse(b.date);
      return aDate.compareTo(bDate);
    });
  }

  operator ==(other) {
    if (!(other is Trip)) {
      return false;
    }
    Trip otherAsTrip = other;
    if (!(otherAsTrip.departureDate == departureDate)) {
      return false;
    }
    if (otherAsTrip.destinations.length != destinations.length) {
      return false;
    }
    for (int i = 0, ii = destinations.length; i < ii; i++) {
      if (otherAsTrip.destinations[i] != destinations[i]) {
        return false;
      }
    }
    if (!(otherAsTrip.returnDate == returnDate)) {
      return false;
    }
    if (!(otherAsTrip.notes == notes)) {
      return false;
    }
    return true;
  }

  int get hashCode =>
      departureDate.hashCode ^
      destinations.hashCode ^
      returnDate.hashCode ^
      notes.hashCode;
}

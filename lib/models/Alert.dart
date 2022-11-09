import 'package:enum_to_string/enum_to_string.dart';
import '../enums/AlertType.dart';
import '../services/DateService.dart';

class Alert {
  AlertType? _alertType;
  String? _timeZoneName;
  String? _timeZoneOffset;
  String? _prescriptionName;
  String? _prescriptionTime;
  String? _arrivalTripCountries;
  String? _arrivalTripDates;
  String? _arrivalDestinationCountry;
  String? _arrivalDestinationDate;
  String? _createdDate;

  Alert.prescriptionPast(String timeZoneName, String timeZoneOffset,
      String prescriptionName, String prescriptionTime) {
    this._alertType = AlertType.prescriptionPast;
    this._timeZoneName = timeZoneName;
    this._timeZoneOffset = timeZoneOffset;
    this._prescriptionName = prescriptionName;
    this._prescriptionTime = prescriptionTime;
    this._arrivalTripCountries = "";
    this._arrivalTripDates = "";
    this._arrivalDestinationCountry = "";
    this._arrivalDestinationDate = "";
    this._createdDate = DateService.dateStamp();
  }

  Alert.prescriptionFuture(String timeZoneName, String timeZoneOffset,
      String prescriptionName, String prescriptionTime) {
    this._alertType = AlertType.prescriptionFuture;
    this._timeZoneName = timeZoneName;
    this._timeZoneOffset = timeZoneOffset;
    this._prescriptionName = prescriptionName;
    this._prescriptionTime = prescriptionTime;
    this._arrivalTripCountries = "";
    this._arrivalTripDates = "";
    this._arrivalDestinationCountry = "";
    this._arrivalDestinationDate = "";
    this._createdDate = DateService.dateStamp();
  }

  Alert.arrival(
      String timeZoneName,
      String timeZoneOffset,
      String tripCountries,
      String tripDates,
      String destinationName,
      String destinationDate) {
    this._alertType = AlertType.arrival;
    this._timeZoneName = timeZoneName;
    this._timeZoneOffset = timeZoneOffset;
    this._prescriptionName = "";
    this._prescriptionTime = "";
    this._alertType = AlertType.arrival;
    this._arrivalTripCountries = tripCountries;
    this._arrivalTripDates = tripDates;
    this._arrivalDestinationCountry = destinationName;
    this._arrivalDestinationDate = destinationDate;
    this._createdDate = DateService.dateStamp();
  }

  Alert.from(
      this._alertType,
      this._timeZoneName,
      this._timeZoneOffset,
      this._prescriptionName,
      this._prescriptionTime,
      this._arrivalTripCountries,
      this._arrivalTripDates,
      this._arrivalDestinationCountry,
      this._arrivalDestinationDate,
      this._createdDate);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'alertType': EnumToString.parse(_alertType),
      'timeZoneName': _timeZoneName,
      'timeZoneOffset': _timeZoneOffset,
      'prescriptionName': _prescriptionName,
      'prescriptionTime': _prescriptionTime,
      'arrivalTripCountries': _arrivalTripCountries,
      'arrivalTripDates': _arrivalTripDates,
      'arrivalDestinationCountry': _arrivalDestinationCountry,
      'arrivalDestinationDate': _arrivalDestinationDate,
      'createdDate': _createdDate,
    };
    return map;
  }

  factory Alert.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw FormatException("Null JSON.");
    }
    return Alert.from(
        EnumToString.fromString(AlertType.values, json['alertType']),
        json['timeZoneName'],
        json['timeZoneOffset'],
        json['prescriptionName'],
        json['prescriptionTime'],
        json['arrivalTripCountries'],
        json['arrivalTripDates'],
        json['arrivalDestinationCountry'],
        json['arrivalDestinationDate'],
        json['createdDate']);
  }

  operator ==(other) {
    if (!(other is Alert)) {
      return false;
    }
    Alert otherAsAlert = other;
    if (!(otherAsAlert.alertType == _alertType)) {
      return false;
    }
    if (!(otherAsAlert.timeZoneName == _timeZoneName)) {
      return false;
    }
    if (!(otherAsAlert.timeZoneOffset == _timeZoneOffset)) {
      return false;
    }
    if (!(otherAsAlert.prescriptionName == _prescriptionName)) {
      return false;
    }
    if (!(otherAsAlert.prescriptionTime == _prescriptionTime)) {
      return false;
    }
    if (!(otherAsAlert.arrivalTripCountries == _arrivalTripCountries)) {
      return false;
    }
    if (!(otherAsAlert.arrivalTripDates == _arrivalTripDates)) {
      return false;
    }
    if (!(otherAsAlert.arrivalDestinationCountry == _arrivalDestinationCountry)) {
      return false;
    }
    if (!(otherAsAlert.arrivalDestinationDate == _arrivalDestinationDate)) {
      return false;
    }
    if (!(otherAsAlert.createdDate == _createdDate)) {
      return false;
    }
    return true;
  }

  int get hashCode =>
      _alertType.hashCode ^
      _timeZoneName.hashCode ^
      _timeZoneOffset.hashCode ^
      _arrivalTripCountries.hashCode ^
      _arrivalTripDates.hashCode ^
      _prescriptionName.hashCode ^
      _prescriptionTime.hashCode ^
      _arrivalDestinationCountry.hashCode ^
      _arrivalDestinationDate.hashCode ^
      _createdDate.hashCode;

  String? get createdDate => _createdDate;

  String? get arrivalDestinationDate => _arrivalDestinationDate;

  String? get arrivalDestinationCountry => _arrivalDestinationCountry;

  String? get arrivalTripDates => _arrivalTripDates;

  String? get arrivalTripCountries => _arrivalTripCountries;

  String? get prescriptionTime => _prescriptionTime;

  String? get prescriptionName => _prescriptionName;

  String? get timeZoneOffset => _timeZoneOffset;

  String? get timeZoneName => _timeZoneName;

  AlertType? get alertType => _alertType;
}

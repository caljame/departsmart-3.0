import 'PrescriptionAlert.dart';

class Prescription {
  String? name;
  String? timeZoneName;
  String? timeZoneOffset;
  String? alertsDescription;
  List<PrescriptionAlert> alerts = [];

  Prescription();

  Prescription.from(this.name, this.timeZoneName, this.timeZoneOffset,
      this.alertsDescription, this.alerts);

  factory Prescription.empty() {
    return Prescription.from("", "", "", "", []);
  }

  factory Prescription.fromJson(Map<String, dynamic> json) {
    // ignore: unnecessary_null_comparison
    if (json != null) {
    } else {
      throw const FormatException("Null JSON.");
    }
    List<PrescriptionAlert> alerts = [];
    if (json['alerts'] != null) {
      json['alerts'].forEach((prescription) {
        alerts.add(PrescriptionAlert.fromJson(prescription));
      });
    } else {
      alerts = [];
    }
    return Prescription.from(json['name'], json['timeZoneName'],
        json['timeZoneOffset'], json['alertsDescription'], alerts);
  }

  factory Prescription.copyOf(Prescription other) {
    if (other == null) {
      return Prescription.empty();
    } else {
      List<PrescriptionAlert> alertsCopy = [];
      for (PrescriptionAlert item in other.alerts) {
        alertsCopy.add(PrescriptionAlert.copyOf(item));
      }
      return Prescription.from(other.name, other.timeZoneName,
          other.timeZoneOffset, other.alertsDescription, alertsCopy);
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'name': name,
      'timeZoneName': timeZoneName,
      'timeZoneOffset': timeZoneOffset,
      'alertsDescription': alertsDescription,
      'alerts': alerts
    };
    return map;
  }

  operator ==(other) {
    if (!(other is Prescription)) {
      return false;
    }
    Prescription otherAsPrescription = other;
    if (!(otherAsPrescription.name == name)) {
      return false;
    }
    if (!(otherAsPrescription.timeZoneName == timeZoneName)) {
      return false;
    }
    if (!(otherAsPrescription.timeZoneOffset == timeZoneOffset)) {
      return false;
    }
    if (!(otherAsPrescription.alertsDescription == alertsDescription)) {
      return false;
    }
    if (otherAsPrescription.alerts.length != alerts.length) {
      return false;
    }
    for (int i = 0, ii = alerts.length; i < ii; i++) {
      if (otherAsPrescription.alerts[i] != alerts[i]) {
        return false;
      }
    }
    return true;
  }

  int get hashCode =>
      name.hashCode ^
      timeZoneName.hashCode ^
      timeZoneOffset.hashCode ^
      alertsDescription.hashCode ^
      alerts.hashCode;
}

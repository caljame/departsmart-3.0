class PrescriptionAlert {
  String? datetime;
  bool completed=false;

  PrescriptionAlert();

  factory PrescriptionAlert.empty() {
    return PrescriptionAlert.from("", false);
  }

  PrescriptionAlert.from(this.datetime, this.completed);

  factory PrescriptionAlert.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw FormatException("Null JSON.");
    }
    return PrescriptionAlert.from(json['datetime'], json['completed']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {'datetime': datetime, 'completed': completed};
    return map;
  }

  factory PrescriptionAlert.copyOf(PrescriptionAlert other) {
    if (other == null) {
      return PrescriptionAlert.empty();
    } else {
      return PrescriptionAlert.from(other.datetime, other.completed);
    }
  }

  operator ==(other) {
    if (!(other is PrescriptionAlert)) {
      return false;
    }
    if (!(other.datetime == datetime)) {
      return false;
    }
    if (!(other.completed == completed)) {
      return false;
    }
    return true;
  }

  int get hashCode => datetime.hashCode ^ completed.hashCode;
}

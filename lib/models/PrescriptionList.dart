import 'Prescription.dart';

class PrescriptionList {
  List<Prescription> _prescriptions=[];

  PrescriptionList();

  PrescriptionList.empty() {
    this._prescriptions = [];
  }

  PrescriptionList.from(this._prescriptions);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {'prescriptions': _prescriptions};
    return map;
  }

  factory PrescriptionList.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw FormatException("Null JSON.");
    }
    List<Prescription> list = [];
    json['prescriptions'].forEach((trip) {
      list.add(Prescription.fromJson(trip));
    });
    return PrescriptionList.from(list);
  }

  List<Prescription> get prescriptions => _prescriptions;
}

import 'Alert.dart';

class AlertList {
  List<Alert>? _alerts;

  AlertList();

  AlertList.empty() {
    this._alerts = [];
  }

  AlertList.from(this._alerts);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {'completedAlerts': this._alerts};
    return map;
  }

  factory AlertList.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw FormatException("Null JSON.");
    }
    List<Alert> list = [];
    json['completedAlerts'].forEach((alert) {
      list.add(Alert.fromJson(alert));
    });
    return AlertList.from(list);
  }

  List<Alert>? get alerts => _alerts;
}

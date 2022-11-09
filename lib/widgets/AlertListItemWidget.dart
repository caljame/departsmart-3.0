import 'package:flutter/material.dart';
import '../constants/Ui.dart';
import '../enums/AlertType.dart';
import '../models/Alert.dart';
import '../services/MessagesService.dart';


class AlertListItemWidget extends StatelessWidget {
  Alert? _alert;

  AlertListItemWidget({Key? key, required Alert alert}) : super(key: key) {
    _alert = alert;
  }

  @override
  Widget build(BuildContext context) {
    if (_alert?.alertType == AlertType.arrival) {
      String? title = MessagesService.getArrivalTitle(
          _alert?.arrivalDestinationCountry ?? '');
      String? subtitle = MessagesService.getArrivalSubtitle(
          _alert?.arrivalTripCountries ?? '', _alert?.arrivalTripDates ?? '');
      return ListTile(
          title: Text(title, style: TEXT_STYLE_SUBHEADING_RED),
          subtitle: Text(subtitle, style: TEXT_STYLE_REGULAR),
          trailing: Checkbox(
              value: false,
              onChanged: (b) => Null as Checkbox));
    } else {
      String? title = MessagesService.getPrescriptionMessage(
          _alert?.alertType == AlertType.prescriptionFuture,
           _alert?.prescriptionName ?? '',
          _alert?.prescriptionTime ?? '',
          _alert?.timeZoneName ?? '');
      String subtitle = MessagesService.getPrescriptionSubtitle();
      return ListTile(
          title: Text(title, style: TEXT_STYLE_SUBHEADING),
          subtitle: Text(subtitle, style: TEXT_STYLE_REGULAR),
          trailing: Checkbox(
              value: false,
              onChanged: (b) =>  Null as Checkbox));
    }
  }
}

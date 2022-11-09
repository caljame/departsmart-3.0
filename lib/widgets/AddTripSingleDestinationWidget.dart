import 'package:flutter/material.dart';
import '../Constants/Ui.dart';
import '../constants/Dates.dart';
import '../constants/UiFactory.dart';
import '../framework/LinkButtonOnItsOwnLineWidget.dart';
import '../models/Trip.dart';
import '../models/TripDestination.dart';
import '../services/DateService.dart';
import '../widgets/controls/DateRangeWidget.dart';

class AddTripSingleDestinationWidget extends StatefulWidget {
  AddTripSingleDestinationWidget() {}

  @override
  _AddTripSingleDestinationWidgetState createState() =>
      _AddTripSingleDestinationWidgetState();
}

class _AddTripSingleDestinationWidgetState
    extends State<AddTripSingleDestinationWidget> {
  final _formKey = GlobalKey<FormState>();
  DateRange? _dateRange;
  bool? _dateRangeInvalid = false;
  TextEditingController? _countryTextController;
  TextEditingController? _notesTextController;

  _AddTripSingleDestinationWidgetState() {
    this._dateRange = DateRange(DateTime.now(), DateTime.now());
  }

  @override
  void initState() {
    _countryTextController = TextEditingController();
    _notesTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext? context) {
    return Form(
        key: _formKey,
        child: ListView(children: [
          DateRangeWidget(
            value: _dateRange!,
            onChanged: (v) => _onDateRangeChanged(v),
            invalid: _dateRangeInvalid!,
          ),
          UiFactory.createCountryField(
              textEditingController: _countryTextController, name: "Country"),
          /* TODO:
          UiFactory.createNotesTextField(
              textEditingController: _notesTextController!, name: "Notes"),
          */
          VERTICAL_SPACER_20,
          LinkButtonOnItsOwnLineWidget("Save & Close", () => _onSave(context!)),
          LinkButtonOnItsOwnLineWidget("Close", () => _onClose(context!))
        ]));
  }

  _onDateRangeChanged(DateRange dateRange) {
    setState(() {
      this._dateRange = dateRange;
    });
  }

  _onSave(BuildContext context) {
    setState(() {
      _dateRangeInvalid = (_dateRange == null);
    });
    if ((_formKey.currentState?.validate() ?? false) && (!_dateRangeInvalid!)) {
      _formKey.currentState?.save();
      TripDestination tripDestination = TripDestination.from(
          _countryTextController!.text,
          DATE_FORMAT.format(_dateRange?.start ?? DateTime(0)));
      Trip trip = Trip.from(
          DATE_FORMAT.format(_dateRange?.start! ?? DateTime(0)),
          [tripDestination],
          DATE_FORMAT.format(_dateRange?.end ?? DateTime(0)),
          _notesTextController?.text,
          DateService.getTimezoneName(),
          DateService.getTimezoneOffset());
      Navigator.pop(context, trip);
    }
  }

  _onClose(BuildContext context) {
    Navigator.pop(context, null);
  }
}

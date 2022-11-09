import 'package:flutter/material.dart';

import '../framework/LinkButtonOnItsOwnLineWidget.dart';
import '../constants/Ui.dart';
import '../constants/UiFactory.dart';

import '../models/CheckboxValue.dart';
import '../models/CommandData.dart';
import '../models/Prescription.dart';
import '../models/PrescriptionAlert.dart';
import '../services/DateService.dart';
import '../widgets/controls/CheckboxWidget.dart';
import '../widgets/controls/RadioWidget.dart';
import 'controls/DateRangeWidget.dart';
import 'controls/DateWidget.dart';

import 'controls/DaysIntervalWidget.dart';
import 'controls/TimeWidget.dart';

class AddPrescriptionWidget extends StatefulWidget {
  Stream<CommandData>? _commandStream;

  AddPrescriptionWidget(@required Stream<CommandData> commandStream) {
    this._commandStream = commandStream;
  }

  @override
  _AddPrescriptionWidgetState createState() => _AddPrescriptionWidgetState();
}

class _AddPrescriptionWidgetState extends State<AddPrescriptionWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _medicineTextEditingController =
      new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateRange? _dateRange;
  TimeOfDay? _startTime = TimeOfDay(hour: 9, minute: 0);
  String? _frequency = "one day";
  String? _frequencyPerDay = "1";
  List<CheckboxValue> _specificDaysCheckboxValues = [];
  int? _daysInterval = 2;

  _AddPrescriptionWidgetState() {}

  @override
  void initState() {
    _dateRange = DateRange(DateService.beginningOfToday(),
        DateService.addDays(DateService.beginningOfToday(), 14));
    DateTime? dt = _dateRange?.start;

    //DateTime? end = _dateRange?.end ?? DateTime.now();
    // bool? isAfter = dt?.isAfter(end);
    while (!dt!.isAfter(_dateRange!.end)) {
      dt = DateService.beginningOfDate(dt!);
      String suffix = dt.isBefore(_dateRange?.start ?? DateTime.now())
          ? "before"
          : dt.isAfter(_dateRange?.end ?? DateTime.now())
              ? "after"
              : 'before';
      _specificDaysCheckboxValues
          .add(CheckboxValue.withSuffix(false, DateService.format(dt), suffix));
      dt = DateService?.addDay(dt);
    }
  }

  @override
  Widget build(BuildContext context) {
    var listViewChildren = [
      UiFactory.createTextField(
          textEditingController: _medicineTextEditingController,
          name: "Medicine",
          autoFocus: true),
      VERTICAL_SPACER_20,
      Row(children: const [
        Icon(
          Icons.shutter_speed,
          size: 24,
          color: COLOR_GREY,
        ),
        HORIZONTAL_SPACER_20,
        Text("Enter Frequency",
            style: TEXT_STYLE_INPUT, textAlign: TextAlign.left)
      ]),
      RadioWidget(
          title: _calculateFrequencyText("one day"),
          padding: EdgeInsets.only(left: 30),
          value: "one day",
          groupValue: _frequency,
          onChanged: (v) => _onFrequencyChanged(v)),
      RadioWidget(
          title: _calculateFrequencyText("every day"),
          padding: EdgeInsets.only(left: 30),
          value: "every day",
          groupValue: _frequency,
          onChanged: (v) => _onFrequencyChanged(v)),
      RadioWidget(
          title: _calculateFrequencyText("specific days"),
          padding: EdgeInsets.only(left: 30),
          value: "specific days",
          groupValue: _frequency,
          onChanged: (v) => _onFrequencyChanged(v)),
      RadioWidget(
          title: _calculateFrequencyText("days interval"),
          padding: EdgeInsets.only(left: 30),
          value: "days interval",
          groupValue: _frequency,
          onChanged: (v) => _onFrequencyChanged(v)),
      VERTICAL_SPACER_10,
    ];
    if (_frequency == 'days interval') {
      listViewChildren.addAll([
        Divider(indent: 40, height: 2, color: Colors.black),
        VERTICAL_SPACER_20,
        DaysIntervalWidget(
            value: _daysInterval ?? 0,
            onChanged: (v) => _onDaysIntervalChanged(v))
      ]);
    }
    DateWidget dateWidget = DateWidget(
        title: "Start Date",
        value: _dateRange?.start,
        firstDate: _dateRange?.start,
        lastDate: _dateRange?.end,
        onChanged: (v) => _onStartDateChanged(v));
    listViewChildren.addAll([
      VERTICAL_SPACER_20,
      const Divider(indent: 40, height: 2, color: Colors.black),
      dateWidget
    ]);
    if (_frequency != "one day") {
      listViewChildren.addAll([
        Divider(indent: 40, height: 1, color: Colors.black),
        DateWidget(
            title: "End Date",
            value: _dateRange?.end,
            firstDate:
                DateService.addDays(_dateRange?.start ?? DateTime.now(), 1),
            lastDate: _dateRange?.end,
            onChanged: (v) => _onEndDateChanged(v))
      ]);
    }
    if (_frequency == 'specific days') {
      listViewChildren.addAll([
        Divider(indent: 40, height: 2, color: Colors.black),
        VERTICAL_SPACER_20,
      ]);
      listViewChildren
          .addAll(_specificDaysCheckboxValues.map((cb) => CheckboxWidget(
                title: cb.title,
                suffix: cb.suffix,
                padding: EdgeInsets.only(left: 30),
                value: cb.isChecked,
                onChanged: (v) => _onSpecificDateChanged(v),
                groupValue: '',
              )));
      listViewChildren.addAll([VERTICAL_SPACER_20]);
    }
    listViewChildren.addAll([
      const Divider(indent: 40, height: 1, color: Colors.black),
      TimeWidget(
          title: "Start Time",
          value: _startTime!,
          onChanged: (v) => _onStartTimeChanged(v)),
      VERTICAL_SPACER_10,
      const Divider(indent: 40, height: 1, color: Colors.black),
      VERTICAL_SPACER_10,
      Row(children: const [
        Icon(
          Icons.filter_1,
          size: 24,
          color: COLOR_GREY,
        ),
        HORIZONTAL_SPACER_20,
        Text("Enter Frequency Per Day",
            style: TEXT_STYLE_INPUT, textAlign: TextAlign.left)
      ]),
      RadioWidget(
          title: _calculateFrequencyPerDayText("1"),
          padding: EdgeInsets.only(left: 30),
          value: "1",
          groupValue: _frequencyPerDay,
          onChanged: (v) => _onFrequencyPerDayChanged(v)),
      RadioWidget(
          title: _calculateFrequencyPerDayText("2"),
          padding: EdgeInsets.only(left: 30),
          value: "2",
          groupValue: _frequencyPerDay,
          onChanged: (v) => _onFrequencyPerDayChanged(v)),
      RadioWidget(
          title: _calculateFrequencyPerDayText("3"),
          padding: EdgeInsets.only(left: 30),
          value: "3",
          groupValue: _frequencyPerDay,
          onChanged: (v) => _onFrequencyPerDayChanged(v)),
      RadioWidget(
          title: _calculateFrequencyPerDayText("4"),
          padding: EdgeInsets.only(left: 30),
          value: "4",
          groupValue: _frequencyPerDay,
          onChanged: (v) => _onFrequencyPerDayChanged(v)),
      RadioWidget(
          title: _calculateFrequencyPerDayText("12"),
          padding: EdgeInsets.only(left: 30),
          value: "12",
          groupValue: _frequencyPerDay,
          onChanged: (v) => _onFrequencyPerDayChanged(v)),
      RadioWidget(
          title: _calculateFrequencyPerDayText("24"),
          padding: EdgeInsets.only(left: 30),
          value: "24",
          groupValue: _frequencyPerDay,
          onChanged: (v) => _onFrequencyPerDayChanged(v)),
      VERTICAL_SPACER_20,
      LinkButtonOnItsOwnLineWidget("Save & Close", () => _onSave(context)),
      LinkButtonOnItsOwnLineWidget("Close", () => _onClose(context)),
      VERTICAL_SPACER_20,
      Text("This prescription times are for ${DateService.getTimezoneName()}",
          style: TEXT_STYLE_HINT)
    ]);
    Widget form =
        Form(key: _formKey, child: ListView(children: listViewChildren));
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(
            "Add Prescription Alert",
            style: TEXT_STYLE_APP_HEADING,
          ),
        ),
        body: Container(padding: EdgeInsets.all(20.0), child: form));
  }

  String _calculateFrequencyText(String value) {
    if ("one day" == value) {
      return "One Day";
    } else if ("every day" == value) {
      return "Every Day";
    } else if ("specific days" == value) {
      return "Specific Days";
    } else if ("days interval" == value) {
      return "Days Interval";
    } else {
      return "unknown";
    }
  }

  String _calculateFrequencyPerDayText(String value) {
    if ("1" == value) {
      return "Once";
    } else if ("2" == value) {
      return "Twice a Day";
    } else if ("2" == value) {
      return "Twice a Day";
    } else if ("3" == value) {
      return "Three Times a Day";
    } else if ("4" == value) {
      return "Four Times a Day";
    } else if ("12" == value) {
      return "Every Two Hours";
    } else if ("24" == value) {
      return "Hourly";
    } else {
      return "unknown";
    }
  }

  List<DateTime> _calculateDaysForInterval() {
    List<DateTime> dates = [];
    DateTime? dt = _dateRange?.start ?? DateTime.now();

    DateTime? end = _dateRange?.end ?? DateTime.now();
    bool? isAfter = dt.isAfter(end);
    while (!isAfter) {
      dates.add(dt!);
      dt = DateService.addDays(dt, _daysInterval!);
    }
    return dates;
  }

  _onSpecificDateChanged(CheckboxValue checkboxValue) {
    CheckboxValue matchingCheckboxValue = _specificDaysCheckboxValues
        .firstWhere((cbv) => cbv.title == checkboxValue.title, orElse: null);
    if (matchingCheckboxValue != null) {
      setState(() {
        matchingCheckboxValue.isChecked = checkboxValue.isChecked;
      });
    }
  }

  _onDaysIntervalChanged(int value) {
    setState(() {
      if ((value > 0) && (value < 10)) {
        _daysInterval = value;
      }
    });
  }

  _onFrequencyChanged(value) {
    setState(() {
      _frequency = value;
    });
  }

  _onStartDateChanged(DateTime value) {
    setState(() {
      _dateRange?.start = value;
      _dateRange?.end =
          DateService.addDays(_dateRange?.start ?? DateTime.now(), 28);
    });
  }

  _onStartTimeChanged(TimeOfDay value) {
    setState(() {
      _startTime = value;
    });
  }

  _onEndDateChanged(DateTime value) {
    setState(() {
      _dateRange?.end = value;
    });
  }

  _onFrequencyPerDayChanged(value) {
    setState(() {
      _frequencyPerDay = value;
    });
  }

  _onSave(BuildContext context) {
    if (_formKey.currentState?.validate() ?? true) {
      _formKey.currentState?.save();
      try {
        DateTime today = DateService.beginningOfToday();
        bool? startIsBeforeToday = _dateRange?.start.isBefore(today);
        if (startIsBeforeToday ?? true) {
          _dateRange?.start = DateService.beginningOfToday();
        }
        String? alertsDescription = _createAlertsDescription();
        List<PrescriptionAlert>? alerts = _createAlerts();
        Prescription prescription = Prescription.from(
            _medicineTextEditingController.text,
            DateService.getTimezoneName(),
            DateService.getTimezoneOffset(),
            alertsDescription,
            alerts!);
        Navigator.pop(context, prescription);
      } catch (e) {
        var message = 'Error';
        // _scaffoldKey.currentState?
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: COLOR_RED,
            content: Text("Could not add prescription: ${message}")));
      }
    }
  }

  _onClose(BuildContext context) {
    Navigator.pop(context, null);
  }

  String? _createAlertsDescription() {
    String startDate = DateService.format(_dateRange?.start ?? DateTime.now());
    String endDate = DateService.format(_dateRange?.end ?? DateTime.now());
    String? startTime = _startTime?.format(context);
    String frequencyPerDay =
        _calculateFrequencyPerDayText(_frequencyPerDay!).toLowerCase();
    if (_frequency == 'one day') {
      return "One day ${startDate}. " +
          "Taken ${frequencyPerDay}, starting at ${startTime}.";
    } else if (_frequency == 'every day') {
      return "Every day from ${startDate} to ${endDate}. " +
          "Taken ${frequencyPerDay}, starting at ${startTime}.";
    } else if (_frequency == 'specific days') {
      List<CheckboxValue> checked =
          _specificDaysCheckboxValues.where((cbv) => cbv.isChecked).toList();
      String dates = checked.map((cbv) => cbv.title).toList().join(", ");
      return "Specific days ${dates}. " +
          "Taken ${frequencyPerDay}, starting at ${startTime}.";
    } else if (_frequency == 'days interval') {
      return "Every ${_daysInterval} days from ${startDate} to ${endDate}. " +
          "Taken ${frequencyPerDay}, starting at ${startTime}.";
    }
    return "";
  }

  List<PrescriptionAlert>? _createAlerts() {
    List<String>? dateTimesList;
    if (_frequency == 'one day') {
      dateTimesList = _createTripPrescriptionDateTimesOneDay()?.cast<String>();
    } else if (_frequency == 'every day') {
      dateTimesList = _createTripPrescriptionDatesTimesEveryDay();
    } else if (_frequency == 'specific days') {
      dateTimesList = _createTripPrescriptionDatesTimesSpecificDays();
    } else if (_frequency == 'days interval') {
      dateTimesList = _createTripPrescriptionDatesTimesDaysInterval();
    }
    if (dateTimesList?.isEmpty ?? true) {
      throw Exception("Medicine must be prescribed at least once.");
    }
    return dateTimesList
        ?.map((datetime) => PrescriptionAlert.from(datetime, false))
        .toList();
  }

  List<String?>? _createTripPrescriptionDateTimesOneDay() {
    return _createProductOfDatesAndTimesOfDay(
        [_dateRange?.start ?? DateTime.now()], _createTimesOfDay());
  }

  List<String> _createTripPrescriptionDatesTimesEveryDay() {
    List<DateTime> dates = [];
    DateTime dt = _dateRange?.start ?? DateTime.now();
    while (!dt.isAfter(_dateRange?.end ?? DateTime.now())) {
      dt = DateService.beginningOfDate(dt);
      dates.add(dt);
      dt = DateService.addDay(dt);
    }
    return _createProductOfDatesAndTimesOfDay(dates, _createTimesOfDay());
  }

  List<String> _createTripPrescriptionDatesTimesSpecificDays() {
    List<CheckboxValue> checked =
        _specificDaysCheckboxValues.where((cbv) => cbv.isChecked).toList();
    List<DateTime> dates =
        checked.map((cbv) => DateService.parse(cbv.title)).toList();
    return _createProductOfDatesAndTimesOfDay(dates, _createTimesOfDay());
  }

  List<String> _createTripPrescriptionDatesTimesDaysInterval() {
    return _createProductOfDatesAndTimesOfDay(
        _calculateDaysForInterval(), _createTimesOfDay());
  }

  List<String> _createProductOfDatesAndTimesOfDay(
      List<DateTime> dates, List<TimeOfDay> timesOfDay) {
    List<String> datesAndTimes = [];
    for (int i = 0, ii = dates.length; i < ii; i++) {
      DateTime date = dates[i];
      for (int j = 0, jj = timesOfDay.length; j < jj; j++) {
        TimeOfDay timeOfDay = timesOfDay[j];
        datesAndTimes.add(DateService.formatDateTime(DateTime(date.year,
            date.month, date.day, timeOfDay.hour, timeOfDay.minute)));
      }
    }
    return datesAndTimes;
  }

  List<TimeOfDay> _createTimesOfDay() {
    TimeOfDay startTime = TimeOfDay(
        hour: (_startTime?.hour ?? 0), minute: (_startTime?.minute ?? 0));
    if (_frequencyPerDay == "1") {
      return _createTimesOfDay1To4(startTime, 1);
    } else if (_frequencyPerDay == "2") {
      return _createTimesOfDay1To4(startTime, 2);
    } else if (_frequencyPerDay == "3") {
      return _createTimesOfDay1To4(startTime, 3);
    } else if (_frequencyPerDay == "4") {
      return _createTimesOfDay1To4(startTime, 4);
    } else if (_frequencyPerDay == "12") {
      return createTimesOfDayEveryNHours(startTime, 2);
    } else {
      return createTimesOfDayEveryNHours(startTime, 1);
    }
  }

  List<TimeOfDay> _createTimesOfDay1To4(TimeOfDay startTime, int frequency) {
    if (frequency == 1) {
      return [startTime];
    }

    List<TimeOfDay> timesOfDay = [startTime];
    int minutesInDay = 24 * 60;
    int minutesIntoDay = (startTime.hour * 60) + startTime.minute;
    int minutesLeftInDay = minutesInDay - minutesIntoDay;
    int minutesPerIteration = (minutesLeftInDay / frequency).toInt();
    for (int iteration = 1; iteration < frequency; iteration++) {
      int minuteOfDay = minutesIntoDay + (minutesPerIteration * iteration);
      int hour = (minuteOfDay / 60).toInt();
      int minute = (minuteOfDay % 60).toInt();
      timesOfDay.add(TimeOfDay(hour: hour, minute: minute));
    }
    return timesOfDay;
  }

  List<TimeOfDay> createTimesOfDayEveryNHours(TimeOfDay startTime, int nHours) {
    int minutesInDay = 24 * 60;
    int minuteOfDay = (startTime.hour * 60) + startTime.minute;
    List<TimeOfDay> timesOfDay = [];
    while (minuteOfDay < minutesInDay) {
      int hour = (minuteOfDay / 60).toInt();
      int minute = (minuteOfDay % 60).toInt();
      timesOfDay.add(TimeOfDay(hour: hour, minute: minute));
      minuteOfDay += (nHours * 60);
    }
    return timesOfDay;
  }
}

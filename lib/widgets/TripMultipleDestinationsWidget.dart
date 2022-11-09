import 'package:flutter/material.dart';
import '../constants/Dates.dart';
import '../constants/Ui.dart';
import '../constants/UiFactory.dart';
import '../framework/LinkButtonOnItsOwnLineWidget.dart';
import '../models/Trip.dart';
import '../models/TripDestination.dart';
import '../services/CountriesService.dart';
import '../services/DateService.dart';

import 'controls/DateRangeWidget.dart';

class TripMultipleDestinationsWidget extends StatefulWidget {
  bool? _adding;
  Trip? _trip;

  TripMultipleDestinationsWidget.add() {
    this._adding = true;
    this._trip = Trip.empty();
  }

  TripMultipleDestinationsWidget.editExisting(Trip trip) {
    this._adding = false;
    this._trip = Trip.copyOf(trip);
  }

  @override
  _TripMultipleDestinationsWidgetState createState() =>
      _TripMultipleDestinationsWidgetState();
}

class _TripMultipleDestinationsWidgetState
    extends State<TripMultipleDestinationsWidget> {
  final GlobalKey<ScaffoldState>? _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState>? _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState>? _selectCountryFormKey = GlobalKey<FormState>();
  DateRange? _dateRange;
  bool? _dateRangeInvalid = false;
  TextEditingController? _notesTextController;
  TextEditingController? _selectCountryTextController;
  List<TripDestination>? _destinations;
  DateTime? _selectedDay;
  bool? _calendarGaps = false;

  _TripMultipleDestinationsWidgetState() {}

  @override
  void initState() {
    if (widget._adding!) {
      _dateRange = DateRange(DateTime.now(), DateTime.now());
    } else {
      _dateRange = DateRange(
          DATE_FORMAT.parse(widget._trip?.departureDate ?? ''),
          DATE_FORMAT.parse(widget._trip?.returnDate ?? ''));
    }
    _notesTextController = TextEditingController(text: widget._trip?.notes);
    _selectCountryTextController = TextEditingController();
    _destinations = widget._trip?.destinations;
    _selectedDay = null;
  }

  @override
  Widget build(BuildContext context) {
    Widget calendarPromptWidget;

    if ((_dateRange != null) && (_destinations?.isEmpty ?? true)) {
      calendarPromptWidget = const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Tap & hold a calendar day to add a location.",
            style: TEXT_STYLE_ERROR,
          ));
    } else if ((_dateRange != null) && (_calendarGaps!)) {
      calendarPromptWidget = const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Please ensure all calendar days have locations.",
            style: TEXT_STYLE_ERROR,
          ));
    } else {
      calendarPromptWidget = EMPTY_SPACER;
    }
    String countryNames = Trip.calculateCountryNames(_destinations!);
    List<Widget> listViewChilden = [];
    if (countryNames.isNotEmpty) {
      listViewChilden.add(Text(countryNames, style: TEXT_STYLE_HEADING));
    }
    listViewChilden.addAll([
      DateRangeWidget(
        value: _dateRange!,
        onChanged: (v) => _onDateRangeChanged(v),
        invalid: widget._adding! ? _dateRangeInvalid! : false,
      ),
      VERTICAL_SPACER_10,
      buildCalendar(context),
      calendarPromptWidget,
      VERTICAL_SPACER_10,
      UiFactory?.createNotesTextField(
          textEditingController: _notesTextController, name: "Notes"),
      VERTICAL_SPACER_20,
      LinkButtonOnItsOwnLineWidget("Save & Close", () => _onSave(context)),
      LinkButtonOnItsOwnLineWidget("Close", () => _onClose(context))
    ]);

    Widget form =
        Form(key: _formKey, child: ListView(children: listViewChilden));
    if (widget._adding ?? true) {
      return form;
    } else {
      return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: const Text(
              "Edit Trip",
              style: TEXT_STYLE_APP_HEADING,
            ),
          ),
          body: Container(padding: EdgeInsets.all(20.0), child: form));
    }
  }

  Widget buildCalendar(BuildContext context) {
    List<Widget>? children = [];
    children.add(VERTICAL_SPACER_10);

    if (_dateRange == null) {
      children.addAll([
        VERTICAL_SPACER_20,
        const Text("Please select the Dates to view the calendar.",
            style: TEXT_STYLE_HINT),
        VERTICAL_SPACER_20,
        Icon(Icons.calendar_today, size: 136, color: COLOR_GREY)
      ]);
    } else {
      children.add(VERTICAL_SPACER_20);
      children.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Expanded(
              child: Text("Su",
                  textAlign: TextAlign.center,
                  style: TEXT_STYLE_SUBHEADING,
                  overflow: TextOverflow.fade)),
          Expanded(
              child: Text("Mo",
                  textAlign: TextAlign.center,
                  style: TEXT_STYLE_SUBHEADING,
                  overflow: TextOverflow.fade)),
          Expanded(
              child: Text("Tu",
                  textAlign: TextAlign.center,
                  style: TEXT_STYLE_SUBHEADING,
                  overflow: TextOverflow.fade)),
          Expanded(
              child: Text("We",
                  textAlign: TextAlign.center,
                  style: TEXT_STYLE_SUBHEADING,
                  overflow: TextOverflow.fade)),
          Expanded(
              child: Text("Th",
                  textAlign: TextAlign.center,
                  style: TEXT_STYLE_SUBHEADING,
                  overflow: TextOverflow.fade)),
          Expanded(
              child: Text("Fr",
                  textAlign: TextAlign.center,
                  style: TEXT_STYLE_SUBHEADING,
                  overflow: TextOverflow.fade)),
          Expanded(
              child: Text("Sa",
                  textAlign: TextAlign.center,
                  style: TEXT_STYLE_SUBHEADING,
                  overflow: TextOverflow.fade))
        ],
      ));
      DateRange calendarDateRange =
          DateService.createCalendarDateRange(_dateRange!);
      DateTime sunday = calendarDateRange.start;
      while (!sunday.isAfter(calendarDateRange.end)) {
        DateTime? day = DateTime(sunday.year, sunday.month, sunday.day);
        children.add(buildCalendarWeek(context, day!));
        sunday = DateService.beginningOfDate(
            sunday.add(const Duration(days: 7, hours: 1))); // weird
      }
    }
    return Column(children: children);
  }

  Widget buildCalendarWeek(BuildContext context, DateTime startOfWeek) {
    DateTime? startOfWeek2 =
        DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day, 0, 0, 0);
    List<Widget>? children = [];
    for (int i = 0; i < 7; i++) {
      DateTime weirdDt = startOfWeek2.add(Duration(
          hours: i * 25)); //weird behavior from add with duration 1 day
      DateTime dt = DateService.beginningOfDate(weirdDt);
      bool outsideDateRange =
          DateService.isDateOutsideDateRange(dt, _dateRange!);
      var child;
      if (outsideDateRange) {
        child = Container(color: COLOR_GREY);
      } else {
        bool isSelectedDay = _selectedDay != null && _selectedDay == dt;
        bool? isChangeDay = _destinations
            ?.where((td) => td.date == DATE_FORMAT.format(dt))
            .isNotEmpty;
        Column column = Column(children: [
          VERTICAL_SPACER_5,
          Text(
            "${dt.day}\n${Trip.calculateCountryCodeForDay(_destinations!, _dateRange!, dt)}",
            textAlign: TextAlign.center,
            style: (isSelectedDay || isChangeDay!)
                ? TEXT_STYLE_REGULAR_WHITE
                : TEXT_STYLE_REGULAR,
          ),
          VERTICAL_SPACER_5
        ]);
        child = GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                  color: isSelectedDay
                      ? COLOR_DARK_BLUE
                      : isChangeDay!
                          ? COLOR_LIGHT_BLUE
                          : Colors.white,
                  border: Border.all(color: COLOR_GREY)),
              child: column,
            ),
            onTap: () => _onSelectDay(context, dt),
            onLongPress: () => _onEditDay(context, dt));
      }
      children.add(Expanded(child: child));
    }
    return Row(
      children: children,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    );
  }

  _onDateRangeChanged(DateRange dateRange) {
    setState(() {
      this._dateRange = dateRange;
      this._calendarGaps = false;
      Trip.checkDestinationsInDateRange(_destinations!, _dateRange!);
    });
  }

  _onSelectDay(BuildContext context, DateTime day) async {
    if (day != null) {
      setState(() => _selectedDay = day);
    }
  }

  _onEditDay(BuildContext context, DateTime day) async {
    if (day != null) {
      setState(() => _selectedDay = day);
      var destinations = _destinations
          ?.where((td) => td.date == DATE_FORMAT.format(this._selectedDay!));
      if (destinations?.isEmpty ?? true) {
        bool ok = await _removeDestination(
                context, destinations?.first ?? TripDestination.empty()) ??
            true;
        if (ok) {
          setState(() {
            _destinations?.remove(destinations?.first);
            _selectedDay = DateTime.sunday as DateTime;
            _calendarGaps = false;
          });
        }
      } else {
        bool ok = await _addDestination(context, day);
        if (ok) {
          setState(() {
            _destinations?.add(TripDestination.from(
                _selectCountryTextController!.text, DATE_FORMAT.format(day)));
            _selectedDay = DateTime.now();
            _calendarGaps = false;
          });
        }
      }
    }
  }

  _addDestination(BuildContext context, DateTime day) async {
    _selectCountryTextController?.text = "";
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Add Location ${DATE_FORMAT.format(day)}",
              style: TEXT_STYLE_SUBHEADING,
            ),
            content: Form(
                key: _selectCountryFormKey,
                child: UiFactory.createCountryField(
                    textEditingController: _selectCountryTextController,
                    name: "Country")),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  if (_selectCountryFormKey?.currentState?.validate() ?? true) {
                    Navigator.of(context).pop(true);
                  }
                },
              ),
              TextButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              )
            ],
          );
        });
  }

  _removeDestination(BuildContext context, TripDestination destination) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Location ${destination.date}",
              style: TEXT_STYLE_SUBHEADING,
            ),
            content: Text(
              "${CountriesService.getCountryCode(destination?.country ?? 'no country')} - ${destination.country}",
              style: TEXT_STYLE_SUBHEADING,
            ),
            actions: <Widget>[
              TextButton(
                child: Text('REMOVE'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              TextButton(
                child: const Text('CLOSE'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              )
            ],
          );
        });
  }

  _onSave(BuildContext context) {
    setState(() {
      _dateRangeInvalid = (_dateRange == DateTime.now());
    });
    if ((_formKey?.currentState?.validate() ?? true) && (!_dateRangeInvalid!)) {
      DateTime? day = _dateRange?.start;
      DateTime? end = _dateRange?.end ?? DateTime.now();
      bool? isAfter = day?.isAfter(end);
      while (!isAfter!) {
        String? calculateCountryNameForDay =
            Trip.calculateCountryNameForDay(_destinations!, _dateRange!, day!);
        if (calculateCountryNameForDay?.isEmpty ?? true) {
          setState(() => _calendarGaps = true);
          return;
        }
        day = day?.add(Duration(days: 1));
      }
      setState(() => _calendarGaps = false);
      _formKey?.currentState?.save();
      Trip trip = Trip.from(
          DATE_FORMAT.format(_dateRange?.start ?? DateTime.now()),
          _destinations!,
          DATE_FORMAT.format(_dateRange?.end ?? DateTime.now()),
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

import 'package:flutter/material.dart';
import '../constants/Dates.dart';
import '../constants/Ui.dart';
import '../framework/LinkButtonOnItsOwnLineWidget.dart';
import '../models/Trip.dart';
import '../services/DateService.dart';

import 'controls/DateRangeWidget.dart';

class TripViewWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Trip? _trip;
  DateRange? _dateRange;
  DateRange? _calendarDateRange;

  TripViewWidget(Trip? trip) {
    this._trip = trip;
    calculateDates();
  }

  calculateDates() {
    this._dateRange = DateService.createDateRangeFromDateStrings(
        _trip!.departureDate, _trip?.returnDate);
    _calendarDateRange = DateService.createCalendarDateRange(_dateRange!);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget>? listViewChildren = [
      Text(Trip?.calculateCountryNames(_trip?.destinations ?? []),
          style: TEXT_STYLE_HEADING),
      VERTICAL_SPACER_10,
      Text("Departure Date: ${_trip?.departureDate}",
          style: TEXT_STYLE_SUBHEADING),
      Text("Return Date: ${_trip?.returnDate}", style: TEXT_STYLE_SUBHEADING),
      VERTICAL_SPACER_10,
      buildCalendar(context),
      VERTICAL_SPACER_10,
      Text("Notes: ${_trip?.notes}", style: TEXT_STYLE_REGULAR),
      VERTICAL_SPACER_20,
      LinkButtonOnItsOwnLineWidget("Close", () => _onClose(context))
    ];
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(
            "View Trip",
            style: TEXT_STYLE_APP_HEADING,
          ),
        ),
        body: Container(
            padding: EdgeInsets.all(20.0),
            child: ListView(children: listViewChildren)));
  }

  Widget buildCalendar(BuildContext context) {
    List<Widget> children = [];
    Row header = Row(
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
    );
    children.add(VERTICAL_SPACER_20);
    children.add(header);
    children.add(VERTICAL_SPACER_10);
    DateTime? sunday = _calendarDateRange?.start;
    bool isAfterSunday =
        sunday?.isAfter(_calendarDateRange?.end ?? DateTime.now()) ?? true;
    while (!isAfterSunday) {
      children.add(buildCalendarWeek(context, sunday!));
      sunday = DateService.beginningOfDate(
          sunday.add(const Duration(days: 7, hours: 1))); // weird
    }
    return Column(children: children);
  }

  Widget buildCalendarWeek(BuildContext context, DateTime startOfWeek) {
    DateTime startOfWeek2 =
        DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day, 0, 0, 0);
    List<Widget> children = [];
    for (int i = 0; i < 7; i++) {
      DateTime weirdDay = startOfWeek2.add(Duration(
          hours: i * 25)); //weird behavior from add with duration 1 day
      DateTime dt = DateTime(weirdDay.year, weirdDay.month, weirdDay.day);
      bool outsideDateRange =
          DateService.isDateOutsideDateRange(dt, _dateRange!);
      bool? isChangeDay = _trip?.destinations
          ?.where((td) => td.date == DATE_FORMAT.format(dt))
          .isNotEmpty;
      Column column = Column(children: [
        VERTICAL_SPACER_5,
        Text(
          "${dt.day}\n${Trip?.calculateCountryCodeForDay(_trip!.destinations, _dateRange!, dt)}",
          textAlign: TextAlign.center,
          style: isChangeDay! ? TEXT_STYLE_REGULAR_WHITE : TEXT_STYLE_REGULAR,
        ),
        VERTICAL_SPACER_5,
      ]);
      Widget child = Container(
        decoration: BoxDecoration(
            color: outsideDateRange
                ? COLOR_LIGHT_GREY
                : (isChangeDay ?? true)
                    ? COLOR_LIGHT_BLUE
                    : Colors.white,
            border: Border.all(color: COLOR_GREY)),
        child: column,
      );
      children.add(Expanded(child: child));
    }
    return Row(
      children: children,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    );
  }

  _onClose(BuildContext context) {
    Navigator.pop(context, null);
  }
}

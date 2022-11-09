// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import '../constants/Ui.dart';
import '../framework/LinkButtonOnItsOwnLineWidget.dart';
import '../models/Trip.dart';
import '../services/DateService.dart';
import '../services/ViewerService.dart';

import '../Bloc.dart';
import 'AlertHeadingWidget.dart';
import 'controls/DateRangeWidget.dart';

class HomeWidget extends StatefulWidget {
  VoidCallback? _onTripsSelected;
  VoidCallback? _onPrescriptionsSelected;

  HomeWidget({
    required VoidCallback onTripsSelected,
    required VoidCallback onPrescriptionsSelected,
  }) {
    this._onTripsSelected = onTripsSelected;
    this._onPrescriptionsSelected = onPrescriptionsSelected;
  }

  @override
  _HomeWidgetState createState() => new _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  DateTime? agendaDate;

  @override
  void initState() {
    agendaDate = DateService.beginningOfToday();
  }

  @override
  Widget build(BuildContext context) {
    Bloc bloc = Bloc.of(context);

    Trip? trip = bloc.calculateTripForAgendaDate(agendaDate!);

    DateRange? tripDateRange;
    if (trip != null) {
      tripDateRange = trip.dateRange;
      //if (tripDateRange.start)
    } else {
      tripDateRange = DateRange(DateTime.now(), DateTime.now());
    }

    return Column(children: [
      VERTICAL_SPACER_10,
      Divider(thickness: 2),
//      VERTICAL_SPACER_10,
//      AgendaDateWidget(
//        value: agendaDate,
//        onChanged: (v) => _onAgendaDateChanged(context, v),
//      ),
//      VERTICAL_SPACER_10,
//      buildAgendaWidget(context, trip, country),
//      VERTICAL_SPACER_10,
//      Divider(thickness: 2),
      VERTICAL_SPACER_10,
      HeadingWidget("My Information:"),
      GestureDetector(
          child: Text("Trips", style: TEXT_STYLE_LINK_BIG),
          onTap: () => widget._onTripsSelected!()),
      VERTICAL_SPACER_20,
      GestureDetector(
          child: Text("Prescription Alerts", style: TEXT_STYLE_LINK_BIG),
          onTap: () => widget._onPrescriptionsSelected!()),
      VERTICAL_SPACER_20,
      Divider(thickness: 2),
      HeadingWidget("Useful Links:"),
      GestureDetector(
          child: Text("Room Safety Checklist", style: TEXT_STYLE_LINK_BIG),
          onTap: () => DocumentationService.viewHtml(
              context,
              "Room Safety Checklist",
              "media/security/hotelSecurity/RoomSafetyChecklist.html",
              "")),
      VERTICAL_SPACER_20,
      GestureDetector(
          child: Text("World Clock", style: TEXT_STYLE_LINK_BIG),
          onTap: () => DocumentationService.viewWebpage(context, "World Clock",
              "https://www.timeanddate.com/worldclock/")),
      VERTICAL_SPACER_20,
      GestureDetector(
          child: Text("Currency Converter", style: TEXT_STYLE_LINK_BIG),
          onTap: () => DocumentationService.viewWebpage(
              context,
              "Currency Converter",
              "https://www.oanda.com/currency/converter/")),
      VERTICAL_SPACER_20,
    ]);
  }

  _onAgendaDateChanged(BuildContext context, DateTime dt) {
    setState(() {
      this.agendaDate = DateService.beginningOfDate(dt);
    });
  }

  //TODO Remove this if it is not being used.

  Widget buildAgendaWidget(BuildContext context, Trip trip, String country) {
    Widget tripWidget = Container(
        width: double.infinity,
        child: Text(
            trip != null
                ? "Trip: ${trip.countries} ${trip.departureDate} - ${trip.returnDate}"
                : "No trip for that date.",
            style: TEXT_STYLE_SUBHEADING));

    if (trip != null) {
      print("trip exist");
    } else {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: tripWidget);
    }

    DateRange tripDateRange = trip.dateRange;
    DateRange calendarDateRange =
        DateService.createCalendarDateRange(tripDateRange);

    List<Widget> children = [];
    children.add(tripWidget);
    children.add(VERTICAL_SPACER_10);
    children.add(Container(
        width: double.infinity,
        child: Text("${DateService.format(agendaDate!)}: ${country}",
            style: TEXT_STYLE_SUBHEADING)));
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
    children.add(VERTICAL_SPACER_10);

    DateTime sunday = calendarDateRange.start;
    while (!sunday.isAfter(calendarDateRange.end)) {
      DateTime day = DateTime(sunday.year, sunday.month, sunday.day);
      children.add(buildCalendarWeek(context, day, trip));
      sunday = DateService.beginningOfDate(
          sunday.add(Duration(days: 7, hours: 1))); // weird
    }

    if ((trip.notes != null) & (trip.notes!.isNotEmpty)) {
      children.add(VERTICAL_SPACER_20);
      children.add(Container(
          width: double.infinity,
          child: Text("Notes:", style: TEXT_STYLE_SUBHEADING)));
      children.add(Container(
          width: double.infinity,
          child: Text(trip!.notes!, style: TEXT_STYLE_REGULAR)));
    }

    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(children: children));
  }

  Widget buildCalendarWeek(
      BuildContext context, DateTime startOfWeek, Trip trip) {
    DateTime startOfWeek2 =
        DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day, 0, 0, 0);
    DateRange tripDateRange = trip.dateRange;
    List<Widget> children = [];
    for (int i = 0; i < 7; i++) {
      DateTime weirdDt = startOfWeek2.add(Duration(
          hours: i * 25)); //weird behavior from add with duration 1 day
      DateTime dt = DateService.beginningOfDate(weirdDt);
      bool outsideDateRange =
          DateService.isDateOutsideDateRange(dt, tripDateRange);
      var child;
      if (outsideDateRange) {
        child = Container(color: COLOR_GREY);
      } else {
        var isAgendaDate = DateService.equals(dt, agendaDate!);
        Column column = Column(children: [
          VERTICAL_SPACER_5,
          Text(
            "${dt.day}\n${Trip.calculateCountryCodeForDay(trip.destinations, tripDateRange, dt)}",
            textAlign: TextAlign.center,
            style: isAgendaDate ? TEXT_STYLE_REGULAR_WHITE : TEXT_STYLE_REGULAR,
          ),
          VERTICAL_SPACER_5
        ]);
        child = Container(
          decoration: BoxDecoration(
              color: isAgendaDate ? COLOR_DARK_BLUE : COLOR_WHITE,
              border: Border.all(color: COLOR_GREY)),
          child: column,
        );
      }
      children.add(Expanded(child: child));
    }
    return Row(
      children: children,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    );
  }
}

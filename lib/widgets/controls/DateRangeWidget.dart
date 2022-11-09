//import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../constants/Dates.dart';
import '../../constants/Ui.dart';
import '../../services/DateService.dart';

class DateRangeWidget extends StatelessWidget {
  final DateRange value;
  final ValueChanged<DateRange> onChanged;
  final bool invalid;

  const DateRangeWidget(
      {required this.value, required this.onChanged, required this.invalid});

  @override
  Widget build(BuildContext context) {
    Widget button = Container(
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: COLOR_GREY)),
        child: IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(
              Icons.arrow_drop_down_circle,
              size: 24,
              color: COLOR_GREY,
            ),
            onPressed: () => _onChanged(context)));
    String text = value == null
        ? "Select the Dates"
        : "${DATE_FORMAT.format(value.start)} : ${DATE_FORMAT.format(value.end)}";
    Widget row = Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: 24,
          color: COLOR_GREY,
        ),
        HORIZONTAL_SPACER_15,
        new Text(text, style: TEXT_STYLE_INPUT),
        Spacer(),
        button
      ],
      mainAxisAlignment: MainAxisAlignment.spaceAround,
    );

    if (invalid) {
      Row errorRow = Row(children: <Widget>[
        HORIZONTAL_SPACER_40,
        Text("Please select the Dates", style: TEXT_STYLE_ERROR)
      ]);
      return Padding(
        child: Column(children: [row, errorRow]),
        padding: EdgeInsets.only(top: 10, bottom: 10),
      );
    } else {
      return Padding(
        child: row,
        padding: EdgeInsets.only(top: 10, bottom: 10),
      );
    }
  }

  _onChanged(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
       // context: context, firstDate: firstDate, lastDate: lastDate)Picker(
        context: context,
        firstDate: value == null
            ? DateService.beginningOfTodayPlusDays(7)
            : value.start,
        currentDate: DateTime.now(),
        saveText: 'Done',
        lastDate: DateService.beginningOfTodayPlusDays(21));
   /*
    if (picked != null ) {
      onChanged(DateRange(picked.start, picked.end));
    }*/

  }
}

class DateRange {
  DateTime? _start;
  DateTime? _end;

  DateRange(DateTime start, DateTime end) {
    if (start.isBefore(end)) {
      this._start = start;
      this._end = end;
    } else {
      this._start = end;
      this._end = start;
    }
  }

  DateRange.fromStrings(String startString, String endString) {
    DateTime start = DateService.parseBeginning(startString);
    DateTime end = DateService.parseBeginning(endString);
    if (start.isBefore(end)) {
      this._start = start;
      this._end = end;
    } else {
      this._start = end;
      this._end = start;
    }
  }

  DateTime get end => DateService.beginningOfDate(_end!);

  DateTime get start => DateService.beginningOfDate(_start!);

  set end(DateTime value) {
    _end = value;
  }

  set start(DateTime value) {
    _start = value;
  }
}

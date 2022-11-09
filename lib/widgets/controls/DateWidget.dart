import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../constants/Ui.dart';
import '../../services/DateService.dart';

class DateWidget extends StatelessWidget {
  final String? title;
  final DateTime? value;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime>? onChanged;

  const DateWidget(
      {this.title,
      @required this.value,
      @required this.firstDate,
      @required this.lastDate,
      @required this.onChanged});

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
            icon: const Icon(
              Icons.arrow_drop_down_circle,
              size: 24,
              color: COLOR_GREY,
            ),
            onPressed: () => _onChanged(context)));

    Widget row = Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      const Icon(
        Icons.calendar_today,
        size: 24,
        color: COLOR_GREY,
      ),
      HORIZONTAL_SPACER_15,
      Text(
          "${title == null ? "" : title ?? '' + ": "}${DateService.format(value!)}",
          style: TEXT_STYLE_INPUT),
      Spacer(),
      button
    ]);

    return Padding(
      child: row,
      padding: EdgeInsets.only(top: 10, bottom: 10),
    );
  }

  _onChanged(BuildContext context) async {
    final datetime = await showDatePicker(
        context: context,
        initialDate: value!,
        firstDate: firstDate!,
        lastDate: lastDate!);
    if (datetime != null) {
      onChanged!(datetime);
    }
  }
}

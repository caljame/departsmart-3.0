import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../constants/Ui.dart';

class TimeWidget extends StatelessWidget {
  final String title;
  final TimeOfDay value;
  final ValueChanged<TimeOfDay> onChanged;

  const TimeWidget(
      {required this.title, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Widget button = Container(
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(0),
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(5.0),
            border: Border.all(color: COLOR_GREY)),
        child: IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(
              Icons.arrow_drop_down_circle,
              size: 24,
              color: COLOR_GREY,
            ),
            onPressed: () => _onChanged(context)));

    Widget row = Row(children: [
      Icon(
        Icons.access_time,
        size: 24,
        color: COLOR_GREY,
      ),
      HORIZONTAL_SPACER_15,
      new Text("${title == null ? "" : title + ": "}${value.format(context)}",
          style: TEXT_STYLE_INPUT),
      Spacer(),
      button
    ], mainAxisAlignment: MainAxisAlignment.spaceAround);

    return Padding(
      child: row,
      padding: EdgeInsets.only(top: 10, bottom: 10),
    );
  }

  _onChanged(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: value,
    );
    if (time != null) {
      onChanged(time);
    }
  }
}

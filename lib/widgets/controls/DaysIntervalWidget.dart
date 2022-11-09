import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class DaysIntervalWidget extends StatelessWidget {
  int? _value;
  ValueChanged<int>? _onChanged;

  DaysIntervalWidget(
      {required int value, required ValueChanged<int> onChanged}) {
    this._value = value;
    this._onChanged = onChanged;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 40),
        child: Row(
          children: <Widget>[
            OutlinedButton(
                child: const Text("-"),

                onPressed: () => _onChanged!(_value! - 1),
                style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)))),
                //child: Text("   ${_value} days   ", style: TEXT_STYLE_REGULAR)),
              OutlinedButton(
                  child: const Text("+"),
                onPressed: () => _onChanged!(_value! + 1),
                style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                ))
          ],
        ));
  }
}

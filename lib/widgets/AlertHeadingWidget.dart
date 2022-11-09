import 'package:flutter/material.dart';
import '../constants/Ui.dart';

class HeadingWidget extends StatelessWidget {
  String _title;

  HeadingWidget(this._title);

  @override
  Widget build(BuildContext context) {
    return Container(width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Text(this._title, style: TEXT_STYLE_HEADING));
  }
}

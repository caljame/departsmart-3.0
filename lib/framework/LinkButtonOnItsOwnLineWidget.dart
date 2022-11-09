import 'package:flutter/material.dart';
import '../framework/LinkButtonWidget.dart';

class LinkButtonOnItsOwnLineWidget extends StatelessWidget {
  String _text = "";
  VoidCallback _onPressed;
  bool _big;

  LinkButtonOnItsOwnLineWidget(this._text, this._onPressed, [this._big = true]);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        width: double.infinity,
        alignment: AlignmentDirectional.centerStart,
        child: LinkButtonWidget(
          text: _text,
          onPressed: () => _onPressed(),
          big: this._big,
          noPadding: false,
        ));
  }
}

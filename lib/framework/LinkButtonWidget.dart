import 'package:flutter/material.dart';

import '../../constants/Ui.dart';


class LinkButtonWidget extends StatelessWidget {
  String? _text = "";
  VoidCallback? _onPressed;
  bool? _big;
  bool? _noPadding;
  bool? _white;

  LinkButtonWidget(
      {text = "", onPressed, big = false, noPadding = false, white = false}) {
    this._text = text;
    this._onPressed = onPressed;
    this._big = big;
    this._noPadding = noPadding;
    this._white = white;
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        constraints: BoxConstraints(),
        padding: EdgeInsets.all(_noPadding! ? 0 : 5),
        onPressed: () => _onPressed!(),
        child: Text(_text!,
            style: _big!
                ? (_white!
                    ? TEXT_STYLE_LINK_BIG_WHITE
                    : TEXT_STYLE_LINK_BIG)
                : (_white! ? TEXT_STYLE_LINK_WHITE : TEXT_STYLE_LINK)));
  }
}

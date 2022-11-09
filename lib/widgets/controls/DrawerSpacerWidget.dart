import 'package:flutter/material.dart';

import '../../constants/Ui.dart';

class DrawerSpacerWidget extends StatelessWidget {
  DrawerSpacerWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(thickness: 2, color: COLOR_LIGHT_GREY),
    );
  }
}

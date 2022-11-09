import 'package:flutter/material.dart';

import '../../constants/Ui.dart';


class DrawerSubheadingWidget extends StatelessWidget {
  final String title;

  DrawerSubheadingWidget({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(
          title.toUpperCase(),
          style: TEXT_DRAWER_SUBHEADING,
          textAlign: TextAlign.center,
        ));
  }
}

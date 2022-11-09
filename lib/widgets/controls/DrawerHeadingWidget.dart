import 'package:flutter/material.dart';

import '../../constants/Ui.dart';

class DrawerHeadingWidget extends StatelessWidget {
  final String title;
  final List<Widget> children;

  DrawerHeadingWidget({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ExpansionTile(
          title: Text("${title.toUpperCase()}", style: TEXT_DRAWER_HEADING),
          children: children,
        ));
  }
}

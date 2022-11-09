import 'package:flutter/material.dart';
import '../constants/Ui.dart';
import '../models/Prescription.dart';
import 'AlertHeadingWidget.dart';

class PrescriptionViewWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Prescription? _item;

  PrescriptionViewWidget({@required Prescription? prescription}) {
    this._item = prescription;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(
            "View Prescription Alert",
            style: TEXT_STYLE_APP_HEADING,
            overflow: TextOverflow.visible,
          ),
        ),
        body: Container(
            padding: EdgeInsets.all(20.0),
            child: ListView(
              children: <Widget>[
                HeadingWidget("Medicine: ${_item?.name}"),
                Container(
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    child: Text(
                      "Timezone: ${_item?.timeZoneName}",
                      style: TEXT_STYLE_HINT,
                      textAlign: TextAlign.center,
                    )),
                Container(
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    child: Text(
                      "${_item?.alertsDescription}",
                      style: TEXT_STYLE_SUBHEADING,
                      textAlign: TextAlign.center,
                    )),
              ],
            )));
  }
}

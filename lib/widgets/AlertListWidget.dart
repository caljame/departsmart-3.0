import 'package:flutter/material.dart';

import '../models/Alert.dart';
import '../models/AlertList.dart';

import 'AlertHeadingWidget.dart';
import 'AlertListItemWidget.dart';
import 'controls/ColumnBuilder.dart';

class AlertListWidget extends StatelessWidget {
  const AlertListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(0),
        child: StreamBuilder<AlertList>(
            initialData: AlertList.empty(),
            builder: (context, snapshot) {
              List<Alert>? _alerts = snapshot.data?.alerts;
              //   if (snapshot.data?.alerts?.isEmpty ?? false) {
              if ((snapshot.data?.alerts != null) &&
                  (snapshot.data!.alerts!.isNotEmpty)) {
                return ColumnBuilder(
                    itemBuilder: (BuildContext context, int index) => index == 0
                        ? HeadingWidget("Alerts:")
                        : AlertListItemWidget(alert: _alerts![index - 1]),
                    itemCount: (snapshot.data?.alerts?.length)! + 1);
              } else {
                return HeadingWidget("There are no alerts.");
              }
            }));
  }
}

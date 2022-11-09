import 'package:flutter/material.dart';
import '../widgets/HomeWidget.dart';
import '../widgets/ScaffoldWidget.dart';

import '../Bloc.dart';
import '../widgets/PleaseWaitWidget.dart';

class AppWidget extends StatelessWidget {
  ScaffoldWidget? _homeComponent;
  final PleaseWaitWidget _pleaseWait =
      PleaseWaitWidget(key: const ObjectKey("pleaseWait"));

  @override
  Widget build(BuildContext context) {
    final bloc = Bloc.of(context);

    if (_homeComponent != null) {
      print("existing home componet");
    } else {
      _homeComponent = ScaffoldWidget(
          key: const ObjectKey("Home"), commandStream: bloc.commandStateStream);
    }

    return StreamBuilder<bool>(
        stream: bloc.pleaseWaitStateStream,
        initialData: false,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          return snapshot.data!
              ? Stack(
                  key: const ObjectKey("stack"),
                  children: [_homeComponent!, _pleaseWait!])
              : Stack(
                  key: const ObjectKey("stack"),
                  children: [_pleaseWait!, _homeComponent!]);
        }); // streamBuilder
  }
}

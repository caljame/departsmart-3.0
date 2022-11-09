import 'package:flutter/material.dart';
import '../constants/Ui.dart';
import '../models/CommandData.dart';
import '../models/Trip.dart';

import 'AddTripSingleDestinationWidget.dart';
import 'TripMultipleDestinationsWidget.dart';

class AddTripWidget extends StatefulWidget {
  late Stream<CommandData> _commandStream;

  AddTripWidget(@required Stream<CommandData> commandStream) {
    _commandStream = commandStream;
  }

  @override
  _AddTripWidgetState createState() => _AddTripWidgetState(_commandStream);
}

class _AddTripWidgetState extends State<AddTripWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _AddTripWidgetState(Stream<CommandData> commandStream) {
    commandStream.listen((command) => _handleCommand(command));
  }

  _handleCommand(CommandData command) {
    if ((command.isMessage()) && (_scaffoldKey.currentState != null)) {
      // _scaffoldKey.currentState?.showBottomSheet((context) => null).showSnackBar(
      //    SnackBar(backgroundColor: Colors.red, content: Text(command.data!)));
    }
  }

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    var container = Container(
        child: const Material(
            color: Colors.white,
            child: TabBar(
                labelColor: COLOR_DARK_BLUE,
                unselectedLabelColor: COLOR_GREY,
                labelStyle: TextStyle(
                    color: COLOR_DARK_BLUE, fontWeight: FontWeight.w800),
                indicatorColor: Colors.white,
                tabs: <Widget>[
                  Tab(text: 'Single Location'),
                  Tab(text: 'Multi-Locations'),
                ])));
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Add Trip"),
              bottom: PreferredSize(
                  preferredSize: const Size(0.0, 50.0), child: container),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: TabBarView(
                children: <Widget>[
                  AddTripSingleDestinationWidget(),
                  TripMultipleDestinationsWidget?.add()
                ],
              ),
            )));
  }
}

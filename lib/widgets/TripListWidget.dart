import 'package:flutter/material.dart';
import '../constants/Ui.dart';
import '../framework/LinkButtonWidget.dart';
import '../models/Trip.dart';
import '../models/TripList.dart';
import '../widgets/TripListItemWidget.dart';

import '../Bloc.dart';
import 'AddTripWidget.dart';
import 'TripMultipleDestinationsWidget.dart';
import 'TripViewWidget.dart';
import 'controls/ColumnBuilder.dart';

class TripListWidget extends StatelessWidget {
  TripListWidget();

  @override
  Widget build(BuildContext context) {
    Bloc bloc = Bloc.of(context);

    return Container(
        padding: EdgeInsets.all(0),
        child: StreamBuilder<TripList>(
            stream: bloc.tripListStream,
            initialData: TripList.empty(),
            builder: (context, snapshot) {
              List<Widget> children = [
                VERTICAL_SPACER_10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        child: Icon(Icons.add_circle),
                        onTap: () => _onAdd(context)),
                    LinkButtonWidget(
                        text: "Add Trip", onPressed: () => _onAdd(context))
                  ],
                ),
                VERTICAL_SPACER_10,
                Container(
                    color: COLOR_LIGHT_BLUE,
                    child: const ListTile(
                        title: Text(
                      "Current Trips",
                      style: TEXT_STYLE_SUBHEADING_WHITE,
                      textAlign: TextAlign.center,
                    )))
              ];
              List<Trip> currentTripList =
                  snapshot.data!.trips.where((trip) => trip.current).toList();
              if (currentTripList.isEmpty) {
                children.add(Column(children: const <Widget>[
                  VERTICAL_SPACER_20,
                  Text("There are no current trips.",
                      style: TEXT_STYLE_SUBHEADING),
                  VERTICAL_SPACER_20,
                ]));
              } else {
                children
                    .addAll(currentTripList.map((trip) => TripListItemWidget(
                          trip: trip,
                          onEdit: (trip) => this._onEdit(context, trip),
                          onDelete: (trip) => this._onDelete(context, trip),
                          isCurrent: null as bool,
                        )));
              }
              children.add(Container(
                  color: COLOR_LIGHT_BLUE,
                  child: const ListTile(
                      title: Text(
                    "Previous Trips",
                    style: TEXT_STYLE_SUBHEADING_WHITE,
                    textAlign: TextAlign.center,
                  ))));
              List<Trip>? list =
                  snapshot.data?.trips.where((trip) => trip.previous).toList();
              if (list!.isEmpty) {
                children.add(Column(children: const <Widget>[
                  VERTICAL_SPACER_20,
                  Text("There are no previous trips.",
                      style: TEXT_STYLE_SUBHEADING),
                  VERTICAL_SPACER_20,
                ]));
              } else {
                children.addAll(list.map((trip) => TripListItemWidget(
                      trip: trip,
                      onEdit: (trip) => _onEdit(context, trip),
                      onDelete: (trip) => _onDelete(context, trip),
                      isCurrent: false,
                    )));
              }
              return ListView.builder(
                  itemBuilder: (BuildContext context, int index) =>
                      children[index],
                  itemCount: children.length);
            }));
  }

  _onAdd(BuildContext context) async {
    Bloc bloc = Bloc.of(context);
    Trip? result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddTripWidget(bloc.commandStateStream!),
            fullscreenDialog: true));

    if (result != null) {
      bloc.addTrip(result);
    }
  }

  _onEdit(BuildContext context, Trip trip) async {
    Bloc bloc = Bloc.of(context);
    Trip updatedTrip = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => trip.current
                ? TripMultipleDestinationsWidget.editExisting(trip)
                : TripViewWidget(trip),
            fullscreenDialog: true));
    if (updatedTrip != null) {
      bloc.updateTrip(trip, updatedTrip);
    }
  }

  _onDelete(BuildContext context, Trip trip) {
    Bloc bloc = Bloc.of(context);
    bloc.deleteTrip(trip);
  }
}

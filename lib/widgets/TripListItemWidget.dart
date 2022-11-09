import 'package:flutter/material.dart';
import '../constants/Ui.dart';
import '../models/Trip.dart';

class TripListItemWidget extends StatelessWidget {
  Trip? _trip;
  ValueChanged<Trip>? _onEdit;
  ValueChanged<Trip>? _onDelete;

  TripListItemWidget(
      {required Trip trip,
      required bool isCurrent,
      required ValueChanged<Trip> onEdit,
      required ValueChanged<Trip> onDelete}) {
    this._trip = trip;
    this._onEdit = onEdit;
    this._onDelete = onDelete;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: ListTile(
            title: Text(_trip?.countries, style: TEXT_STYLE_SUBHEADING),
            subtitle: Text(
              "Trip Dates: ${_trip?.departureDate} - ${_trip?.returnDate}",
              style: TEXT_STYLE_REGULAR,
            ),
            trailing: Theme(
                data: Theme.of(context).copyWith(
                  cardColor: COLOR_LIGHT_BLUE,
                ),
                child: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _onDeleteConfirm(context),
                ))),
        onTap: () => _onEdit!(this._trip!));
  }

  _onDeleteConfirm(BuildContext context) {
    _showConfirmDialog(context)?.then((result) {
      if (result == true) {
    _onDelete!(_trip!);
      }
    });
  }

  Future<bool?>? _showConfirmDialog(BuildContext context) async {
    return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm'),
            content: const Text('Are you sure you want to delete this trip?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('No'),
              )
            ],
          );
        });
  }
}

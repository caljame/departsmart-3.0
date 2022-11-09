import 'package:flutter/material.dart';
import '../constants/Ui.dart';
import '../models/Prescription.dart';

class PrescriptionListItemWidget extends StatelessWidget {
  Prescription? _item;
  ValueChanged<Prescription>? _onEdit;
  ValueChanged<Prescription>? _onDelete;

  PrescriptionListItemWidget(
      {@required Prescription? trip,
      @required bool? isCurrent,
      @required ValueChanged<Prescription>? onEdit,
      @required ValueChanged<Prescription>? onDelete}) {
    _item = trip;
    _onEdit = onEdit;
    _onDelete = onDelete;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: ListTile(
            title: Text(_item?.name ?? '', style: TEXT_STYLE_SUBHEADING),
            subtitle: Text(
              "${_item?.alerts?.length} alert(s)",
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
        onTap: () => _onEdit!(_item!));
  }

  _onDeleteConfirm(BuildContext context) {
    _showConfirmDialog(context)?.then((result) {
      if (result == true) {
        _onDelete!(_item!);
      }
    });
  }

  Future<bool?>? _showConfirmDialog(BuildContext context) async {
    return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm'),
            content: const Text(
                'Are you sure you want to delete this prescription?'),
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

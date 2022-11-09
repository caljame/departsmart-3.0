import 'package:flutter/material.dart';
import '../constants/Ui.dart';
import '../framework/LinkButtonWidget.dart';
import '../models/Prescription.dart';
import '../models/PrescriptionList.dart';

import '../Bloc.dart';
import 'AddPrescriptionWidget.dart';
import 'PrescriptionListItemWidget.dart';
import 'PrescriptionViewWidget.dart';

class PrescriptionListWidget extends StatelessWidget {
  const PrescriptionListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Bloc bloc = Bloc.of(context);
    return Container(
        padding: EdgeInsets.all(0),
        child: StreamBuilder<PrescriptionList>(
            stream: bloc.prescriptionListStream,
            initialData: PrescriptionList.empty(),
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
                        text: "Add Prescription Alert",
                        onPressed: () => _onAdd(context))
                  ],
                ),
              ];
              if (snapshot!.data!.prescriptions.isEmpty) {
                children.add(Column(children: const <Widget>[
                  VERTICAL_SPACER_20,
                  Text("There are no prescription alerts.",
                      style: TEXT_STYLE_SUBHEADING),
                  VERTICAL_SPACER_20,
                ]));
              } else {
                children.addAll(snapshot.data!.prescriptions
                    .map((trip) => PrescriptionListItemWidget(
                          trip: trip,
                          onEdit: (trip) => _onEdit(context, trip),
                          onDelete: (trip) => _onDelete(context, trip),
                          isCurrent: true,
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
    Prescription result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddPrescriptionWidget(bloc.commandStateStream!),
            fullscreenDialog: true));

    bloc.addPrescription(result);
  }

  _onEdit(BuildContext context, Prescription prescription) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PrescriptionViewWidget(prescription: prescription),
            fullscreenDialog: true));
  }

  _onDelete(BuildContext context, Prescription prescription) {
    Bloc bloc = Bloc.of(context);
    bloc.deletePrescription(prescription);
  }
}

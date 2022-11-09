import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/Document.dart';

import '../services/ViewerService.dart';
import 'DocumentationItemWidget.dart';
import '../Bloc.dart';

class DocumentationWidget extends StatelessWidget {
  DocumentationWidget();

  @override
  Widget build(BuildContext context) {
    Bloc bloc = Bloc.of(context);
    return Container(
        margin: EdgeInsets.all(20),
        child: StreamBuilder<List<Document>>(
            stream: bloc?.pageDocumentsStream,
            initialData: [],
            builder: (context, snapshot) {
              Iterable<dynamic>? docData = snapshot.data?.map(
                  (Document document) =>
                      DocumentationItemWidget(document, onTap));

              List<Widget>? childWidgets = List.from(docData!);
              return ListView(
                children: childWidgets,
              );
            }));
  }

  onTap(BuildContext context, Document document) {
    DocumentationService.onTap(context, document);
  }

  Future<String> convert(BuildContext context, String path) async {
    final ByteData bytes = await DefaultAssetBundle.of(context).load(path);
    final Uint8List list = bytes.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final convertedDocumentPath = '${tempDir.path}/$path';
    // final file = await File(convertedDocumentPath).create(recursive: true);
    // file.writeAsBytesSync(list);
    return convertedDocumentPath;
  }
}

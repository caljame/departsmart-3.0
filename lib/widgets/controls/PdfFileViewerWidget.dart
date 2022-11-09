import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

import '../../constants/Ui.dart';
import 'PdfFileViewerScaffold.dart';

class PdfFileViewerWidget extends StatelessWidget {
  String _name = "";
  String _pathPDF = "";
  bool _downloadable = false;

  PdfFileViewerWidget(this._name, this._pathPDF, this._downloadable);

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];
    if (this._downloadable) {
      actions.add(IconButton(
          padding: EdgeInsets.all(0),
          icon: const Icon(
            Icons.file_download,
            size: 24,
            color: COLOR_WHITE,
          ),
          onPressed: () => _onOpen(context)));
    }
    return PdfFileViewerScaffold(
        appBar: AppBar(
          backgroundColor: COLOR_DARK_BLUE,
          title: Text(_name),
          actions: actions,
        ),
        path: _pathPDF);
  }

  _onOpen(BuildContext context) async {
    await OpenFile.open(_pathPDF);
  }
}

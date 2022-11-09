import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ignore: unused_import
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

import '../../constants/Ui.dart';
import '../../models/Directory.dart';

class PdfFileViewerScaffold extends StatefulWidget {
  final PreferredSizeWidget appBar;
  final String path;
  final bool primary;

  const PdfFileViewerScaffold({
    Key? key,
    required this.appBar,
    required this.path,
    this.primary = true,
  }) : super(key: key);

  @override
  _PDFViewScaffoldState createState() => _PDFViewScaffoldState();
}

class _PDFViewScaffoldState extends State<PdfFileViewerScaffold> {
  final String PDF_EMAIL_TEXT = "PDFs cannot be completed in the app. " +
      "They can be emailed to your CDC account for completion and submittal.";

  bool _isLoading = true;
  PDFDocument? document;

  final double PDF_EMAIL_TEXT_HEIGHT = 80;

  Rect? _rect;
  Timer? _resizeTimer;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    document = PDFDocument();

    setState(() => _isLoading = false);
  }

  changePDF(value, path) async {
    setState(() => _isLoading = true);
    if (value == 1) {
      document = await PDFDocument.fromAsset(path);
    } else if (value == 2) {
      document = await PDFDocument.fromURL(
        path,
      );
    } else {
      document = await PDFDocument.fromAsset('assets/sample.pdf');
    }
    setState(() => _isLoading = false);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
    //pdfViwerRef.close();
    //pdfViwerRef.dispose();
  }

  Directory? getApplicationDocumentsDirectory() {
    Directory dir = Directory(name: "dir_name", path: "dir_path");
    return dir;
  }

  @override
  Widget build(BuildContext context) {
    if (_rect == null) {
      _rect = _buildRect(context);

      changePDF(1, widget.path);
    } else {
      final rect = _buildRect(context);
      if (_rect != rect) {
        _rect = rect;
        _resizeTimer?.cancel();
        _resizeTimer = Timer(const Duration(milliseconds: 300), () {
          //  pdfViwerRef.resize(_rect);
        });
      }
    }
    return Scaffold(
      appBar: widget.appBar,
      body: const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(width: 0.5, color: COLOR_GREY),
              bottom: BorderSide(width: 0.5, color: COLOR_GREY),
            ),
            color: COLOR_LIGHT_GREY,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          height: PDF_EMAIL_TEXT_HEIGHT,
          alignment: Alignment.center,
          child: Text(PDF_EMAIL_TEXT)),
    );
  }

  Rect _buildRect(BuildContext context) {
    final fullscreen = widget.appBar == null;

    final mediaQuery = MediaQuery.of(context);
    final topPadding = widget.primary ? mediaQuery.padding.top : 0.0;
    final top =
        fullscreen ? 0.0 : widget.appBar.preferredSize.height + topPadding;
    var height = mediaQuery.size.height - top - PDF_EMAIL_TEXT_HEIGHT;
    if (height < 0.0) {
      height = 0.0;
    }

    return Rect.fromLTWH(0.0, top, mediaQuery.size.width, height);
  }
}

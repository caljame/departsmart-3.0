import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/Ui.dart';
import '../../services/ViewerService.dart';

class HtmlFileViewerWidget extends StatefulWidget {
  String title;
  String html;

  HtmlFileViewerWidget({Key? key, required this.title, required this.html})
      : super(key: key);

  @override
  HtmlFileViewerWidgetState createState() => new HtmlFileViewerWidgetState();
}

class HtmlFileViewerWidgetState extends State<HtmlFileViewerWidget> {
  double _fontSize = 18.0;

  get customTextStyle => null;

  @override
  void initState() {
    super.initState();
  }

  void _zoomIn() {
    setState(() {
      _fontSize += 2;
    });
  }

  void _zoomOut() {
    setState(() {
      _fontSize -= 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    Style textStyle = Style(
        color: TEXT_STYLE_HTML_DEFAULT.color,
        fontFamily: TEXT_STYLE_HTML_DEFAULT.fontFamily,
        //   fontSize: _fontSize,
        fontWeight: TEXT_STYLE_HTML_DEFAULT.fontWeight);
    // decoration: TEXT_STYLE_HTML_DEFAULT.decoration);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: COLOR_DARK_BLUE,
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.zoom_in),
              onPressed: () => _zoomIn(),
            ),
            IconButton(
              icon: Icon(Icons.zoom_out),
              onPressed: () => _zoomOut(),
            ),
          ],
        ),
        body: ListView(children: [
          Html(
            data: widget.html,
            style: {
              'table': Style(backgroundColor: COLOR_WHITE),
            },
            /*
                 
                 ;
                  case "h2":
                    return baseStyle.merge(TextStyle(
                        height: 1.9,
                        fontSize: _fontSize + 6,
                        fontWeight: FontWeight.w900));
                  case "h3":
                    return baseStyle.merge(TextStyle(
                        height: 1.5,
                        fontSize: _fontSize + 3,
                        fontWeight: FontWeight.w900));
                  case "h4":
                    return baseStyle.merge(TextStyle(
                        fontSize: _fontSize + 1,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic));
                  case "i":
                    return baseStyle.merge(TextStyle(
                        fontSize: _fontSize - 3, fontStyle: FontStyle.italic));
                  case "strong":
                    return baseStyle.merge(TextStyle(
                        decorationThickness: 20,
                        color: COLOR_DARK_BLUE,
                        backgroundColor: COLOR_LIGHT_GREY,
                        height: 1,
                        fontSize: _fontSize + 3,
                        fontWeight: FontWeight.w900,
                        decoration: TextDecoration.none));
                }
              }
              return baseStyle;
            },
            */
          )
        ]));
  }

  TextStyle customStyle(dom.Node node, TextStyle baseStyle) {
    if (node is dom.Element) {
      switch (node.localName) {
        case "h1":
          return baseStyle.merge(TextStyle(
              height: 2,
              fontSize: _fontSize + 10,
              fontWeight: FontWeight.w900));
        case "h2":
          return baseStyle.merge(TextStyle(
              height: 1.9,
              fontSize: _fontSize + 6,
              fontWeight: FontWeight.w900));
        case "h3":
          return baseStyle.merge(TextStyle(
              height: 1.5,
              fontSize: _fontSize + 3,
              fontWeight: FontWeight.w900));
        case "h4":
          return baseStyle.merge(TextStyle(
              fontSize: _fontSize + 1,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic));
        case "i":
          return baseStyle.merge(
              TextStyle(fontSize: _fontSize - 3, fontStyle: FontStyle.italic));
        case "strong":
          return baseStyle.merge(TextStyle(
              decorationThickness: 20,
              color: COLOR_DARK_BLUE,
              backgroundColor: COLOR_LIGHT_GREY,
              height: 1,
              fontSize: _fontSize + 3,
              fontWeight: FontWeight.w900,
              decoration: TextDecoration.none));
      }
    }
    return baseStyle;
  }

  Future<File> createFileOfPdfUrl(String url) async {
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<void> _launch(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}

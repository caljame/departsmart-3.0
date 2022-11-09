import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:path_provider/path_provider.dart';
import '../framework/LinkButtonOnItsOwnLineWidget.dart';
import '../models/Document.dart';
import '../widgets/DocumentationItemWidget.dart';

import '../widgets/WebviewScaffold.dart';
import '../widgets/controls/HtmlFileViewerWidget.dart';
import '../widgets/controls/PdfFileViewerWidget.dart';
import '../widgets/controls/VideoViewerWidget.dart';

import '../Bloc.dart';

class DocumentationService {
  static onTap(BuildContext context, Document document) async {
    if ((document.pdf != null) && (document.pdf?.isNotEmpty ?? false)) {
      viewPdf(context, document.name!, document.pdf!, document.downloadable);
    } else if ((document.html != null) &&
        (document.html?.isNotEmpty ?? false)) {
      viewHtml(context, document.name!, document.html!, '');
    } else if ((document.video != null) &&
        (document.video?.isNotEmpty ?? false)) {
      viewVideo(context, document.name!, document.video!);
    } else if ((document.webpage != null) &&
        (document.webpage?.isNotEmpty ?? false)) {
      viewWebpage(context, document.name!, document.webpage!);
    } else if ((document.widgetPath != null) &&
        (document.widgetPath?.isNotEmpty ?? false)) {
      viewWidget(context, document.name!, document.widgetPath!);
    } else if ((document.subpage != null) && (document.subpage! > 0)) {
      viewSubpageDialog(context, document.name!, document.subpage ?? 0);
    } else if ((document.email != null) &&
        (document.email?.isNotEmpty ?? false)) {
      launchEmail(document.email!);
    } else if ((document.phone != null) &&
        (document.phone?.isNotEmpty ?? false)) {
      launchPhoneCall(document.phone!);
    }
    //var test = "true";
  }

  static Future<void> launchEmail(String emailAddress) async {
    var url = Uri.parse("mailto:${emailAddress}");

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $emailAddress';
    }
  }

  static Future<void> launchPhoneCall(String phone) async {
    var url = Uri.parse(phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static viewSubpageDialog(
      BuildContext context, String documentName, int page) async {
    List<Document?>? documentsForPage =
        Bloc?.of(context)?.getDocumentsForPage(page) ?? [];

    await showDialog<Document?>(
        context: context,
        builder: (BuildContext context) {
          List<Widget>? list = List.from(documentsForPage.map(
              (Document? document) =>
                  DocumentationItemWidget(document!, (context, document) {
                    onTap(context, document);
                  })));
          list.add(LinkButtonOnItsOwnLineWidget(
              "Close", () => Navigator.pop(context)));
          return SimpleDialog(
              title: Text(documentName),
              contentPadding: const EdgeInsets.all(20.0),
              children: list);
        });
  }

  static viewPdf(
      BuildContext context, String name, String path, bool downloadable) {
    try {
      convert(context, path).then((newPath) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PdfFileViewerWidget(name, newPath, downloadable),
                fullscreenDialog: true));
      }).catchError((error, stacktrace) {
        debugPrint(stacktrace);
      });
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  static viewWebpage(BuildContext context, String name, String url) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebviewScaffold(
                url: url,
                appBar: AppBar(
                  title: Text(name),
                )),
            fullscreenDialog: true));
  }

  static viewHtml(
      BuildContext context, String name, String path, String split) async {
    String fileHtml = await rootBundle.loadString('${path}');

    // ignore: use_build_context_synchronously
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HtmlFileViewerWidget(
                  title: name,
                  html: fileHtml,
                ),
            fullscreenDialog: true));
  }

  static viewVideo(BuildContext context, String name, String video) {
    try {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoFileViewerWidget(name, video),
              fullscreenDialog: true));
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  static viewWidget(BuildContext context, String name, String widgetPath) {
    Navigator.pushNamed(context, widgetPath);
  }

  static Future<String> convert(BuildContext context, String path) async {
    final ByteData bytes = await DefaultAssetBundle.of(context).load(path);
    final Uint8List list = bytes.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final convertedDocumentPath = '${tempDir.path}/$path';
    final file = await File(convertedDocumentPath).create(recursive: true);
    file.writeAsBytesSync(list);
    return convertedDocumentPath;
  }
}

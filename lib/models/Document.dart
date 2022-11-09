import 'package:flutter/material.dart';

class Document {
  String? _name;
  String? _html;
  String ?_webpage;
  String? _pdf;
  String? _email;
  String? _phone;
  String? _text;
  String? _video;
  String? _widgetPath;
  int? _subpage;
  bool _downloadable = false;

  Document.webpage(this._name, this._webpage);

  Document.html(this._name, this._html);

  Document.pdf(this._name, this._pdf){
    this._downloadable = false;
  }

  Document.downloadablePdf(name, pdf){
    _downloadable = true;
  }

  Document.email(this._name, this._email);

  Document.phone(this._name, this._phone);

  Document.text(this._text);

  Document.subpage(this._name, this._subpage);

  Document.video(this._name, this._video);

  Document.widgetPath(this._name, this._widgetPath);

  String? get name => _name;

  IconData? get icon {
    if ((_pdf != null) && (_pdf!.isNotEmpty)) {
      return Icons.import_contacts;
    } else if ((_html != null) && (_html!.isNotEmpty)) {
      return Icons.import_contacts;
    } else if ((_subpage != null) && (_subpage! > 0)) {
      return Icons.arrow_forward;
    } else if ((_video != null) && (_video!.isNotEmpty)) {
      return Icons.play_circle_outline;
    } else if ((_webpage != null) && (_webpage!.isNotEmpty)) {
      return Icons.web_asset;
    } else if ((_widgetPath != null) && (_widgetPath!.isNotEmpty)) {
      return Icons.list;
    } else if ((_email != null) && (_email!.isNotEmpty)) {
      return Icons.email;
    } else if ((_phone != null) && (_phone!.isNotEmpty)) {
      return Icons.phone;
    } else {
      return Icons.healing;
    }
  }

  String? get widgetPath => _widgetPath;

  String ?get description {
    if ((_webpage != null) && (_webpage!.isNotEmpty)) {
      return "Webpage";
    }
    if ((_html != null) && (_html!.isNotEmpty)) {
      return "Document";
    }
    if ((_pdf != null) && (_pdf!.isNotEmpty)) {
      return "Pdf Document";
    }
    if ((_email != null) && (_email!.isNotEmpty)) {
      return "Email";
    }
    if ((_phone != null) && (_phone!.isNotEmpty)) {
      return "Phone Number";
    }
    if ((_video != null) && (_video!.isNotEmpty)) {
      return "Video";
    }
    if ((_subpage != null) && (_subpage! > 0)) {
      return "More Options >";
    }
    if ((_widgetPath != null) && (_widgetPath!.isNotEmpty)) {
      return "Program";
    }
    return "";
  }

  String? get html => _html;

  String? get webpage => _webpage;

  String? get pdf => _pdf;

  String? get email => _email;

  String? get phone => _phone;

  String? get text => _text;

  String? get video => _video;

  int? get subpage => _subpage;

  bool get downloadable => _downloadable;


}

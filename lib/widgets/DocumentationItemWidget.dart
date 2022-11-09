import 'package:flutter/material.dart';
import '../constants/Ui.dart';
import '../models/Document.dart';

class DocumentationItemWidget extends StatelessWidget {
  Document? _document;
  Function _onTapCallback;

  DocumentationItemWidget(this._document, this._onTapCallback, {super.key});

  @override
  Widget build(BuildContext context) {
    if ((_document?.text != null) && (_document?.text?.isEmpty ?? true)) {
      var str = _document?.text ?? "";
      return Text(str ?? "", style: TEXT_STYLE_REGULAR);
    }
    return ListTile(
      contentPadding: EdgeInsets.all(1),
      leading: Container(
        decoration: const BoxDecoration(
            color: COLOR_DARK_BLUE,
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: IconButton(
          icon: Icon(_document!.icon, color: Colors.white),
          onPressed: () {},
        ),
      ),
      title: Text(
        _document?.name ?? "",
        style: TEXT_STYLE_SUBHEADING,
      ),
      subtitle: Text(_document?.description ?? "", style: TEXT_STYLE_REGULAR),
      onTap: () => _onTapCallback(context, _document),
    );
  }
}

import 'package:flutter/material.dart';

import '../constants/Ui.dart';

class AboutWidget extends StatelessWidget {
  VoidCallback? _onPrivacyPolicySelected;

  AboutWidget({required VoidCallback onPrivacyPolicySelected}) {
    this._onPrivacyPolicySelected = onPrivacyPolicySelected;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      const Padding(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Text("""
          Lorem ipsum dolor sit amet, est elitr corrumpit vituperata ut. Has in idque consetetur, quot persius praesent an eos, insolens mediocritatem cum at. Vel ea albucius legendos. Movet animal albucius ius no. Eam copiosae platonem facilisis et.
          \r
          Duo et omnis errem. Quo wisi repudiandae an, mel ne albucius voluptua petentium, justo iudico consequat ut mel. Ius te minim aperiri philosophia, sed cu habeo erant sensibus, vim referrentur reprehendunt te. Ad dictas audire omnesque eam, an scripta nonumes mentitum his, quo ad sale luptatum definiebas. Falli vocibus qualisque ex eos, elitr sadipscing eu mea.
          """, style: TEXT_STYLE_REGULAR)),
      Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(width: 0.5, color: COLOR_GREY),
              bottom: BorderSide(width: 0.5, color: COLOR_GREY),
            ),
            color: COLOR_LIGHT_GREY,
          ),
          child: ListTile(
            onTap: () => _onPrivacyPolicySelected!(),
            title: Text("Privacy Policy", style: TEXT_STYLE_SUBHEADING),
            trailing: Icon(Icons.arrow_forward_ios),
          ))
    ]);
  }
}

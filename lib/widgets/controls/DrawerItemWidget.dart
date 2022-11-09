import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/Ui.dart';

class DrawerItemWidget extends StatelessWidget {
  final String title;
  final String? phone;
  final String? email;
  final bool biggerText;
  final IconData icon;
  final VoidCallback callback;

  DrawerItemWidget(
      {required this.title,
      this.phone,
      this.email,
      this.biggerText = false,
      required this.icon,
      required this.callback}) {}

  @override
  Widget build(BuildContext context) {
    IconData iconData = this.icon != null
        ? icon
        : phone != null
            ? Icons.phone
            : email != null
                ? Icons.email
                : Icons.arrow_forward_ios;
    VoidCallback onTap = phone != null
        ? phoneCallback
        : this.email != null
            ? emailCallback
            : callback;
    return Container(
        child: ListTile(
            dense: true,
            title: Padding(
                padding: EdgeInsets.only(left: biggerText ? 5 : 10),
                child: Text(biggerText ? "${title}" : "- ${title}",
                    style: biggerText
                        ? TEXT_DRAWER_ITEM_BIGGER
                        : TEXT_DRAWER_ITEM_SMALLER)),
            trailing: Icon(
              iconData,
              size: 16,
//              color: COLOR_BLACK,
            ),
            onTap: onTap));
  }

  phoneCallback() async {
    print("title:  + ${title}");
    var url = Uri.parse("tel:${phone}");
    print("phone:" + url.path);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch phone: ${phone}';
    }
  }

  emailCallback() async {
    var url = Uri.parse("mailto:${email}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch email: ${email}';
    }
  }
}

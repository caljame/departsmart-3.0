import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../../constants/Ui.dart';

import '../USEmbassyInformationWidget.dart';
import 'DrawerHeadingWidget.dart';

import 'DrawerItemWidget.dart';
import 'DrawerSubheadingWidget.dart';

class DrawerWidget extends StatelessWidget {
  VoidCallback onHomeSelected;
  VoidCallback onAboutSelected;
  IconData? drawerIcon;

  DrawerWidget({required this.onHomeSelected, required this.onAboutSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
            child: ListView(children: <Widget>[
      Container(
          color: COLOR_DARK_BLUE,
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: Row(
            children: [
              Image.asset(
                "images/launcher/icon.png",
                width: 100,
              ),
              HORIZONTAL_SPACER_20,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("CDC", style: TEXT_STYLE_HEADING_WHITE),
                  Text("DepartSmart", style: TEXT_STYLE_HEADING_WHITE)
                ],
              )
            ],
          )),
      VERTICAL_SPACER_20,
      DrawerItemWidget(
        title: "HOME",
        biggerText: true,
        callback: onHomeSelected,
        icon: Icons.label,
      ),
      Divider(thickness: 2),
      DrawerHeadingWidget(title: "Emergency Contacts", children: [
        DrawerSubheadingWidget(title: "Emergency Operations Center (EOC)"),
        DrawerItemWidget(
          title: "Watch Desk Phone",
          phone: "770-488-7100",
          icon: Icons.phone,
          callback: () {},
        ),
        DrawerItemWidget(
          title: "Watch Desk Email",
          email: "eocreport@cdc.gov",
          callback: () {},
          icon: Icons.email,
        ),
        DrawerItemWidget(
            title: "Sensitive Information Emails",
            email: "EOCsensinfo@cdc.gov",
            callback: () {},
            icon: Icons.email),
        DrawerSubheadingWidget(title: "Security Operations Center (SOC)"),
        DrawerItemWidget(
            title: "Roybal plus all other locations",
            phone: "800-937-5157",
            callback: () {},
            icon: Icons.phone),
        DrawerItemWidget(
          title: "Ft. Collins",
          phone: "970-221-6400",
          callback: () {},
          icon: Icons.phone,
        ),
        DrawerSubheadingWidget(title: "Global Security Team, PHIO/OSSAM"),
        DrawerItemWidget(
          title: "Phone",
          phone: "404-639-5000",
          icon: Icons.phone,
          callback: () {},
        ),
        DrawerItemWidget(
          title: "Email",
          email: "globalsecurity@cdc.gov",
          icon: Icons.email,
          callback: () {},
        ),
        DrawerSubheadingWidget(title: "CDC Occupational Health Clinic (OHC)"),
        DrawerItemWidget(
          title: "On-Call Physician (24/7)",
          phone: "404-639-3385",
          callback: () {},
          icon: Icons.phone,
        ),
      ]),
      VERTICAL_SPACER_20,
      DrawerHeadingWidget(title: "Non-Emergency Contacts", children: [
        DrawerSubheadingWidget(title: "Occupational Health Clinics (OHC)"),
        DrawerItemWidget(
          title: "Roybal",
          phone: "404-639-3385",
          icon: Icons.phone,
          callback: () {},
        ),
        DrawerItemWidget(
          title: "Chamblee",
          phone: "770-488-7824",
          icon: Icons.phone,
          callback: () {},
        ),
        DrawerItemWidget(
          title: "Email",
          email: "clinicinfo@cdc.gov",
          icon: Icons.email,
          callback: () {},
        ),
        DrawerSubheadingWidget(title: "Safety (OSSAM)"),
        DrawerItemWidget(
          title: "IMS Safety Officer",
          email: "eocsafety@cdc.gov",
          icon: Icons.email,
          callback: () {},
        ),
        DrawerSubheadingWidget(title: "Security (OSSAM)"),
        DrawerItemWidget(
          title: "SOC",
          phone: "404-639-2888",
          icon: Icons.phone,
          callback: () {},
        ),
        DrawerItemWidget(
          title: "Email",
          email: "cdcsecurit@cdc.gov",
          icon: Icons.email,
          callback: () {},
        ),
        DrawerSubheadingWidget(title: "Transportation/Fleet Services (OSSAM)"),
        DrawerItemWidget(
          title: "Roybal Motor Pool",
          phone: "404-718-1994",
          callback: () {},
          icon: Icons.phone,
        ),
        DrawerItemWidget(
          title: "Chamblee Motor Pool ",
          phone: "770-488-7801",
          icon: Icons.phone,
          callback: () {},
        ),
        DrawerSubheadingWidget(title: "WorkLife Wellness Office"),
        DrawerItemWidget(
          title: "Training and Response Team",
          email: "wellnesstraining@cdc.gov",
          callback: () {},
          icon: Icons.email,
        ),
        DrawerItemWidget(
          title: "Employee Assistance Program ",
          phone: "770-488-7825",
          icon: Icons.phone,
          callback: () {},
        ),
        DrawerItemWidget(
          title: "EAP (Toll-free)",
          phone: "314-387-4701",
          icon: Icons.phone,
          email: '',
          callback: () {},
        ),
        DrawerItemWidget(
          title: "Email",
          email: "eap@cdc.gov",
          callback: () {},
          icon: Icons.phone,
        ),
        DrawerSubheadingWidget(title: "CGH Travel"),
        DrawerItemWidget(
          title: "Global Travel Office (GTO) ",
          phone: "404-718-8900",
          callback: () {},
          icon: Icons.phone,
        ),
        DrawerItemWidget(
          title: "Omega Phone",
          phone: "855-326-5411",
          icon: Icons.phone,
          callback: () {},
        ),
        DrawerItemWidget(
          title: "Omega Webpage",
          icon: Icons.web,
          callback: () => webpageCallback(context, "Omega Webpage",
              "https://www.omegatravel.com/government-travel/"),
        ),
        DrawerSubheadingWidget(
            title: "Foreign Travel Security Training PHIO/OSSAM"),
        DrawerItemWidget(
          title: "Email",
          email: "ossaminternationaltravel@cdc.gov",
          callback: () {},
          icon: Icons.email,
        ),
      ]),
      Divider(thickness: 2),
      DrawerItemWidget(
        title: "US EMBASSY FINDER",
        biggerText: true,
        callback: () => this.usEmbassyCallback(context),
        icon: Icons.label,
      ),
      DrawerItemWidget(
          title: "ABOUT",
          biggerText: true,
          callback: onAboutSelected,
          icon: Icons.label),
    ])));
  }

//  Document.widgetPath("US Embassy Information", "/us_embassy"),
  webpageCallback(BuildContext context, String title, String url) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Scaffold(
                body: Text(url),
                appBar: AppBar(
                  title: Text(title),
                )),
            fullscreenDialog: true));
  }

  usEmbassyCallback(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => USEmbassyInformationWidget(),
            fullscreenDialog: true));
  }
}

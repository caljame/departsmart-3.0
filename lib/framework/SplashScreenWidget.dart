import 'package:flutter/material.dart';

import 'package:splash_screen_view/SplashScreenView.dart';
import '../Constants/Ui.dart';

import '../Bloc.dart';
import 'AppWidget.dart';

class SplashScreenWidget extends StatefulWidget {
  @override
  _SplashScreenWidgetState createState() => new _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  @override
  Widget build(BuildContext context) {
    Bloc bloc = Bloc.of(context);
    bloc.initializePrefs();

    return SplashScreenView(
      duration: 5,
      navigateRoute: AppWidget(),
      text: "CDC DepartSmart",
      textStyle: TEXT_STYLE_HEADING,

      imageSrc: "images/launcher/icon.png",
      backgroundColor: Colors.white,

      // logoSize: 100.0,
    );
  }
}

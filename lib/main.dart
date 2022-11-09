import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'Bloc.dart';
import 'Constants/Ui.dart';
import 'framework/SplashScreenWidget.dart';
import 'models/Prescription.dart';

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

// Custom typedefs
typedef DeleteCallback = void Function(
    BuildContext buildContext, Prescription prescription);

void main() async {
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  runApp(Bloc(
    child: MaterialApp(
      home: SplashScreenWidget(),
      routes: const <String, WidgetBuilder>{},
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: COLOR_DARK_BLUE,
          iconTheme: const IconThemeData(color: COLOR_GREY),
          colorScheme:
              ColorScheme.fromSwatch().copyWith(primary: COLOR_DARK_BLUE),
          //      accentColor: COLOR_GREY,
          textTheme: const TextTheme(bodyText2: TextStyle(color: COLOR_GREY)),
          inputDecorationTheme: const InputDecorationTheme(
              labelStyle: TextStyle(color: COLOR_GREY),
              helperStyle: TextStyle(color: COLOR_GREY),
              hintStyle: TextStyle(color: COLOR_GREY),
              errorStyle: TextStyle(color: COLOR_RED))),
    ),
  ));
}

//import 'package:background_fetch/background_fetch.dart';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;
import '../Bloc.dart';
import '../constants/Pages.dart';
import '../constants/Ui.dart';
import '../main.dart';
import '../models/CommandData.dart';
import '../services/PagesService.dart';
import 'AboutWidget.dart';
import 'AlertListWidget.dart';
import 'DocumentationWidget.dart';

import 'PrivacyPolicyWidget.dart';

import 'HomeWidget.dart';
import 'PrescriptionListWidget.dart';
import 'PrivacyPolicyWidget.dart';
import 'TripListWidget.dart';
import 'controls/DrawerWidget.dart';
import 'controls/DrawerWidget.dart';

class ScaffoldWidget extends StatefulWidget {
  Stream<CommandData>? _commandStream;

  ScaffoldWidget(
      {required Key? key, required Stream<CommandData>? commandStream})
      : super(key: key) {
    this._commandStream = commandStream;
  }

  @override
  _ScaffoldWidgetState createState() {
    return _ScaffoldWidgetState(_commandStream!);
  }
}

class _ScaffoldWidgetState extends State<ScaffoldWidget> {
  final GlobalKey<ScaffoldState>? _scaffoldKey = new GlobalKey<ScaffoldState>();
  final PageController? _pageController = PageController(initialPage: 0);
  final Duration? _duration = Duration(milliseconds: 500);
  final Curve? _curve = Curves.ease;
  bool _firstCheckCompleted = false;
  final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  Timer? _timer;

  _ScaffoldWidgetState(Stream<CommandData> commandStream) {
    commandStream.listen((command) => _handleCommand(command));

    _pageController!.addListener!(() {
      Bloc bloc = Bloc.of(context);
      bloc.view = _pageController!.page!.round();
    });
  }

  @override
  void initState() {
    super.initState();
    setupState();
  }

  void setupState() {
    var initializationSettingsAndroid =
        // AndroidInitializationSettings('@mipmap/icon.png');
        AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: _onDidReceiveLocalNotification);

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    // ignore: unused_element
    //_localNotificationsPlugin.initialize(initializationSettings,
    ///    onSelectNotification: onSelectNotification);

    _timer = Timer.periodic(Duration(minutes: 1), (Timer t) => _checkThings());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    await showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: title != null ? Text(title) : null,
        content: body != null ? Text(body) : null,
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
            },
          )
        ],
      ),
    );
  }

  Future onSelectNotification(String? payload) async {
    debugPrint("onSelectNotification ${payload}");
  }

  _checkThings() {
    Bloc bloc = Bloc.of(context);
    bloc.checkAlertsExternal();
  }

  Widget pageViewItemBuilder(BuildContext context, int index) {
    if (index == PAGE_HOME) {
      return ListView(children: [
        AlertListWidget(),
        HomeWidget(
          onTripsSelected: () => this._handleTripsSelected(context),
          onPrescriptionsSelected: () =>
              this._handlePrescriptionsSelected(context),
        )
      ]);
    } else if (index == PAGE_TRIPS) {
      return TripListWidget();
    } else if (index == PAGE_PRESCRIPTIONS) {
      return PrescriptionListWidget();
    } else if (index == PAGE_ABOUT) {
      return AboutWidget(
          onPrivacyPolicySelected: () =>
              this._handlePrivacyPolicySelected(context));
    } else if (index == PAGE_PRIVACY_POLICY) {
      return PrivacyPolicyWidget();
    } else {
      return DocumentationWidget();
    }
  }

  _handleCommand(CommandData command) {
    if ((command.isMessage()) && (_scaffoldKey!.currentState != null)) {
      /*
      _scaffoldKey
        ?.currentState!.showSnackBar(SnackBar(content: Text(command.data!))); */
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(command.data!)));
    }
  }

  _handleHomeSelected(BuildContext context) {
    _pageController?.animateToPage(PAGE_HOME,
        duration: _duration!, curve: _curve!);
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  _handleTripsSelected(BuildContext context) {
    _pageController?.animateToPage(PAGE_TRIPS,
        duration: _duration!, curve: _curve!);
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  _handlePrescriptionsSelected(BuildContext context) {
    _pageController?.animateToPage(PAGE_PRESCRIPTIONS,
        duration: _duration!, curve: _curve!);
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  _handleAboutSelected(BuildContext context) {
    _pageController!
        .animateToPage(PAGE_ABOUT, duration: _duration!, curve: _curve!);
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  _handlePrivacyPolicySelected(BuildContext context) {
    _pageController?.animateToPage(PAGE_PRIVACY_POLICY,
        duration: _duration!, curve: _curve!);
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_firstCheckCompleted) {
      _checkThings();
      _firstCheckCompleted = true;
    }

    Bloc bloc = Bloc.of(context);

    var streamBuilder = StreamBuilder<int>(
        stream: bloc.pageStateStream,
        initialData: 0,
        builder: (context, snapshot) {
          return Text(
            "${bloc.pageName}",
            style: TEXT_STYLE_APP_HEADING,
          );
        });

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Container(
            child: streamBuilder,
            width: double.infinity,
          ),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 10),
                child: GestureDetector(
                    onLongPress: () =>
                        _onDeleteTripsPrescriptionsConfirm(context),
                    child: Image.asset("images/ossam-white.png", width: 70.0)))
          ],
        ),
        drawer: DrawerWidget(
          onHomeSelected: () => _handleHomeSelected(context),
          onAboutSelected: () => _handleAboutSelected(context),
        ),
        body: Center(
            child: PageView.builder(
                controller: _pageController,
                itemBuilder: pageViewItemBuilder,
                itemCount: PAGE_COUNT)),
        bottomNavigationBar: StreamBuilder<int>(
            stream: bloc.pageStateStream,
            initialData: PAGE_HOME,
            builder: (context, snapshot) {
              bool homeSelected = snapshot.data == PAGE_HOME;
              bool tripsSelected = snapshot.data == PAGE_TRIPS;
              bool prescriptionsSelected = snapshot.data == PAGE_PRESCRIPTIONS;
              bool aboutSelected = snapshot.data == PAGE_ABOUT ||
                  snapshot.data == PAGE_PRIVACY_POLICY;
              return BottomNavigationBar(
                unselectedItemColor: COLOR_GREY,
                selectedItemColor: homeSelected
                    ? COLOR_GREY
                    : tripsSelected
                        ? COLOR_GREY
                        : aboutSelected
                            ? COLOR_GREY
                            : COLOR_DARK_BLUE,
                currentIndex: homeSelected
                    ? PAGE_SAFETY
                    : tripsSelected
                        ? PAGE_SAFETY
                        : prescriptionsSelected
                            ? PAGE_SAFETY
                            : aboutSelected
                                ? PAGE_SAFETY
                                : snapshot.data! - PAGE_OFFSET,
                type: BottomNavigationBarType.fixed,
                onTap: (index) => {
                  _pageController!.animateToPage(index + PAGE_OFFSET,
                      duration: _duration!, curve: _curve!)
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.lock),
                      label: PagesService.getPageName(PAGE_SAFETY)),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.security),
                      label: PagesService.getPageName(PAGE_SECURITY)),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.error),
                      label: PagesService.getPageName(PAGE_EMERGENCIES)),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.healing),
                    label: PagesService.getPageName(PAGE_HEALTH),
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: PagesService.getPageName(PAGE_TOOLS)
                      //textstyle: TEXT_STYLE_TOOLBAR,

                      ),
                ],
              );
            }));
  }

  _onDeleteTripsPrescriptionsConfirm(BuildContext context) {
    _showConfirmDialog(context).then((result) {
      if (result == true) {
        Bloc.of(context).deleteAllTripsAndPrescriptions();
      }
    });
  }

  /*
              BottomNavigationBarItem(
                icon: Container(
                    margin: EdgeInsets.only(bottom: 7),
                    child: const Icon(
                        Icons.security,
                        size: 20.0,
                    ),
                ),
                label: PagesService.getPageName(PAGE_SECURITY),
                backgroundColor: Color.fromRGBO(36, 54, 101, 1.0),
            ),

   */

  Future<bool?> _showConfirmDialog(BuildContext context) async {
    return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm'),
            content: const Text(
                'Are you sure you want to delete all your trips and prescription alarms?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('No'),
              )
            ],
          );
        });
  }
}

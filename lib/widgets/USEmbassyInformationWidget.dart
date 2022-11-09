import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Bloc.dart';
import '../Constants/Ui.dart';
import '../constants/Embassies.dart';
import '../models/Embassy.dart';
import '../services/EmbassiesService.dart';

class USEmbassyInformationWidget extends StatefulWidget {
  USEmbassyInformationWidget({Key? key}) : super(key: key) {}

  @override
  _USEmbassyInformationWidgetState createState() =>
      _USEmbassyInformationWidgetState();
}

class _USEmbassyInformationWidgetState
    extends State<USEmbassyInformationWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _countryTextController = TextEditingController();
  Embassy? _embassy;

  _USEmbassyInformationWidgetState() {}

  @override
  Widget build(BuildContext context) {
    Bloc bloc = Bloc.of(context);

    List<Widget> formWidgetList = [];
    formWidgetList.add(_createCountryField());
    formWidgetList.add(Container(height: 20));
    if (_embassy != null) {
      formWidgetList.add(Container(height: 20));
      formWidgetList.add(Text("US Embassy in ${_embassy?.country}",
          style: TEXT_STYLE_HEADING));
      formWidgetList.add(Container(height: 20));
      formWidgetList.add(const Text(
        "Address",
        style: TEXT_STYLE_SUBHEADING,
      ));
      formWidgetList.add(GestureDetector(
          child: Text(_embassy!.address, style: TEXT_STYLE_LINK),
          onTapDown: (_) => _onTapAddress()));
      formWidgetList.add(Container(height: 20));
      formWidgetList.add(const Text("Website", style: TEXT_STYLE_SUBHEADING));
      formWidgetList.add(GestureDetector(
          child: Text(_embassy!.website, style: TEXT_STYLE_LINK),
          onTapDown: (_) => _onTapWebsite()));
      formWidgetList.add(Container(height: 20));
      formWidgetList.add(Text("Phone", style: TEXT_STYLE_SUBHEADING));
      formWidgetList.add(GestureDetector(
          child: Text(_embassy!.phone, style: TEXT_STYLE_LINK),
          onTapDown: (_) => _onTapPhone()));
    } else {
      formWidgetList
          .add(const Text("You must select a Country to see it embassy."));
    }

    return Scaffold(
        appBar: AppBar(
            title: Container(
          child: const Text(
            "US Embassy Finder",
            style: TEXT_STYLE_APP_HEADING,
          ),
        )),
        body: Container(
          padding: EdgeInsets.all(20.0),
          child: Form(key: _formKey, child: ListView(children: formWidgetList)),
        ));
  }

  Future<void> _onTapAddress() async {
    if (_embassy != null) {
    } else {
      return;
    }
    String embassyAddress = _embassy!.address;
    if (!_embassy!.address.contains(_embassy!.country)) {
      embassyAddress += ",${_embassy!.country}";
    }
    String mapsUrl =
        "https://www.google.com/maps/search/?api=1&query=${embassyAddress}";
    if (Platform.isIOS) {
      mapsUrl = "http://maps.apple.com/?q=${embassyAddress}";
    }
    if (await canLaunch(mapsUrl)) {
      await launch(mapsUrl);
    } else {
      throw 'Could not launch ${mapsUrl}';
    }
  }

  Future<void> _onTapWebsite() async {
    if (_embassy == Null as Embassy) {
      return;
    }
    if (_embassy!.website == Null as String) {
      return;
    }
    /*
    if (await canLaunch(_embassy?.website)) {
      await launch(_embassy?.website);
    } else {
      throw 'Could not launch ${_embassy?.website}';
    }

     */
  }

  Future<void> _onTapPhone() async {
    if (_embassy == Null as Embassy) {
      return;
    }
    if (_embassy!.phone == Null as Embassy) {
      return;
    }
    String phone = "tel:${_embassy?.phone}";
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      throw 'Could not launch ${phone}';
    }
  }

  TypeAheadFormField _createCountryField() {
    return TypeAheadFormField(
        textFieldConfiguration: TextFieldConfiguration(
          style: const TextStyle(color: COLOR_GREY),
          controller: _countryTextController,
          autofocus: true,
        ),
        suggestionsCallback: (pattern) {
          return EmbassiesService.getSuggestions(pattern);
        },
        autovalidate: true,
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion),
          );
        },
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        onSuggestionSelected: (suggestion) {
          _countryTextController.text = suggestion;
          var embassy = EMBASSIES.firstWhere(
              (embassy) =>
                  embassy.country.toLowerCase() == suggestion.toLowerCase(),
              orElse: () => Null as Embassy);
          setState(() {
            _embassy = embassy;
          });
        },
        validator: (value) {
          if (value == Null as String) {
            return 'Please select a Country';
          }
          var embassy = EMBASSIES.firstWhere(
              (embassy) =>
                  embassy.country.toLowerCase() == value?.toLowerCase(),
              orElse: () => Null as Embassy);
          {
            return 'Please select a valid Country';
          }
        });
  }
}

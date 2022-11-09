import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../models/Country.dart';
import '../services/CountriesService.dart';

import 'Countries.dart';
import 'Dates.dart';

class UiFactory {
  static Widget createNotesTextField(
      {@required textEditingController: TextEditingController,
      @required name: String}) {
    return TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: 3,
        inputFormatters: [
          FilteringTextInputFormatter(
              RegExp("^[A-Za-z0-9 _]*[A-Za-z0-9][A-Za-z0-9 _]*\$"),
              allow: false)
        ],
        decoration: InputDecoration(
            icon: const Icon(Icons.note_add),
            hintText: '${name}',
            labelText: 'Enter ${name}'),
        controller: textEditingController);
  }

  static Widget createTextField(
      {@required textEditingController: TextEditingController,
      @required name: String,
      @required autoFocus: bool}) {
    return TextFormField(
      autofocus: autoFocus,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          icon: const Icon(Icons.note_add),
          hintText: '${name}',
          labelText: 'Enter ${name}'),
      controller: textEditingController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a ${name}';
        }
      },
    );
  }

  static TypeAheadFormField createCountryField(
      {@required textEditingController: TextEditingController,
      @required name: String}) {
    return TypeAheadFormField(
        textFieldConfiguration: TextFieldConfiguration(
          decoration: InputDecoration(
              icon: const Icon(Icons.panorama),
              hintText: '${name}',
              labelText: 'Select the ${name}'),
          controller: textEditingController,
        ),
        suggestionsCallback: (pattern) {
          return CountriesService.getSuggestions(pattern);
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion),
          );
        },
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        onSuggestionSelected: (suggestion) {
          textEditingController.text = suggestion;
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please select a ${name}';
          }
          var country = COUNTRIES.firstWhere(
              (country) => country.name.toLowerCase() == value.toLowerCase(),
              orElse: () => null as Country);
          // ignore: unnecessary_null_comparison
          if (country != null) {
          } else {
            return 'Please select a valid ${name}';
          }
        },
        onSaved: (value) => print(value));
  }

  static Color createColorFromHex(String hexString) {
    int red = int.parse("0x${hexString.substring(0, 2)}");
    int green = int.parse("0x${hexString.substring(2, 4)}");
    int blue = int.parse("0x${hexString.substring(4, 6)}");
    return Color.fromARGB(255, red, green, blue);
  }

  static ThemeData createThemeData() {
    return ThemeData(
//        accentColor: COLOR_DARK_BLUE,
//            backgroundColor: Colors.deepOrange,
//            bottomAppBarColor: Colors.red,
//        buttonColor: COLOR_DARK_BLUE,
//        canvasColor: COLOR_DARK_BLUE,
//        cardColor: COLOR_DARK_BLUE,
//            cursorColor: Colors.yellow,
//        dialogBackgroundColor: Colors.grey,
//        disabledColor: Colors.grey,
//        dividerColor: Colors.transparent,
//            highlightColor: Colors.indigo,
//            indicatorColor: Colors.greenAccent,
//        primaryColor: COLOR_WHITE,
//        primaryColorLight: COLOR_WHITE,
//        primaryColorDark: COLOR_WHITE,
      primarySwatch: MaterialColor(0xFF08387C, {
        50: Color.fromRGBO(8, 56, 125, .1),
        100: Color.fromRGBO(8, 56, 125, .2),
        200: Color.fromRGBO(8, 56, 125, .3),
        300: Color.fromRGBO(8, 56, 125, .4),
        400: Color.fromRGBO(8, 56, 125, .5),
        500: Color.fromRGBO(8, 56, 125, .6),
        600: Color.fromRGBO(8, 56, 125, .7),
        700: Color.fromRGBO(8, 56, 125, .8),
        800: Color.fromRGBO(8, 56, 125, .9),
        900: Color.fromRGBO(8, 56, 125, 1)
      }),
//        scaffoldBackgroundColor: COLOR_WHITE,
//        secondaryHeaderColor: COLOR_DARK_BLUE,
//          selectedRowColor: Colors.limeAccent,
//        splashColor: COLOR_DARK_BLUE,
//        textSelectionColor: COLOR_DARK_BLUE,
//            textSelectionHandleColor: Colors.lightGreenAccent,
//            toggleableActiveColor: Colors.purple,
//            unselectedWidgetColor: Colors.lightGreen,
//        primaryTextTheme: TextTheme(title: TextStyle(color: COLOR_DARK_BLUE))
    );
  }
}

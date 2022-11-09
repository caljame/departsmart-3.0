import 'package:flutter/material.dart';

const EMPTY_SPACER = const SizedBox(width: 0, height: 0);

const VERTICAL_SPACER_5 = const SizedBox(height: 5);
const VERTICAL_SPACER_10 = const SizedBox(height: 10);
const VERTICAL_SPACER_20 = const SizedBox(height: 20);
const VERTICAL_SPACER_40 = const SizedBox(height: 40);
const HORIZONTAL_SPACER_5 = const SizedBox(width: 5);
const HORIZONTAL_SPACER_10 = const SizedBox(width: 10);
const HORIZONTAL_SPACER_15 = const SizedBox(width: 15);
const HORIZONTAL_SPACER_20 = const SizedBox(width: 20);
const HORIZONTAL_SPACER_40 = const SizedBox(width: 40);

const COLOR_DARK_BLUE = const Color(0xFF08387C);
const COLOR_LIGHT_BLUE = const Color(0x9908387C);
const COLOR_WHITE = Colors.white;
const COLOR_GREY = Color.fromARGB(255, 85, 85, 85);
const COLOR_LIGHT_GREY = const Color(0xFFEEEEEE);
const COLOR_RED = Colors.red;
const COLOR_BLACK = Colors.black;
const COLOR_YELLOW = Colors.yellow;

const TEXT_STYLE_APP_HEADING = const TextStyle(
    color: COLOR_WHITE,
    fontFamily: 'Noto Light',
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.none);

const TEXT_STYLE_HEADING = const TextStyle(
    color: COLOR_GREY,
    fontFamily: 'Noto Light',
    fontSize: 20.0,
    fontWeight: FontWeight.w800,
    decoration: TextDecoration.none);

const TEXT_STYLE_HEADING_WHITE = const TextStyle(
    color: COLOR_WHITE,
    fontFamily: 'Noto Light',
    fontSize: 20.0,
    fontWeight: FontWeight.w800,
    decoration: TextDecoration.none);

const TEXT_STYLE_SUBHEADING = const TextStyle(
    color: COLOR_GREY,
    fontFamily: 'Noto Light',
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.none);

const TEXT_STYLE_SUBHEADING_WHITE = const TextStyle(
    color: COLOR_WHITE,
    fontFamily: 'Noto Light',
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.none);

const TEXT_STYLE_SUBHEADING_RED = const TextStyle(
    color: COLOR_RED,
    fontFamily: 'Noto Light',
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.none);

const TEXT_STYLE_INPUT = const TextStyle(
    color: COLOR_GREY,
    fontFamily: 'Noto Light',
    fontSize: 15.0,
    fontWeight: FontWeight.w800,
    decoration: TextDecoration.none);

const TEXT_STYLE_REGULAR = const TextStyle(
    color: COLOR_GREY,
    fontFamily: 'Noto Light',
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.none);

const TEXT_STYLE_REGULAR_WHITE = const TextStyle(
    color: COLOR_WHITE,
    fontFamily: 'Noto Light',
    fontSize: 14.0,
    decoration: TextDecoration.none);

const TEXT_STYLE_SMALL = const TextStyle(
    color: COLOR_GREY,
    fontFamily: 'Noto Light',
    fontSize: 12.0,
    decoration: TextDecoration.none);

const TEXT_STYLE_ERROR = const TextStyle(
    color: COLOR_RED,
    fontFamily: 'Noto Light',
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.none);

const TEXT_STYLE_HINT = const TextStyle(
    color: COLOR_BLACK,
    fontFamily: 'Noto Light',
    fontSize: 14.0,
    fontStyle: FontStyle.italic,
    decoration: TextDecoration.none);

const TEXT_STYLE_TOOLBAR = const TextStyle(
    color: COLOR_BLACK,
    fontFamily: 'Noto Light',
    fontSize: 12.0,
    decoration: TextDecoration.none);

const TEXT_STYLE_LINK_BIG = const TextStyle(
    color: COLOR_DARK_BLUE,
    fontFamily: 'Noto Light',
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.none);

const TEXT_STYLE_LINK_BIG_WHITE = const TextStyle(
    color: COLOR_WHITE,
    fontFamily: 'Noto Light',
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.none);

const TEXT_STYLE_LINK = const TextStyle(
    color: COLOR_DARK_BLUE,
    fontFamily: 'Noto Light',
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.none);

const TEXT_STYLE_LINK_WHITE = const TextStyle(
    color: COLOR_WHITE,
    fontFamily: 'Noto Light',
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.none);

const TEXT_DRAWER_HEADING = const TextStyle(
    color: COLOR_GREY,
    fontFamily: 'Noto Light',
    fontSize: 17,
    fontWeight: FontWeight.w900,
    decoration: TextDecoration.none);

const TEXT_DRAWER_SUBHEADING = const TextStyle(
    color: COLOR_GREY,
    fontFamily: 'Noto Light',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.none);

const TEXT_DRAWER_ITEM_BIGGER = const TextStyle(
    color: COLOR_GREY,
    fontFamily: 'Noto Light',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.none);

const TEXT_DRAWER_ITEM_SMALLER = const TextStyle(
    color: COLOR_GREY,
    fontFamily: 'Noto Light',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.none);

const TEXT_DRAWER_CATEGORY = const TextStyle(
    color: COLOR_WHITE,
    fontFamily: 'Noto Light',
    fontSize: 20.0,
    fontWeight: FontWeight.w800,
    decoration: TextDecoration.none);

const TEXT_DRAWER_CATEGORY_HEADING = const TextStyle(
    color: COLOR_WHITE,
    fontFamily: 'Noto Light',
    fontSize: 18.0,
    fontWeight: FontWeight.w800,
    decoration: TextDecoration.none);

const TEXT_DRAWER_CATEGORY_SUBHEADING = const TextStyle(
    color: COLOR_WHITE,
    fontFamily: 'Noto Light',
    fontSize: 14.0,
    fontWeight: FontWeight.w800,
    decoration: TextDecoration.none);

const TEXT_DRAWER_CATEGORY_SUBHEADING_ITEM = const TextStyle(
    color: COLOR_YELLOW,
    fontFamily: 'Noto Light',
    fontSize: 14.0,
    fontWeight: FontWeight.w800,
    decoration: TextDecoration.none);

const TEXT_STYLE_HTML_DEFAULT = const TextStyle(
    color: COLOR_BLACK,
    fontFamily: 'Noto Light',
    fontSize: 16.0,
    fontWeight: FontWeight.w300,
    decoration: TextDecoration.none);

const List<String> COLOR_LIST = [
  "0000FF",
  "87CEFA",
  "32CD32",
  "FF00FF",
  "7B68EE",
  "FF6347",
  "800080",
  "9370DB",
  "DC143C",
  "2F4F4F",
  "BA55D3",
  "87CEEB",
  "E9967A",
  "FF7F50",
  "FF1493",
  "FFA07A",
  "FFEBCD",
  "00FA9A",
];

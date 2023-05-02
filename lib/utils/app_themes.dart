import 'package:flutter/material.dart';

import 'constants.dart';

enum AppTheme {
  LightTheme,
  DarkTheme,
}

final appThemeData = {
  AppTheme.LightTheme: ThemeData(
    brightness: Brightness.light,
    platform: TargetPlatform.iOS,
    scaffoldBackgroundColor: Colors.white,
    toggleableActiveColor: kColorPrimary,
    appBarTheme: AppBarTheme(
      elevation: 1,
      color: Colors.white,
      brightness: Brightness.light,
      iconTheme: IconThemeData(
        color: kColorPrimary,
      ),
      actionsIconTheme: IconThemeData(
        color: kColorPrimary,
      ),
      textTheme: TextTheme(
        headline6: TextStyle(
          color: kColorDark,
          fontFamily: 'Manrope',
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    dividerColor: Colors.grey[300],
    textTheme: TextTheme(
      button: kTextStyleButton,
      subtitle1: kTextStyleSubtitle1.copyWith(color: kColorPrimaryDark),
      subtitle2: kTextStyleSubtitle2.copyWith(color: kColorPrimaryDark),
      bodyText2: kTextStyleBody2.copyWith(color: kColorPrimaryDark),
      headline6: kTextStyleHeadline6.copyWith(color: kColorPrimaryDark),
      headline1: kTextStyleHeadline1.copyWith(color: kColorPrimaryDark),
    ),
    iconTheme: IconThemeData(
      color: kColorPrimary,
    ),
    fontFamily: 'Manrope',
    cardTheme: CardTheme(
      elevation: 0,
      color: Color(0xffEBF2F5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        //side: BorderSide(width: 1, color: Colors.grey[200]),
      ),
    ),
    bottomAppBarColor: Color(0xffE02C52),
    buttonColor: Color(0xffE02C52),
    focusColor: Color(0xffE02C52),
    cursorColor: Color(0xffE02C52),
    hoverColor: Color(0xffE02C52).withOpacity(0.75),
    splashColor: kColorBlue,
//    unselectedWidgetColor: Colors.white,
    textSelectionHandleColor: Colors.white,
  ),
  AppTheme.DarkTheme: ThemeData(
    brightness: Brightness.dark,
    platform: TargetPlatform.iOS,
    toggleableActiveColor: kColorPrimary,
    accentColor: kColorPrimary,
    appBarTheme: AppBarTheme(
      elevation: 1,
      brightness: Brightness.dark,
      iconTheme: IconThemeData(
        color: kColorPrimary,
      ),
      actionsIconTheme: IconThemeData(
        color: kColorPrimary,
      ),
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.white,
          fontFamily: 'Manrope',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    dividerColor: Colors.white54,
    textTheme: TextTheme(
      button: kTextStyleButton,
      subtitle1:
          kTextStyleSubtitle1.copyWith(color: Colors.white.withOpacity(0.87)),
      subtitle2:
          kTextStyleSubtitle2.copyWith(color: Colors.white.withOpacity(0.87)),
      bodyText2:
          kTextStyleBody2.copyWith(color: Colors.white.withOpacity(0.87)),
      headline6:
          kTextStyleHeadline6.copyWith(color: Colors.white.withOpacity(0.87)),
    ),
    iconTheme: IconThemeData(
      color: kColorPrimary,
    ),
    fontFamily: 'Manrope',
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(width: 0, color: Colors.transparent),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.87),
        ),
      ),
    ),
    bottomAppBarColor: Colors.transparent,
    buttonColor: Colors.lightBlue,
    focusColor: Colors.white,
    cursorColor: Colors.white,
    splashColor: kColorBlue,
//    unselectedWidgetColor: Colors.transparent,
    textSelectionHandleColor: Colors.black54,
  ),
};

import 'package:flutter/material.dart';
//import './global_settings.dart';

class DeviceHelper
{
  static double fontSize;
  static bool onTablet;
  static bool onPhone;
  static int sideContainerFlex;
  static double gapHeight;
  static double longGapHeight;

  static Color appBarColour;
  static Color appBarColourLight;
  static Color buttonColour;
  static Color iconColour;
  static Color backgroundColour;

  static void initialiseValues(BuildContext context)
  {

//    if (GlobalSettings.versionOfApp == AppVersion.QAD_fa)
//    {
//      appBarColour = Color.fromARGB(255, 0, 139, 82);
//      appBarColourLight = appBarColour.withOpacity(0.15);
//      buttonColour =appBarColour;
//      iconColour = Colors.green;
//      backgroundColour = Colors.grey;
//    }
//    else { 
//      appBarColour = Colors.blue;
//      appBarColourLight = Colors.blueAccent.withOpacity(0.15);
//      buttonColour = Theme.of(context).accentColor;
//      backgroundColour = Colors.grey;
//    }

    if (MediaQuery.of(context).size.width > 600)
    {
      // tablet
      fontSize = 20;
      onTablet = true;
      onPhone = false;
      sideContainerFlex = 1;
      gapHeight = 25;
      longGapHeight = 70;
    }
    else {
      // phone
      fontSize = 14;
      onTablet = false;
      onPhone = true;
      sideContainerFlex = 0;
      gapHeight = 12;
      longGapHeight = 40;
    }
  }
}

class AppTheme {
  AppTheme._();

  static Color _iconColor = Colors.blueAccent.shade200;

  static const Color _lightPrimaryColor = Colors.white;
  static const Color _lightPrimaryVariantColor = Color(0XFFE1E1E1);
  static const Color _lightSecondaryColor = Colors.green;
  static const Color _lightOnPrimaryColor = Colors.black;

  static const Color _darkPrimaryColor = Colors.white24;
  static const Color _darkPrimaryVariantColor = Colors.black;
  static const Color _darkSecondaryColor = Colors.white;
  static const Color _darkOnPrimaryColor = Colors.white;

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: _lightPrimaryVariantColor,
    appBarTheme: AppBarTheme(
      color: _lightPrimaryVariantColor,
      iconTheme: IconThemeData(color: _lightOnPrimaryColor),
    ),
    colorScheme: ColorScheme.light(
      primary: _lightPrimaryColor,
      primaryVariant: _lightPrimaryVariantColor,
      secondary: _lightSecondaryColor,
      onPrimary: _lightOnPrimaryColor,
    ),
    iconTheme: IconThemeData(
      color: _iconColor,
    ),
    textTheme: _lightTextTheme,
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: _darkPrimaryVariantColor,
    appBarTheme: AppBarTheme(
      color: _darkPrimaryVariantColor,
      iconTheme: IconThemeData(color: _darkOnPrimaryColor),
    ),
    colorScheme: ColorScheme.light(
      primary: _darkPrimaryColor,
      primaryVariant: _darkPrimaryVariantColor,
      secondary: _darkSecondaryColor,
      onPrimary: _darkOnPrimaryColor,
    ),
    iconTheme: IconThemeData(
      color: _iconColor,
    ),
    textTheme: _darkTextTheme,
  );

  static final TextTheme _lightTextTheme = TextTheme(
    headline: _lightScreenHeadingTextStyle,
    body1: _lightScreenTaskNameTextStyle,
    body2: _lightScreenTaskDurationTextStyle,
  );

  static final TextTheme _darkTextTheme = TextTheme(
    headline: _darkScreenHeadingTextStyle,
    body1: _darkScreenTaskNameTextStyle,
    body2: _darkScreenTaskDurationTextStyle,
  );

  static final TextStyle _lightScreenHeadingTextStyle = TextStyle(fontSize: 48.0, color: _lightOnPrimaryColor);
  static final TextStyle _lightScreenTaskNameTextStyle = TextStyle(fontSize: 20.0, color: _lightOnPrimaryColor);
  static final TextStyle _lightScreenTaskDurationTextStyle = TextStyle(fontSize: 16.0, color: Colors.grey);

  static final TextStyle _darkScreenHeadingTextStyle = _lightScreenHeadingTextStyle.copyWith(color: _darkOnPrimaryColor);
  static final TextStyle _darkScreenTaskNameTextStyle = _lightScreenTaskNameTextStyle.copyWith(color: _darkOnPrimaryColor);
  static final TextStyle _darkScreenTaskDurationTextStyle = _lightScreenTaskDurationTextStyle;
}

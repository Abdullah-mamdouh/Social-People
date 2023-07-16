import 'package:flutter/material.dart';
class ConstantColors {
  final Color lightColor = Color(0xff6c788a);
  final Color darkColor = Color(0xFF100E20);
  final Color blueColor = Colors.lightBlueAccent.shade400;
  final Color lightBlueColor = Colors.lightBlueAccent.shade200;
  final Color redColor = Colors.red;
  final Color whiteColor = Colors.white;
  final Color blueGreyColor = Colors.blueGrey.shade900;
  final Color greenColor = Colors.greenAccent;
  final Color yellowColor = Colors.yellow;
  final Color transperant = Colors.transparent;
  final Color greyColor = Colors.grey.shade600;

  ////////////////////////
  static Color themeColor = Color(0xfff5a623);
   Map<int, Color> swatchColor = {
    50: themeColor.withOpacity(0.1),
    100: themeColor.withOpacity(0.2),
    200: themeColor.withOpacity(0.3),
    300: themeColor.withOpacity(0.4),
    400: themeColor.withOpacity(0.5),
    500: themeColor.withOpacity(0.6),
    600: themeColor.withOpacity(0.7),
    700: themeColor.withOpacity(0.8),
    800: themeColor.withOpacity(0.9),
    900: themeColor.withOpacity(1),
  };
  final Color primaryColor = Color(0xff203152);
  //static const greyColor = Color(0xffaeaeae);
  final Color greyColor2 = Color(0xffE8E8E8);
}

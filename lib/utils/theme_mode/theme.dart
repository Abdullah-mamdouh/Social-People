

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sm/constant/Constantcolors.dart';
/*
class ThemeColor with ChangeNotifier {
  ConstantColors constantColors = new ConstantColors();
  Color ? themeColor;
  bool valueTheme = false;
  Color get getColorTheme => themeColor!;
  bool get getValueTheme => valueTheme;

  changeValueTheme(bool val){
    valueTheme = val;
    notifyListeners();
  }
  changeColorTheme(bool val){
    //themeColor = constantColors.darkColor;
    if(val == true){
      themeColor = constantColors.darkColor;
      debugPrint('kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk'+themeColor.toString());
    }
      themeColor = constantColors.whiteColor;
    notifyListeners();
  }
}
*/

class ThemeColor extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  bool isDark = true;
  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance!.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }


  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    isDark = isOn ? true: false;
    notifyListeners();
  }
}
ConstantColors constantColors = ConstantColors();
class MyThemes {

  static final darkTheme = ThemeData(
    // fontFamily: 'Montserrat',
    scaffoldBackgroundColor: constantColors.darkColor,
    backgroundColor: constantColors.darkColor,
    // primaryColor: Colors.black,
    colorScheme: ColorScheme.dark(),
    drawerTheme: DrawerThemeData(
      backgroundColor: constantColors.darkColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: constantColors.darkColor,
      elevation: 5,
      foregroundColor: constantColors.whiteColor,
      // iconTheme: IconThemeData(color: constantColors.lightBlueColor),
      //titleTextStyle: TextStyle(color: constantColors.blackLight2),

    ),
    cardColor: constantColors.lightColor,// Colors.red,//grey[800],
    accentColor: Colors.white,
    dividerColor: constantColors.whiteColor,
    bottomAppBarColor: constantColors.whiteColor,
    highlightColor: Colors.white,
    //buttonColor: constantColors.yellowColor,
    //buttonTheme: ButtonThemeData(buttonColor: constantColors.yellowColor),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle( minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity,52)),
          textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(color: constantColors.greyColor,)),
          backgroundColor: MaterialStateProperty.all<Color>(constantColors.greenColor),)),

    // iconTheme: IconThemeData(color: Colors.purple.shade200, opacity: 0.8),
  );

  static final lightTheme = ThemeData(
    //fontFamily: 'Montserrat',
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,//constantColors.appBarColor,
        iconTheme: IconThemeData(color: constantColors.darkColor),
        titleTextStyle: TextStyle(color: constantColors.darkColor,),
        textTheme: TextTheme(subtitle1: TextStyle(color: constantColors.darkColor,))
    ),
    accentTextTheme:TextTheme(subtitle1: TextStyle(color: constantColors.darkColor,),),
    backgroundColor: Colors.white,//constantColors.blackColor,
    drawerTheme: DrawerThemeData(
      backgroundColor: constantColors.whiteColor,

    ),
    //bannerTheme: MaterialBannerThemeData(backgroundColor: constantColors.greyColor),
    //appBarTheme:AppBarTheme(color: constantColors.greyColor,backgroundColor: constantColors.blackColor) ,
    //primaryColor: Colors.red,
    colorScheme: ColorScheme.light(),
    //cardColor: constantColors.lightBlueColor,
    cardColor: Colors.teal.shade400,
    dividerColor: constantColors.darkColor,
    accentColor: constantColors.darkColor,
    buttonColor: Colors.teal.shade300,
    buttonTheme: ButtonThemeData(buttonColor: Colors.teal.shade300,),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle( minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity,52)),
          textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(color: constantColors.lightColor,)),
          backgroundColor: MaterialStateProperty.all<Color>(constantColors.darkColor),)),
    highlightColor: Colors.deepOrange,
    //accentIconTheme: IconThemeData(color: constantColors.darkColor,),
    iconTheme: IconThemeData(color: Colors.red,),
    primaryIconTheme: IconThemeData(color: constantColors.darkColor,),
  );
}


import 'package:flutter/material.dart';
import 'package:sm/constant/Constantcolors.dart';

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
      print('kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk'+themeColor.toString());
    }
      themeColor = constantColors.whiteColor;
    notifyListeners();
  }
}

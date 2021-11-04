
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sm/constant/Constantcolors.dart';
import 'package:sm/screen/landing_page/landingPage.dart';
import 'package:sm/screen/theme_mode/theme.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ConstantColors constantColors = new ConstantColors();
  @override
  void initState() {
    Timer(Duration(seconds: 3,), ()=> Navigator.pushReplacement(context, PageTransition(child: LandingPage() , type: PageTransitionType.leftToRight)));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemeColor>(context, listen: false).valueTheme ? constantColors.whiteColor: constantColors.darkColor,
      //constantColors.darkColor,
      body: Center(
        child: RichText(
          text: TextSpan(
            text: 'The',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Social',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: constantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ]

          ),
        ),
      ),
    );
  }
}

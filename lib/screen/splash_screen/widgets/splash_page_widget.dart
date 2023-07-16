import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sm/constant/Constantcolors.dart';
import 'package:sm/screen/landing_page/landingPage.dart';
import 'package:sm/screen/notification_page/notification_services.dart';

import '../../../utils/theme_mode/theme.dart';

class SplashPageWidget extends StatefulWidget {
  const SplashPageWidget({Key? key}) : super(key: key);

  @override
  _SplashPageWidgetState createState() => _SplashPageWidgetState();
}

class _SplashPageWidgetState extends State<SplashPageWidget> {
  ConstantColors constantColors = new ConstantColors();

  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    notificationServices.requestNotificationPermission();
    notificationServices.firebaaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.getDeviceToken().then((value) {
      print('device Token');
      print(value);
    });
    Timer(
        Duration(
          seconds: 1,
        ),
        () => Navigator.pushReplacement(
            context,
            PageTransition(
                child: LandingPage(), type: PageTransitionType.leftToRight)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor:
          // Provider.of<ThemeColor>(context, listen: false).valueTheme
          //     ? constantColors.whiteColor
          //     : constantColors.darkColor,
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
              ]),
        ),
      ),
    );
  }
}

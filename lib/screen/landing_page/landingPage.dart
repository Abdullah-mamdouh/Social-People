
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sm/constant/Constantcolors.dart';

import 'landingHelper.dart';
class LandingPage extends StatelessWidget {
  LandingPage({Key? key}) : super(key: key);

  ConstantColors constantColors = new ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          bodyColor(),
          Provider.of<LandingHelper>(context,listen: false).bodyImage(context),
          Provider.of<LandingHelper>(context,listen: false).tagLineText(context),
          Provider.of<LandingHelper>(context,listen: false).mainButton(context),
          Provider.of<LandingHelper>(context,listen: false).privacyText(context),
        ],
      ),
    );
  }
  bodyColor(){
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter ,
          end: Alignment.bottomCenter,
          stops: [
            0.5, 0.9
          ],
          colors: [
            constantColors.darkColor,
            constantColors.blueColor
          ],
        ),
      ),
    );
  }
}

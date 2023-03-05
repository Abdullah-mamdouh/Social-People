import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:sm/constant/Constantcolors.dart';
import 'package:sm/screen/home_page/homePage.dart';
import 'package:sm/screen/landing_page/landingService.dart';
import 'package:sm/screen/landing_page/landingUtils.dart';
import 'package:sm/service/authentication.dart';
import 'package:sm/widget/buttonClass.dart';

class LandingHelper with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  Widget bodyImage(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.65,
      width: size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('asstes/images/login.png'),
        ),
      ),
    );
  }

  Widget tagLineText(BuildContext context) {
    return Positioned(
      top: 400,
      left: 10,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 180,
        ),
        child: RichText(
          text: TextSpan(
              text: 'You ',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Are ',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                TextSpan(
                  text: 'Social ',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                TextSpan(
                  text: '?',
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

  Widget mainButton(BuildContext context) {
    return Positioned(
      top: 520,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              child: ButtonClass(
                color: constantColors.yellowColor,
                icon: EvaIcons.emailOutline,
              ),
              onTap: () => emailAuthSheet(context),
            ),
            GestureDetector(
              child: ButtonClass(
                color: constantColors.redColor,
                icon: EvaIcons.google,
              ),
              onTap: () => Provider.of<Authentication>(context, listen: false)
                  .signInWithGoogle()
                  .whenComplete(() => Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: HomePage(),
                          type: PageTransitionType.leftToRight))),
            ),
            GestureDetector(
                child: ButtonClass(
              color: constantColors.blueColor,
              icon: EvaIcons.facebook,
            )),
          ],
        ),
      ),
    );
  }

  Widget privacyText(BuildContext context) {
    return Positioned(
      top: 610,
      left: 20,
      right: 20,
      child: Container(
        child: Column(
          children: [
            Text(
              "By Continuing You Agree The Social's Terms Of",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12.5),
            ),
            Text(
              "Services & Policy",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12.5),
            ),
          ],
        ),
      ),
    );
  }

  emailAuthSheet(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: size.height * 0.5,
            width: size.width,

            /// The DRY (don't repeat yourself)
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                Container(
                  child: Provider.of<LandingService>(context, listen: false)
                      .getLastUsersSigIn(context), //passwordLessSigIn(context),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                        color: constantColors.blueColor,
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Provider.of<LandingService>(context, listen: false)
                              .logInSheet(context);
                        }),
                    MaterialButton(
                        color: constantColors.redColor,
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Provider.of<LandingUtils>(context, listen: false)
                              .selectAvatarOperation(context);
                        }),
                  ],
                ),
              ],
            ),
          );
        });
  }
}

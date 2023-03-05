import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sm/constant/Constantcolors.dart';
import 'package:sm/screen/chat_room/single_chat/SingleChatroom.dart';
import 'package:sm/screen/feed/feedHelper.dart';
import 'package:sm/screen/home_page/homePage.dart';
import 'package:sm/screen/landing_page/landingPage.dart';
import 'package:sm/screen/profile/profile.dart';
import 'package:sm/service/firebaseOperation.dart';
import 'package:sm/widget/switch_buton.dart';

import '../../utils/theme_mode/theme.dart';

class Feed extends StatelessWidget {
  Feed({Key? key}) : super(key: key);
  ConstantColors constantColors = new ConstantColors();
  @override
  Widget build(BuildContext context) {
    // print(Provider.of<ThemeColor>(context, listen: false).themeColor);
    return Scaffold(
        // backgroundColor:
        //     Provider.of<ThemeColor>(context, listen: false).valueTheme
        //         ? constantColors.whiteColor
        //         : constantColors.darkColor,
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: constantColors.darkColor),
                arrowColor: constantColors.redColor,
                accountName: Text(
                    '${Provider.of<FirebaseOperation>(context, listen: false).getUserName}'),
                accountEmail: Text(
                    '${Provider.of<FirebaseOperation>(context, listen: false).getUserEmail}'),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                      Provider.of<FirebaseOperation>(context, listen: false)
                          .getUserImage),
                ),
              ),
              ListTile(
                leading: SwitchButton(),
                // onTap: () => Provider.of<ThemeColor>(context, listen: false).changeColorTheme(val),
              ),
              Divider(
                color: constantColors.darkColor,
                height: 1,
              ),
              ListTile(
                leading: Icon(EvaIcons.home, color: constantColors.blueColor),
                title: Text('Home'),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: HomePage(),
                          type: PageTransitionType.leftToRight));
                },
              ),
              Divider(
                color: constantColors.whiteColor,
                height: 1,
              ),
              ListTile(
                leading: Icon(
                  Icons.message_rounded,
                  color: constantColors.blueColor,
                ),
                title: Text(
                  'Chat',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: SingleChatroom(),
                          type: PageTransitionType.leftToRight));
                },
              ),
              Divider(
                color: constantColors.darkColor,
                height: 1,
              ),
              ListTile(
                title: Text(
                  'Profile',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: constantColors.blueColor,
                    backgroundImage: NetworkImage(
                        Provider.of<FirebaseOperation>(context, listen: false)
                            .getUserImage)),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: Profile(),
                          type: PageTransitionType.leftToRight));
                },
              ),
            ],
          ),
        ),
        appBar: Provider.of<FeedHelper>(context, listen: false).appBar(context),
        body: Provider.of<FeedHelper>(context, listen: false).feedBody(context),
      );
  }
}

import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sm/constant/Constantcolors.dart';
import 'package:sm/screen/chat_room/group_chat/chatRoom.dart';
import 'package:sm/screen/chat_room/single_chat/SingleChatroom.dart';
import 'package:sm/screen/feed/feed.dart';
import 'package:sm/screen/notification_page/notification_page.dart';
import 'package:sm/screen/profile/profile.dart';
import 'package:sm/service/firebaseOperation.dart';

import '../../utils/theme_mode/theme.dart';
import 'homePageHelper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ConstantColors constantColors = new ConstantColors();
  final PageController pageController = PageController();
  int pageIndex = 0;

  @override
  void initState() {
    Provider.of<FirebaseOperation>(context, listen: false)
        .initUserDate(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(Provider.of<FirebaseOperation>(context).getUserImage +
    //     "asssssssssssssssaa");
    return Scaffold(
        // backgroundColor:
        //     Provider.of<ThemeColor>(context, listen: false).valueTheme
        //         ? constantColors.whiteColor
        //         : constantColors.darkColor,
        //constantColors.darkColor,
        //appBar: AppBar(),
        body: PageView(
          controller: pageController,
          children: [
            Feed(),
            //ChatRoom(),
            SingleChatroom(),
            NotificationPage(),
            Profile(),
          ],
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (page) {
            setState(() {
              pageIndex = page;
            });
          },
        ),
        bottomNavigationBar: Provider.of<HomePageHelper>(context, listen: false)
            .bottomNavBar(context, pageIndex, pageController));
  }
}

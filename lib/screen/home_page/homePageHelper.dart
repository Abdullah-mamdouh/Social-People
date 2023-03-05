import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sm/constant/Constantcolors.dart';
import 'package:sm/service/firebaseOperation.dart';

class HomePageHelper with ChangeNotifier {
  ConstantColors constantColors = new ConstantColors();

  Widget bottomNavBar(BuildContext context,int index, PageController pageController) {
    return CustomNavigationBar(
      currentIndex: index,
      bubbleCurve: Curves.bounceIn,
      scaleCurve: Curves.decelerate,
      selectedColor: constantColors.blueColor,
      unSelectedColor: constantColors.whiteColor,
      strokeColor: constantColors.blueColor,
      scaleFactor: 0.5,
      iconSize: 30,
      onTap: (val) {
        index = val;
        pageController.jumpToPage(val);
        notifyListeners();
      },
      backgroundColor: Color(0xf040307),
      items: [
        CustomNavigationBarItem(icon: Icon(EvaIcons.home)),
        CustomNavigationBarItem(icon: Icon(Icons.message_rounded)),
        CustomNavigationBarItem(
            icon: CircleAvatar(
          radius: 35,
          backgroundColor: constantColors.blueGreyColor,
          backgroundImage: NetworkImage(
              Provider.of<FirebaseOperation>(context)
                  .getUserImage),
        )
        )
      ],
    );
  }
}


import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sm/constant/Constantcolors.dart';
import 'package:sm/screen/home_page/homePage.dart';
import 'package:sm/service/authentication.dart';
class ButtonClass extends StatelessWidget {
  Color ? color;
  IconData ? icon;
  ButtonClass({Key? key,@required this.color,@required this.icon,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80, height: 40,
      child: Icon(icon, color: color,),
      decoration: BoxDecoration(
        border: Border.all(
          color: color!,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

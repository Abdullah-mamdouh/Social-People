import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sm/constant/Constantcolors.dart';
import 'package:sm/screen/landing_page/landingPage.dart';
import 'package:sm/screen/profile/profileHelper.dart';
import 'package:sm/screen/theme_mode/theme.dart';
import 'package:sm/service/authentication.dart';

class Profile extends StatelessWidget {
  Profile({Key? key}) : super(key: key);
  ConstantColors constantColors = new ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemeColor>(context, listen: false).valueTheme ? constantColors.whiteColor: constantColors.darkColor,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(EvaIcons.settings2Outline),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ProfileHelper>(context, listen: false)
                  .LogOutDialog(context);
            },
            icon: Icon(
              EvaIcons.logInOutline,
              color: constantColors.lightBlueColor,
            ),
          ),
        ],
        backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
        title: RichText(
          text: TextSpan(
            text: 'My ',
            style: TextStyle(
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Profile ',
                style: TextStyle(
                  color: constantColors.blueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(Provider.of<Authentication>(context, listen: false)
                      .getUserUid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot != null) {
                  return new Column(
                    children: [
                      Provider.of<ProfileHelper>(context, listen: false)
                          .headProfile(context, snapshot),
                      Provider.of<ProfileHelper>(context, listen: false)
                          .divider(),
                      Provider.of<ProfileHelper>(context, listen: false)
                          .middleProfile(context, snapshot),
                      Provider.of<ProfileHelper>(context, listen: false)
                          .footerProfile(context, snapshot),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: constantColors.blueGreyColor.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }
}

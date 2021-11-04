import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sm/constant/Constantcolors.dart';
import 'package:sm/screen/alt_profile/altProfileHelper.dart';

class AltProfile extends StatelessWidget {
  AltProfile({Key? key, @required this.userUid}) : super(key: key);
  ConstantColors constantColors = new ConstantColors();
  String? userUid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          Provider.of<AltProfileHlper>(context, listen: false).appBar(context),
      body: SingleChildScrollView(
        child: Container(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userUid!)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                //return Container();
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                       Provider.of<AltProfileHlper>(context, listen: false)
                           .headerProfile(context, snapshot,userUid!),
                      Provider.of<AltProfileHlper>(context, listen: false)
                          .divider(),
                      Provider.of<AltProfileHlper>(context, listen: false)
                          .middleProfile(context),
                      Provider.of<AltProfileHlper>(context, listen: false)
                          .footerProfile(context, snapshot),
                    ],
                  ),
                );
              }
            },
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.blueGreyColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
        ),
      ),
    );
  }
}

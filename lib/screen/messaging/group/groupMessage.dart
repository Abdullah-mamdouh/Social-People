import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sm/constant/Constantcolors.dart';
import 'package:sm/screen/chat_room/group_chat/chatRoom.dart';
import 'package:sm/screen/home_page/homePage.dart';
import 'package:sm/service/authentication.dart';

import '../../../utils/theme_mode/theme.dart';
import 'groupMessageHelper.dart';

class GroupMessage extends StatefulWidget {
  GroupMessage({Key? key, @required this.documentSnapshot}) : super(key: key);
  final DocumentSnapshot? documentSnapshot;

  @override
  State<GroupMessage> createState() => _GroupMessageState();
}

class _GroupMessageState extends State<GroupMessage> {
  ConstantColors constantColors = new ConstantColors();
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    Provider.of<GroupMessageHelper>(context, listen: false)
        .checkIJoined(context, widget.documentSnapshot!.id,
            widget.documentSnapshot!['user_uid'])
        .whenComplete(() async {
      if (Provider.of<GroupMessageHelper>(context, listen: false)
              .gethasMemberJoined ==
          false) {
        Timer(
          Duration(milliseconds: 10),
          () => Provider.of<GroupMessageHelper>(context, listen: false)
              .askToJoin(context, widget.documentSnapshot!.id),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      appBar: AppBar(
        backgroundColor: constantColors.blueColor.withOpacity(0.6),
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<GroupMessageHelper>(context, listen: false)
                    .leaveTheRoom(context, widget.documentSnapshot!.id);
              },
              icon: Icon(
                EvaIcons.logInOutline,
                color: constantColors.redColor,
              )),
          Provider.of<Authentication>(context, listen: false).getUserUid ==
                  widget.documentSnapshot!['user_uid']
              ? IconButton(
                  onPressed: () {
                    Provider.of<GroupMessageHelper>(context, listen: false)
                        .leaveTheRoom(context, widget.documentSnapshot!.id);
                  },
                  icon: Icon(
                    EvaIcons.moreVertical,
                    color: constantColors.whiteColor,
                  ))
              : Container(
                  width: 0,
                  height: 0,
                ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: constantColors.whiteColor),
          onPressed: () {
           // Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: ChatRoom(), type: PageTransitionType.leftToRight));
          },
        ),
        title: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: constantColors.darkColor,
                backgroundImage:
                    NetworkImage(widget.documentSnapshot!['room_avatar']),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.documentSnapshot!['room_name'],
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('chatrooms')
                            .doc(widget.documentSnapshot!.id)
                            .collection('members')
                            .snapshots(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return Text(
                              '${snapshot.data.docs.length.toString()} members',
                              style: TextStyle(
                                  color: constantColors.greenColor
                                      .withOpacity(0.5),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10),
                            );
                          }
                        }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          //color: Provider.of<ThemeColor>(context, listen: false).valueTheme ? constantColors.whiteColor: constantColors.darkColor,
          child: Column(
            children: [
              AnimatedContainer(
                height: MediaQuery.of(context).size.height*0.8,
                width: MediaQuery.of(context).size.width,
                child: Provider.of<GroupMessageHelper>(context, listen: false)
                    .showMessage(context, widget.documentSnapshot!,
                        widget.documentSnapshot!['user_uid']),
                duration: Duration(seconds: 1),
                curve: Curves.bounceIn,
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom
                ),
                child: Container(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Provider.of<GroupMessageHelper>(context,
                                  listen: false)
                              .showSticker(
                                  context, widget.documentSnapshot!.id);
                        },
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage('asstes/icons/sunflower.png'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextField(
                            controller: messageController,
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Send Hi....',
                              hintStyle: TextStyle(
                                color: constantColors.greenColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          if (messageController.text.isNotEmpty) {
                            //messageController.text = 'Send Message';
                            Provider.of<GroupMessageHelper>(context,
                                    listen: false)
                                .sendMessage(context, widget.documentSnapshot!,
                                    messageController);
                          }
                        },
                        backgroundColor: constantColors.blueColor,
                        child: Icon(
                          Icons.send_sharp,
                          color: constantColors.whiteColor,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

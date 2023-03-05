import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sm/constant/Constantcolors.dart';
import 'package:sm/screen/chat_room/single_chat/SingleChatroom.dart';
import 'package:sm/screen/messaging/single/singleChatMessageHelper.dart';

import '../../../utils/theme_mode/theme.dart';

class SingleMessage extends StatefulWidget {
  SingleMessage(
      {Key? key, @required this.documentSnapshot, @required this.roomid})
      : super(key: key);
  var documentSnapshot;
  String? roomid;

  @override
  _SingleMessageState createState() => _SingleMessageState();
}

class _SingleMessageState extends State<SingleMessage> {
  ConstantColors constantColors = new ConstantColors();
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      appBar: AppBar(
        backgroundColor: constantColors.blueColor.withOpacity(0.6),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: constantColors.whiteColor),
          onPressed: () {
            // Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: SingleChatroom(),
                    type: PageTransitionType.leftToRight));
          },
        ),
        title: Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: constantColors.darkColor,
                  backgroundImage:
                      NetworkImage(widget.documentSnapshot!['user_image']),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.documentSnapshot!['user_name'],
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          // color: Provider.of<ThemeColor>(context, listen: false).valueTheme
          //     ? constantColors.whiteColor
          //     : constantColors.darkColor,
          child: Column(
            children: [
              AnimatedContainer(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  child: Provider.of<SingleChatMessageHelper>(context,
                          listen: false)
                      .showMessage(
                          context, widget.documentSnapshot!, widget.roomid!),
                ),
                duration: Duration(seconds: 1),
                curve: Curves.bounceIn,
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  child: Row(
                    children: [
                      // GestureDetector(
                      //   onTap: () {
                      //     Provider.of<SingleChatMessageHelper>(context,
                      //         listen: false)
                      //         .showSticker(
                      //         context, widget.documentSnapshot!.id);
                      //   },
                      CircleAvatar(
                        backgroundImage:
                            AssetImage('asstes/icons/sunflower.png'),
                      ),
                      // ),
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
                            Provider.of<SingleChatMessageHelper>(context,
                                    listen: false)
                                .sendMessage(context, widget.roomid!,
                                    messageController);
                            messageController.text = '';
                          }
                        },
                        backgroundColor: constantColors.blueColor,
                        child: Icon(
                          Icons.send_sharp,
                          color: constantColors.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

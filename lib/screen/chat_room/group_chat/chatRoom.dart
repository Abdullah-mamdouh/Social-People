import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sm/constant/Constantcolors.dart';
import 'package:sm/screen/chat_room/group_chat/chatRoomHelper.dart';
import 'package:sm/screen/search/groups_searching.dart';

class ChatRoom extends StatelessWidget {
  ChatRoom({Key? key}) : super(key: key);
  ConstantColors constantColors = new ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Material(
      color: constantColors.darkColor,
      //constantColors.darkColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: AppBar(
                    backgroundColor: constantColors.darkColor.withOpacity(0.6),
                    //centerTitle: true,
                    actions: [
                      GestureDetector(
                        onTap: (){
                          showSearch(context: context, delegate: GroupChatSearching());
                        },
                        child: CircleAvatar(
                          child: Icon(
                            Icons.search_rounded,
                            size: 23,color: constantColors.darkColor,
                          ),
                          backgroundColor: constantColors.blueColor,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            // Provider.of<UploadPost>(context, listen: false)
                            //     .selectPostImageType(context);
                          },
                          icon: Icon(
                            EvaIcons.moreVertical,
                            color: constantColors.whiteColor,
                          )),
                    ],
                    leading: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.plus,
                        color: constantColors.greenColor,
                      ),
                      onPressed: () {
                        Provider.of<ChatRoomHelper>(context, listen: false)
                            .showCreateChatRoomSheet(context);
                      },
                    ),
                    title: RichText(
                      text: TextSpan(
                        text: 'Chat ',
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Box ',
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
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Provider.of<ChatRoomHelper>(context, listen: false).showChatroom(context),
            ),
          ],
        ),
      ),
    );
    /*return Scaffold(
      backgroundColor: constantColors.darkColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: constantColors.blueGreyColor,
        child: Icon(
          FontAwesomeIcons.plus,
          color: constantColors.greenColor,
        ),
        onPressed: () {
          Provider.of<ChatRoomHelper>(context, listen: false)
              .showCreateChatRoomSheet(context);
        },
      ),

      appBar: AppBar(
        backgroundColor: constantColors.darkColor.withOpacity(0.6),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                // Provider.of<UploadPost>(context, listen: false)
                //     .selectPostImageType(context);
              },
              icon: Icon(
                EvaIcons.moreVertical,
                color: constantColors.whiteColor,
              )),
        ],
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.plus,
            color: constantColors.greenColor,
          ),
          onPressed: () {
            Provider.of<ChatRoomHelper>(context, listen: false)
                .showCreateChatRoomSheet(context);
          },
        ),
        title: RichText(
          text: TextSpan(
            text: 'Chat ',
            style: TextStyle(
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Box ',
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
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Provider.of<ChatRoomHelper>(context, listen: false).showChatroom(context),
      ),

    );
    */
  }
}

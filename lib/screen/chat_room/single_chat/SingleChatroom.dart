import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sm/constant/Constantcolors.dart';
import 'package:sm/screen/chat_room/group_chat/chatRoom.dart';
import 'package:sm/screen/chat_room/group_chat/chatRoomHelper.dart';
import 'package:sm/screen/chat_room/single_chat/singleChatsHelper.dart';
import 'package:sm/screen/search/single_chat_search.dart';
import 'package:sm/service/firebaseOperation.dart';

class SingleChatroom extends StatefulWidget {
  SingleChatroom({Key? key}) : super(key: key);

  @override
  State<SingleChatroom> createState() => _SingleChatroomState();
}

class _SingleChatroomState extends State<SingleChatroom> {
  ConstantColors constantColors = new ConstantColors();
  @override
  void initState() {
    Provider.of<SingleChatsHelper>(context, listen: false).showSingleChats(context);
    //Provider.of<SingleChatsHelper>(context, listen: false).s
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      color: constantColors.darkColor,
      child: Padding(
        padding: const EdgeInsets.only(top: 18.0),
        child: Expanded(
          child: Container(
            child: SingleChildScrollView(

              child: Expanded(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                backgroundColor: ConstantColors.greyColor,
                                backgroundImage: NetworkImage(
                                    Provider.of<FirebaseOperation>(context, listen: false)
                                        .getUserImage,
                                    scale: 2),
                                radius: 25,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.06,
                              ),
                              Text(
                                'Chats',
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  showSearch(context: context, delegate: SingleChatSearching());
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
                                  icon: Icon(
                                    EvaIcons.people,
                                    color: constantColors.whiteColor,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: ChatRoom(),
                                            type: PageTransitionType.bottomToTop));
                                  }),
                              IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.plus,
                                  color: constantColors.lightBlueColor,
                                ),
                                onPressed: () {
                                  Provider.of<ChatRoomHelper>(context, listen: false)
                                      .showCreateChatRoomSheet(context);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Divider(
                          thickness: 4,
                          color: constantColors.whiteColor,
                        ),
                      ),
                      //Spacer(),
                      Expanded(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,width: MediaQuery.of(context).size.width,
                          child: Provider.of<SingleChatsHelper>(context,listen: false).showSingleChats(context),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

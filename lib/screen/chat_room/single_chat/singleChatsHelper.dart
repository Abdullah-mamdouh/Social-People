import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sm/constant/Constantcolors.dart';
import 'package:sm/screen/alt_profile/chat_helper.dart';
import 'package:sm/screen/chat_room/single_chat/SingleChatroom.dart';
import 'package:sm/screen/messaging/single/singleChatMessages.dart';
import 'package:sm/service/authentication.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../constant/firestore_constants.dart';
import '../../../models/user_chat.dart';
import '../../alt_profile/chat_page.dart';

class SingleChatsHelper with ChangeNotifier {
  ConstantColors constantColors = new ConstantColors();

  String lastMessageTime = '';
  String get getlastMessageTime => lastMessageTime;

  showLastMessageTime(dynamic timeData) {
    Timestamp time = timeData;
    DateTime dateTime = time.toDate();
    lastMessageTime = timeago.format(dateTime);
    print(lastMessageTime);
    notifyListeners();
  }

  showSingleChats(BuildContext context) {
    return Material(
      color: constantColors.darkColor,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(FirestoreConstants.pathMessageCollection).snapshots(),
        //Provider.of<ChatHelper>(context, listen: false).getChatStream(5),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if ((snapshot.data?.docs.length ?? 0) > 0) {
              print(snapshot.data?.docs.length);
              return ListView.builder(
                padding: EdgeInsets.all(20),
                itemBuilder: (context, index) {
                  return buildItem(context, snapshot.data?.docs[index]);
                },
                itemCount: snapshot.data?.docs.length,
              );
            } else {
              return Center(
                child: Text("No users"),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(
                //color: ColorConstants.themeColor,
              ),
            );
          }
        },
      ),
      /*StreamBuilder<QuerySnapshot>(
        stream: Provider.of<ChatHelper>(context, listen: false).getChatStream(5),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if ((snapshot.data?.docs.length ?? 0) > 0) {
              print(snapshot.data?.docs.length);
              return ListView.builder(
                padding: EdgeInsets.all(20),
                itemBuilder: (context, index) {
                  return buildItem(context, snapshot.data?.docs[index]);
                },
                itemCount: snapshot.data?.docs.length,
              );
            } else {
              return Center(
                child: Text("No users"),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(
                  //color: ColorConstants.themeColor,
                  ),
            );
          }
        },
      ),*/
        /////////////////////////////////////////////////////////////////////////
      /*StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('singlechats').snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Lottie.asset('asstes/animations/loading.json'),
                ),
              );
            } else {
              return ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
    children: snapshot.data.docs
        .map<Widget>((DocumentSnapshot document) {
          var userId = document['id'];
          debugPrint(userId);
          Container(color: Colors.red,);
              }).toList(),
              );
             /* return Expanded(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: snapshot.data.docs
                        .map<Widget>((DocumentSnapshot document) {
                      // print('kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk');
                      var userid = FirebaseFirestore.instance
                          .collection('users')
                          .doc(Provider.of<Authentication>(context,
                                  listen: false)
                              .getUserUid)
                          .collection('singlechats')
                          .doc(document['room_name'])
                          .id;
                      // print(userid+'oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo');
                      //print( document['members'][0]['user_uid'].toString()+'oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo');
                      var friendData;
                      //print(friendData.toString()+'oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo');
                      //bool user_1 = false;
                      Provider.of<Authentication>(context, listen: false)
                                  .getUserUid ==
                              document['members'][0]['user_uid']
                          ? friendData = document['members'][1]
                          : Provider.of<Authentication>(context, listen: false)
                                      .getUserUid ==
                                  document['members'][1]['user_uid']
                              ? friendData = document['members'][0]
                              : null;
                      if (userid != null) {
                        print(friendData.toString() +
                            'oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo');
                        return friendData != null
                            ? Container(
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: SingleMessage(
                                              documentSnapshot: friendData,
                                              roomid: document['room_name'],
                                            ),
                                            type: PageTransitionType
                                                .leftToRight));
                                  },
                                  onLongPress: () {
                                    //showChatRoomDetails(context, document);
                                  },
                                  title: Text(
                                    friendData['user_name'],
                                    style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('singlechats')
                                        .doc(document['room_name'])
                                        .collection('messages')
                                        .orderBy('time', descending: true)
                                        .snapshots(),
                                    builder: (context, AsyncSnapshot snapshot) {
                                      print(
                                          '1222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222');
                                      //showLastMessageTime(snapshot.data.docs['time']);
                                      try {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else if (snapshot.hasError ||
                                            !snapshot.hasData ||
                                            snapshot.data.docs == null) {
                                          return Container(
                                            width: 0.0,
                                            height: 0.0,
                                          );
                                        } //return Container(child: Text('${snapshot.data.docs.first['user_name']}'),);

                                        else if (snapshot
                                                .data.docs.first['message'] !=
                                            null) {
                                          //showLastMessageTime(snapshot.data.docs['time']);
                                          return Text(
                                            '${snapshot.data.docs.first['user_name']} : ${snapshot.data.docs.first['message']} ',
                                            style: TextStyle(
                                                color:
                                                    constantColors.greenColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          );
                                        }
                                        // else if (snapshot.data.docs.first['message'] !=
                                        //         null &&
                                        //     snapshot.data.docs.first['sticker'] != null) {
                                        //   return Text(
                                        //     '${snapshot.data.docs.first['user_name']} : Sticker',
                                        //     style: TextStyle(
                                        //         color: constantColors.greenColor,
                                        //         fontSize: 14,
                                        //         fontWeight: FontWeight.bold),
                                        //   );
                                        // }

                                        else {
                                          return Container(
                                            width: 0,
                                            height: 0,
                                          );
                                        }
                                      } catch (e) {
                                        return Container(
                                          width: 0,
                                          height: 0,
                                        );
                                      }
                                    },
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: constantColors.blueColor,
                                    backgroundImage:
                                        NetworkImage(friendData['user_image']),
                                  ),
                                  trailing: Expanded(
                                      child: Text(
                                    '${getlastMessageTime.toString()}',
                                    style: TextStyle(
                                        color: constantColors.whiteColor),
                                  )),
/*

                          trailing: Container(child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('singlechats')
                                  .doc(document['room_name'])
                                  .collection('messages')
                                  .orderBy('time', descending: true)
                                  .snapshots(),
                              builder: (context, AsyncSnapshot snapshot) {
                               //showLastMessageTime(snapshot.data.docs.first['time']);
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }else {
                                  return Text('',
                                    //getlastMessageTime,
                                    style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  );
                                }
                              }),

                          ),



*/
                                ),
                              )
                            : Container(
                                width: 0.0,
                                height: 0.0,
                              );
                      } else {
                        return Container(
                          width: 0.0,
                          height: 0.0,
                        );
                      }
                    }).toList(),
                  ),
                ),
              );*/
            }
          }),*/
    );
  }
  Widget buildItem(BuildContext context, DocumentSnapshot? document) {
    if (document != null) {
      UserChat userChat = UserChat.fromDocument(document);
      // if (userChat.id == currentUserId) {
      //   return SizedBox.shrink();
      // } else {
        return Container(
          child: TextButton(
            child: Row(
              children: <Widget>[
                Material(
                  child: userChat.photoUrl.isNotEmpty
                      ? Image.network(
                    userChat.photoUrl,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 50,
                        height: 50,
                        child: Center(
                          child: CircularProgressIndicator(
                            //color: ColorConstants.themeColor,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, object, stackTrace) {
                      return Icon(
                        Icons.account_circle,
                        size: 50,
                        //color: ColorConstants.greyColor,
                      );
                    },
                  )
                      : Icon(
                    Icons.account_circle,
                    size: 50,
                    //color: ColorConstants.greyColor,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  clipBehavior: Clip.hardEdge,
                ),
                Flexible(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text(
                            'Nickname: ${userChat.nickname}',
                            maxLines: 1,
                            //style: TextStyle(color: ColorConstants.primaryColor),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 5),
                        ),
                        Container(
                          child: Text(
                            'About me: ${userChat.aboutMe}',
                            maxLines: 1,
                            //style: TextStyle(color: colorConstants.primaryColor),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        )
                      ],
                    ),
                    margin: EdgeInsets.only(left: 20),
                  ),
                ),
              ],
            ),
            onPressed: () {
              // if (Utilities.isKeyboardShowing()) {
              //   Utilities.closeKeyboard(context);
              // }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    arguments: ChatPageArguments(
                      chatId: document.id,
                      peerId: userChat.id,
                      peerAvatar: userChat.photoUrl,
                      peerNickname: userChat.nickname,
                    ),
                  ),
                ),
              );
            },
            style: ButtonStyle(
              //backgroundColor: MaterialStateProperty.all<Color>(ColorConstants.greyColor2),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
          margin: EdgeInsets.only(bottom: 10, left: 5, right: 5),
        );
      // }
    } else {
      return SizedBox.shrink();
    }
  }
}

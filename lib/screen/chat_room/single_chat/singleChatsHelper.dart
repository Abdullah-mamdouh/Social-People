import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sm/constant/Constantcolors.dart';
import 'package:sm/screen/chat_room/single_chat/SingleChatroom.dart';
import 'package:sm/screen/messaging/single/singleChatMessages.dart';
import 'package:sm/service/authentication.dart';
import 'package:timeago/timeago.dart' as timeago;
class SingleChatsHelper with ChangeNotifier{
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
              return Expanded(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,width: MediaQuery.of(context).size.width,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children:
                        snapshot.data.docs.map<Widget>((DocumentSnapshot document) {
                         // print('kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk');
                      var userid = FirebaseFirestore.instance
                          .collection('users')
                          .doc(Provider.of<Authentication>(context, listen: false)
                              .getUserUid)
                          .collection('singlechats')
                          .doc(document['room_name']).id;
                     // print(userid+'oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo');
                      //print( document['members'][0]['user_uid'].toString()+'oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo');
                      var friendData ;
                      //print(friendData.toString()+'oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo');
                      //bool user_1 = false;
                      Provider.of<Authentication>(context, listen: false)
                          .getUserUid ==
                          document['members'][0]['user_uid']
                          ?  friendData = document['members'][1]
                          : Provider.of<Authentication>(context, listen: false)
                          .getUserUid ==
                          document['members'][1]['user_uid'] ? friendData =  document['members'][0] : null ;
                      if (userid != null) {

                        print(friendData.toString()+'oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo');
                        return friendData != null ? Container(
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: SingleMessage(
                                        documentSnapshot: friendData,roomid: document['room_name'],
                                      ),
                                      type: PageTransitionType.leftToRight));
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
                                print('1222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222');
                                //showLastMessageTime(snapshot.data.docs['time']);
                                try{
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  else if(snapshot.hasError||!snapshot.hasData|| snapshot.data.docs == null){
                                    return Container(width: 0.0,height: 0.0,);
                                  }//return Container(child: Text('${snapshot.data.docs.first['user_name']}'),);

                                  else if (snapshot.data.docs.first['message'] !=
                                      null) {
                                    //showLastMessageTime(snapshot.data.docs['time']);
                                    return Text(
                                      '${snapshot.data.docs.first['user_name']} : ${snapshot.data.docs.first['message']} ',
                                      style: TextStyle(
                                          color: constantColors.greenColor,
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
                                }catch(e){
                                  return Container(
                                    width: 0,
                                    height: 0,
                                  );
                                }

                              },
                            ),

                            leading: CircleAvatar(
                              backgroundColor: constantColors.blueColor,
                              backgroundImage: NetworkImage(friendData['user_image'])  ,
                            ),
trailing: Expanded(child: Text('${getlastMessageTime.toString()}',style: TextStyle(color: constantColors.whiteColor),)),
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


                        ) : Container(width: 0.0,height: 0.0,);
                      } else {
                        return Container(
                          width: 0.0,
                          height: 0.0,
                        );
                      }
                    }).toList(),
                  ),
                ),
              );
            }
          }),
    );
  }
}

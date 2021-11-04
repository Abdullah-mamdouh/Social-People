import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sm/constant/Constantcolors.dart';
import 'package:sm/screen/alt_profile/altProfile.dart';
import 'package:sm/screen/home_page/homePage.dart';
import 'package:sm/screen/messaging/group/groupMessage.dart';
import 'package:sm/service/authentication.dart';
import 'package:sm/service/firebaseOperation.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatRoomHelper with ChangeNotifier {
  String? lastMessageTime;
  String get getlastMessageTime => lastMessageTime!;
  String chatroomAvatarUrl = ' ';
  String get getchatroomAvatarUrl => chatroomAvatarUrl;
  ConstantColors constantColors = new ConstantColors();
  TextEditingController chatroomController = TextEditingController();

  showChatRoomDetails(BuildContext context, DocumentSnapshot document) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12), topLeft: Radius.circular(12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                Container(alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width*0.25,
                  decoration: BoxDecoration(

                      color: constantColors.blueGreyColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: constantColors.blueColor)),
                  child: Text(
                    'Members',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chatrooms')
                          .doc(document.id)
                          .collection('members')
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data.docs
                                .map<Widget>((DocumentSnapshot document) {
                              return GestureDetector(
                                onTap: () {
                                  if (Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid ==
                                      document['user_uid']) {
                                    Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                            child: AltProfile(),
                                            type: PageTransitionType
                                                .bottomToTop));
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: CircleAvatar(
                                    backgroundColor: constantColors.darkColor,
                                    backgroundImage:
                                        NetworkImage(document['user_image']),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                      }),
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width,
                ),
                Container(
                  child: Text(
                    'Admin',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: constantColors.transperant,
                        backgroundImage: NetworkImage(document['user_image']),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          document['user_name'],
                          style: TextStyle(
                              color: constantColors.greenColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Provider.of<Authentication>(context, listen: false)
                                  .getUserUid ==
                              document['user_uid']
                          ? Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: MaterialButton(
                                  color: constantColors.redColor,
                                  child: Text(
                                    'Delete Room',
                                    style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context){
                                          return AlertDialog(
                                            backgroundColor: constantColors.darkColor,
                                            title: Text(
                                              'Delete ChatRoom',
                                              style: TextStyle(
                                                color: constantColors.whiteColor,
                                                fontSize: 16,
                                              ),
                                            ),
                                            actions: [
                                              MaterialButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'No',
                                                  style: TextStyle(
                                                      color:
                                                      constantColors.whiteColor,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      decoration:
                                                      TextDecoration.underline,
                                                      decorationColor:
                                                      constantColors.whiteColor),
                                                ),
                                              ),
                                              MaterialButton(
                                                onPressed: () {
                                                  FirebaseFirestore.instance
                                                      .collection('chatrooms')
                                                      .doc(document.id)
                                                      .delete()
                                                      .whenComplete(() {
                                                    Navigator.pushReplacement(
                                                        context,
                                                        PageTransition(
                                                            child: HomePage(),
                                                            type: PageTransitionType
                                                                .bottomToTop));
                                                  });
                                                },
                                                color: constantColors.redColor,
                                                child: Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                    color: constantColors.whiteColor,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            ],
                                          );
                                        }
                                    );
                                  }),
                            )
                          : Container(
                              width: 0,
                              height: 0,
                            ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  showCreateChatRoomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150),
                    child: Divider(
                      thickness: 4,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Text(
                    'select ChatRoom Avatar',
                    style: TextStyle(
                        color: constantColors.greenColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('chatroomIcons')
                            .snapshots(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          // else if(!snapshot.hasData){
                          //   chatroomAvatarUrl = 'https://firebasestorage.googleapis.com/v0/b/social-9064f.appspot.com/o/posts%2Fdata%2Fuser%2F0%2Fcom.example.social_media_app%2Fcache%2Fimage_picker7050214312474556961.png%2FTimeOfDay(20%3A17)?alt=media&token=365ab38f-415b-40b1-9d84-007b88e4cdef';
                          //   notifyListeners();
                          // }
                          else {
                            return Expanded(
                              child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: snapshot.data!.docs
                                    .map<Widget>((DocumentSnapshot document) {
                                  return GestureDetector(
                                    onTap: () {
                                       document['image'] !=
                                              null
                                          ? chatroomAvatarUrl = document['image']
                                          : chatroomAvatarUrl = 'https://firebasestorage.googleapis.com/v0/b/social-9064f.appspot.com/o/posts%2Fdata%2Fuser%2F0%2Fcom.example.social_media_app%2Fcache%2Fimage_picker7050214312474556961.png%2FTimeOfDay(20%3A17)?alt=media&token=365ab38f-415b-40b1-9d84-007b88e4cdef';
                                      notifyListeners();
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 16),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                          color: chatroomAvatarUrl ==
                                                  document['image']
                                              ? constantColors.blueColor
                                              : constantColors.blueGreyColor,
                                        )),
                                        height: 10,
                                        width: 40,
                                        child: Image.network(document['image']),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          }
                        }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextField(
                          textCapitalization: TextCapitalization.words,
                          controller: chatroomController,
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                            hintText: 'Enter chatroom ID',
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        backgroundColor: constantColors.blueGreyColor,
                        child: Icon(
                          FontAwesomeIcons.plus,
                          color: constantColors.yellowColor,
                        ),
                        onPressed: () async {
                          if (chatroomController.text != null) {
                            Provider.of<FirebaseOperation>(context,
                                    listen: false)
                                .submitChatroomData(
                              chatroomController.text,
                              {
                                'room_avatar': getchatroomAvatarUrl,
                                'time': Timestamp.now(),
                                'room_name': chatroomController.text,
                                'user_name': Provider.of<FirebaseOperation>(
                                        context,
                                        listen: false)
                                    .getUserName,
                                'user_image': Provider.of<FirebaseOperation>(
                                        context,
                                        listen: false)
                                    .getUserImage,
                                'user_email': Provider.of<FirebaseOperation>(
                                        context,
                                        listen: false)
                                    .getUserEmail,
                                'user_uid': Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid,
                              },
                            ).whenComplete(() {
                              Navigator.pop(context);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.darkColor.withOpacity(0.5),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
              ),
            ),
          );
        });
  }

  showChatroom(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chatrooms').snapshots(),
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
                    return ListTile(

                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: GroupMessage(
                                  documentSnapshot: document,
                                ),
                                type: PageTransitionType.leftToRight));
                      },
                      onLongPress: () {
                        showChatRoomDetails(context, document);
                      },

                      title: Text(
                        document['room_name'],
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('chatrooms')
                            .doc(document.id)
                            .collection('messages')
                            .orderBy('time', descending: true)
                            .snapshots(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.data.docs.first['message'] != null) {
                            return Text(
                              '${snapshot.data.docs.first['user_name']} : ${snapshot.data.docs.first['message']} ',
                              style: TextStyle(
                                  color: constantColors.greenColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            );
                          } else if (snapshot.data.docs.first['message'] != null &&
                              snapshot.data.docs.first['sticker'] != null) {
                            return Text(
                              '${snapshot.data.docs.first['user_name']} : Sticker',
                              style: TextStyle(
                                  color: constantColors.greenColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            );
                          } else {
                            return Container(
                              width: 0,
                              height: 0,
                            );
                          }
                        },
                      ),
                      leading: CircleAvatar(
                        backgroundColor: constantColors.blueColor,
                        //backgroundImage: NetworkImage(document['room_avatar'])  ,
                      ),
                        /*
                      trailing: Container(child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('chatrooms')
                              .doc(document.id)
                              .collection('messages')
                              .orderBy('time', descending: true)
                              .snapshots(),
                          builder: (context, AsyncSnapshot snapshot) {
                            showLastMessageTime(snapshot.data.docs.first['time']);
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }else {
                              return Text(
                                getlastMessageTime,
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              );
                            }
                          }),),
                      */
                    );
                  }).toList(),
                ),
              ),
            );
          }
        });
  }

  /////////////////

  showLastMessageTime(dynamic timeData) {
    Timestamp time = timeData;
    DateTime dateTime = time.toDate();
    lastMessageTime = timeago.format(dateTime);
    print(lastMessageTime);
    notifyListeners();
  }
}

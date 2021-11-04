import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sm/constant/Constantcolors.dart';
import 'package:sm/screen/home_page/homePage.dart';
import 'package:sm/service/authentication.dart';
import 'package:sm/service/firebaseOperation.dart';
import 'package:timeago/timeago.dart' as timeago;

class GroupMessageHelper with ChangeNotifier {
  bool hasMemberJoined = false;
  String? lastMessageTime;
  String get getlastMessageTime => lastMessageTime!;
  bool get gethasMemberJoined => hasMemberJoined;
  ConstantColors constantColors = new ConstantColors();

  leaveTheRoom(BuildContext context, String chatRoomName) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: constantColors.darkColor,
          title: Text(
            'Leave $chatRoomName ?',
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
                    color: constantColors.whiteColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: constantColors.whiteColor),
              ),
            ),
            MaterialButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('chatrooms')
                    .doc(chatRoomName)
                    .collection('members')
                    .doc(Provider.of<Authentication>(context, listen: false)
                        .getUserUid)
                    .delete()
                    .whenComplete(() {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: HomePage(),
                          type: PageTransitionType.bottomToTop));
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
      },
    );
  }

  showMessage(
      BuildContext context, DocumentSnapshot document, String adminUserUid) {
    try {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chatrooms')
            .doc(document.id)
            .collection('messages')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Container(
                child: Text(
              snapshot.toString(),
              style: TextStyle(color: constantColors.whiteColor),
            ));
          } else {
            return new ListView(
              reverse: true,
              children:
                  snapshot.data.docs.map<Widget>((DocumentSnapshot document) {
                showLastMessageTime(document['time']);

                return Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: document['message'] != null
                        ? MediaQuery.of(context).size.height * 0.125
                        : MediaQuery.of(context).size.height * 0.2,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 60.0, top: 20),
                          child: Row(
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                    maxHeight: document['message'] != null
                                        ? MediaQuery.of(context).size.height *
                                            0.1
                                        : MediaQuery.of(context).size.height *
                                            0.43,
                                    maxWidth: document['message'] != null
                                        ? MediaQuery.of(context).size.width *
                                            0.8
                                        : MediaQuery.of(context).size.height *
                                            0.9),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 18.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 150,
                                        child: Row(
                                          children: [
                                            Text(
                                              document['user_name'] != null
                                                  ? document['user_name']
                                                  : '',
                                              style: TextStyle(
                                                  color:
                                                      constantColors.greenColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                            Provider.of<Authentication>(context,
                                                            listen: false)
                                                        .getUserUid ==
                                                    adminUserUid
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Icon(
                                                      FontAwesomeIcons
                                                          .chessKing,
                                                      color: constantColors
                                                          .yellowColor,
                                                      size: 12,
                                                    ),
                                                  )
                                                : Container(
                                                    width: 0,
                                                    height: 0,
                                                  ),
                                          ],
                                        ),
                                      ),
                                      document['message'] != null
                                          ? Text(
                                              document['message'],
                                              style: TextStyle(
                                                  color:
                                                      constantColors.greenColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Container(
                                                height: 100,
                                                width: 100,
                                                child: Image.network(
                                                    document['sticker']),
                                              ),
                                            ),
                                      Expanded(
                                        child: Container(
                                         // width: 80,
                                          child: Text(
                                            getlastMessageTime,
                                            style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: Provider.of<Authentication>(context,
                                                  listen: false)
                                              .getUserUid ==
                                          document['user_uid']
                                      ? constantColors.blueGreyColor
                                          .withOpacity(0.8)
                                      : constantColors.blueGreyColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 20,
                          child: Provider.of<Authentication>(context,
                                          listen: false)
                                      .getUserUid ==
                                  document['user_uid']
                              ? Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.edit,
                                            color: constantColors.blueColor,
                                            size: 18,
                                          )),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            FontAwesomeIcons.trashAlt,
                                            color: constantColors.redColor,
                                            size: 16,
                                          )),
                                    ],
                                  ),
                                )
                              : Container(
                                  width: 0,
                                  height: 0,
                                ),
                        ),
                        Positioned(
                          child: Provider.of<Authentication>(context,
                                          listen: false)
                                      .getUserUid ==
                                  document['user_uid']
                              ? Container(
                                  width: 0,
                                  height: 0,
                                )
                              : CircleAvatar(
                                  backgroundColor: constantColors.blueGreyColor,
                                  backgroundImage:
                                      NetworkImage(document['user_image']),radius: 15,
                                ),
                          left: 40,
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }
        },
      );
    } catch (e) {
      print(e.toString());
      return Container();
    }
  }

  sendMessage(BuildContext context, DocumentSnapshot document,
      TextEditingController messageController) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(document.id)
        .collection('messages')
        .add({
      'message': messageController.text,
      'time': Timestamp.now(),
      'user_uid':
          Provider.of<Authentication>(context, listen: false).getUserUid,
      'user_name':
          Provider.of<FirebaseOperation>(context, listen: false).getUserName,
      'user_image':
          Provider.of<FirebaseOperation>(context, listen: false).getUserImage
    });
  }

  Future checkIJoined(
      BuildContext context, String chatRoomName, String chatAdminUid) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomName)
        .collection('members')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .get()
        .then((value) {
      hasMemberJoined = false;
      print('Inital state => $hasMemberJoined');
      if (value['joined'] != null) {
        hasMemberJoined = value['joined'];
        print('Final state => $hasMemberJoined');
        notifyListeners();
      }
      if (Provider.of<Authentication>(context, listen: false).getUserUid ==
          chatAdminUid) {
        hasMemberJoined = true;
        notifyListeners();
      }
    });
  }

  askToJoin(BuildContext context, String roomName) {
    return showDialog(
      context: context,
      builder: (context) {
        return new AlertDialog(
          backgroundColor: constantColors.darkColor,
          title: Text(
            'join $roomName',
            style: TextStyle(
                color: constantColors.whiteColor,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        child: HomePage(),
                        type: PageTransitionType.bottomToTop));
              },
              child: Text(
                'No',
                style: TextStyle(
                    color: constantColors.whiteColor,
                    decoration: TextDecoration.underline,
                    decorationColor: constantColors.whiteColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
            MaterialButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('chatrooms')
                    .doc(roomName)
                    .collection('members')
                    .doc(Provider.of<Authentication>(context, listen: false)
                        .getUserUid)
                    .set({
                  'joined': true,
                  'user_name':
                      Provider.of<FirebaseOperation>(context, listen: false)
                          .getUserName,
                  'user_image':
                      Provider.of<FirebaseOperation>(context, listen: false)
                          .getUserImage,
                  'user_uid':
                      Provider.of<Authentication>(context, listen: false)
                          .getUserUid,
                  'time': Timestamp.now(),
                }).whenComplete(() {
                  Navigator.pop(context);
                });
              },
              color: constantColors.blueColor,
              child: Text(
                'Yes',
                style: TextStyle(
                    color: constantColors.whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  showSticker(BuildContext context, String chatRoomId) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return AnimatedContainer(
          duration: Duration(seconds: 1),
          curve: Curves.easeIn,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 105),
                child: Divider(
                  thickness: 4,
                  color: constantColors.whiteColor,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: constantColors.blueColor),
                      ),
                      height: 30,
                      width: 30,
                      child: Image.asset('asstes/icons/sunflower.png'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('stickers')
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return new Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return new GridView(
                        children: snapshot.data.docs
                            .map<Widget>((DocumentSnapshot document) {
                          return GestureDetector(
                            onTap: () {
                              sendStickers(
                                  context, document['image'], chatRoomId);
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              child: Image.network(document['image']),
                            ),
                          );
                        }).toList(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                      );
                    }
                  },
                ),
              )
            ],
          ),
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.darkColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
        );
      },
    );
  }

  sendStickers(
      BuildContext context, String stickerImageUrl, String chatRoomId) async {
    await FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'sticker': stickerImageUrl,
      'user_name':
          Provider.of<FirebaseOperation>(context, listen: false).getUserName,
      'user_image':
          Provider.of<FirebaseOperation>(context, listen: false).getUserImage,
      'time': Timestamp.now(),
    });
  }

  showLastMessageTime(dynamic timeData) {
    Timestamp time = timeData;
    DateTime dateTime = time.toDate();
    lastMessageTime = timeago.format(dateTime);
    print(lastMessageTime);
    notifyListeners();
  }
}

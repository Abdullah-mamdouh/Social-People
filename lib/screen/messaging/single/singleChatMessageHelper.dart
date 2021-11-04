
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sm/constant/Constantcolors.dart';
import 'package:sm/service/authentication.dart';
import 'package:sm/service/firebaseOperation.dart';
import 'package:timeago/timeago.dart' as timeago;

class SingleChatMessageHelper with ChangeNotifier {
  ConstantColors constantColors = new ConstantColors();
  String? lastMessageTime;
  String get getlastMessageTime => lastMessageTime!;

  showLastMessageTime(dynamic timeData) {
    Timestamp time = timeData;
    DateTime dateTime = time.toDate();
    lastMessageTime = timeago.format(dateTime);
    print(lastMessageTime);
    notifyListeners();
  }

  showMessage(
      BuildContext context, var document, String roomUid) {
    try {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('singlechats')
            .doc(roomUid)
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
                                                .getUserUid !=
                                                document['user_uid']
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


                                      // document['message'] != null
                                      //     ?

                                      Text(
                                        document['message'],
                                        style: TextStyle(
                                            color:
                                            constantColors.greenColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),

                                      //     : Padding(
                                      //   padding: const EdgeInsets.only(
                                      //       top: 8.0),
                                      //   child: Container(
                                      //     height: 100,
                                      //     width: 100,
                                      //     child: Image.network(
                                      //         document['sticker']),
                                      //   ),
                                      // ),

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
                                      ),

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
      return CircularProgressIndicator();
    }
  }


  sendMessage(BuildContext context, String documentID,
      TextEditingController messageController) {
    return FirebaseFirestore.instance
        .collection('singlechats')
        .doc(documentID)
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
}
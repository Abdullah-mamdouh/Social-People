// ignore: file_names
// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sm/constant/Constantcolors.dart';
import 'package:sm/screen/alt_profile/chat_helper.dart';
import 'package:sm/screen/alt_profile/chat_page.dart';
import 'package:sm/screen/chat_room/group_chat/chatRoomHelper.dart';
import 'package:sm/screen/chat_room/single_chat/SingleChatroom.dart';
import 'package:sm/screen/home_page/homePage.dart';
import 'package:sm/service/authentication.dart';
import 'package:sm/service/firebaseOperation.dart';
import 'package:sm/utils/postOption.dart';
import 'package:uuid/uuid.dart';

import 'altProfile.dart';

class AltProfileHlper with ChangeNotifier {
  List chatID = [];
  ConstantColors constantColors = new ConstantColors();
  var uuid = Uuid();
  bool isCreated = true;
  appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: constantColors.whiteColor,
        ),
        onPressed: () {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: HomePage(), type: PageTransitionType.bottomToTop));
        },
      ),
      backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            EvaIcons.moreVertical,
            color: constantColors.whiteColor,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: HomePage(), type: PageTransitionType.bottomToTop));
          },
        ),
      ],
      title: RichText(
        text: TextSpan(
          text: 'The ',
          style: TextStyle(
            color: constantColors.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'Social ',
              style: TextStyle(
                color: constantColors.blueColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////

  Widget headerProfile(BuildContext context, dynamic snapshot, String userUid) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  height: 220,
                  width: 200,
                  child: Column(
                    children: [
                      GestureDetector(
                        child: CircleAvatar(
                          backgroundColor: constantColors.transperant,
                          radius: 60,
                          backgroundImage:
                              NetworkImage(snapshot.data!['user_image']),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          snapshot.data!['user_name'],
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              EvaIcons.email,
                              color: constantColors.greenColor,
                              size: 16,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                snapshot.data!['user_email'],
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              checkFollowerSheet(context, snapshot);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: constantColors.darkColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              height: 70,
                              width: 80,
                              child: Column(
                                children: [
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(snapshot.data!['user_uid'])
                                        .collection('followers')
                                        .snapshots(),
                                    builder: (context, AsyncSnapshot snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            snapshot.data.docs.length
                                                .toString(),
                                            style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 28),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  Text(
                                    'Follower',
                                    style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: constantColors.darkColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            height: 70,
                            width: 80,
                            child: Column(
                              children: [
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(snapshot.data!['user_uid'])
                                      .collection('following')
                                      .snapshots(),
                                  builder: (context, AsyncSnapshot snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          snapshot.data.docs.length.toString(),
                                          style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 28),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                Text(
                                  'Following',
                                  style: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: constantColors.darkColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        height: 70,
                        width: 80,
                        child: Column(
                          children: [
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(snapshot.data!['user_uid'])
                                  .collection('posts')
                                  .snapshots(),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      snapshot.data.docs.length.toString(),
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 28),
                                    ),
                                  );
                                }
                              },
                            ),
                            Text(
                              'Posts',
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                    color: constantColors.blueColor,
                    child: Text(
                      'Follow',
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    onPressed: () {
                      Provider.of<FirebaseOperation>(context, listen: false)
                          .followUser(
                              userUid,
                              Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid,
                              {
                                'user_name': Provider.of<FirebaseOperation>(
                                        context,
                                        listen: false)
                                    .getUserName,
                                'user_image': Provider.of<FirebaseOperation>(
                                        context,
                                        listen: false)
                                    .getUserImage,
                                'user_uid': Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid,
                                'user_email': Provider.of<FirebaseOperation>(
                                        context,
                                        listen: false)
                                    .getUserEmail,
                                'time': Timestamp.now(),
                              },
                              Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid,
                              userUid,
                              {
                                'user_name': snapshot.data!['user_name'],
                                'user_image': snapshot.data!['user_image'],
                                'user_email': snapshot.data!['user_email'],
                                'user_uid': snapshot.data!['user_uid'],
                                'time': Timestamp.now(),
                              })
                          .whenComplete(() {
                        followedNotification(
                            context, snapshot.data!['user_name']);
                      });
                    }),
                MaterialButton(
                    color: constantColors.blueColor,
                    child: Text(
                      'Message',
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    onPressed: () async {
                      bool isExist =
                          await Provider.of<ChatHelper>(context, listen: false)
                              .isChatExist(
                                  Provider.of<Authentication>(context,
                                          listen: false)
                                      .getUserUid,
                                  userUid);
                      if (isExist) {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: ChatPage(
                                    arguments: ChatPageArguments(
                                        chatId: Provider.of<ChatHelper>(context,
                                                listen: false)
                                            .groupChatId!,
                                        peerId: userUid,
                                        peerAvatar:
                                            snapshot.data!['user_image'],
                                        peerNickname: 'peerNickname')),
                                type: PageTransitionType.leftToRight));
                      } else {
                        Provider.of<ChatHelper>(context, listen: false)
                            .createChat(
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid,
                                userUid,
                                {
                              'member1': Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid,
                              'member2': userUid,
                            });
                        Navigator.push(

                            context,
                            PageTransition(
                                child: ChatPage(
                                    arguments: ChatPageArguments(
                                        chatId: Provider.of<ChatHelper>(context,
                                                listen: false)
                                            .groupChatId!,
                                        peerId: userUid,
                                        peerAvatar:
                                            snapshot.data!['user_image'],
                                        peerNickname: 'peerNickname')),
                                type: PageTransitionType.leftToRight));
                      }
                      /*
                      // print(userUid+ chatID.toString());

                      //return createChat(context, userUid);
                      List members = [
                        {
                          'user_uid': Provider.of<Authentication>(context,
                                  listen: false)
                              .getUserUid,
                          'user_image': Provider.of<FirebaseOperation>(context,
                                  listen: false)
                              .getUserImage,
                          'user_name': Provider.of<FirebaseOperation>(context,
                                  listen: false)
                              .getUserName,
                          'user_email': Provider.of<FirebaseOperation>(context,
                                  listen: false)
                              .getUserEmail,
                        },
                        {
                          'user_uid': userUid,
                          'user_image': snapshot.data!['user_image'],
                          'user_name': snapshot.data!['user_name'],
                          'user_email': snapshot.data!['user_email'],
                        }
                      ];
// if(FirebaseFirestore.instance
//     .collection('users')
//     .doc(Provider.of<Authentication>(context,
//     listen: false).getUserUid)
//     .collection('chatsid').doc(userUid).id == userUid ){
//   print('Yes');
// }
                      var uid = uuid.v1();
                      var v =  FirebaseFirestore.instance
                          .collection('users')
                          .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
                          .collection('chatsid').doc(userUid).id;
                      var vv =  userUid;
                          // FirebaseFirestore.instance
                          // .collection('users')
                          // .doc(userUid)
                          // .collection('chatsid').doc(Provider.of<Authentication>(context, listen: false).getUserUid).id;
                      print(v.toString() + '       '+vv.toString());
                      try {
                        if(
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
                            .collection('chatsid').doc(userUid).id.compareTo(userUid)==0
                            // ||
                            // FirebaseFirestore.instance
                            // .collection('users')
                            // .doc(userUid)
                            // .collection('chatsid').doc(Provider.of<Authentication>(context,
                            //     listen: false).getUserUid).id == Provider.of<Authentication>(context,
                            // listen: false).getUserUid
                        ){

                          // print(FirebaseFirestore.instance
                          //     .collection('users')
                          //     .doc(Provider.of<Authentication>(context,
                          //     listen: false).getUserUid)
                          //     .collection('chatsid').doc(userUid).id.toString());
                          // print('555555555555555555555555555555');

                          // print(userUid.toString()+"   "+
                          //     FirebaseFirestore.instance.collection('users').doc(Provider.of<Authentication>(context, listen: false).getUserUid).collection('chatsid').doc(userUid).id.toString());
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  child: SingleChatroom(),
                                  type: PageTransitionType.leftToRight));
                        }else{
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(Provider.of<Authentication>(context,
                              listen: false)
                              .getUserUid)
                              .collection('chatsid')
                              .doc(userUid)
                              .set({'chatid': userUid}).whenComplete(() {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(userUid)
                                .collection('chatsid')
                                .doc(Provider.of<Authentication>(context,
                                listen: false)
                                .getUserUid)
                                .set({
                              'chatid': Provider.of<Authentication>(context,
                                  listen: false)
                                  .getUserUid
                            });
                          }).whenComplete(() {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(Provider.of<Authentication>(context,
                                listen: false)
                                .getUserUid)
                                .collection('singlechats')
                                .doc(uid)
                                .set({
                              'members': FieldValue.arrayUnion(members),
                              'room_name': uid,
                            });
                          }).whenComplete(() {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(userUid)
                                .collection('singlechats')
                                .doc(uid)
                                .set({
                              'members': FieldValue.arrayUnion(members),
                              'room_name': uid,
                            });
                          }).whenComplete(() {
                            Provider.of<FirebaseOperation>(context, listen: false)
                                .createSingleChatroom(uid, {
                              'members': FieldValue.arrayUnion(members),
                              'room_name': uid,
                            });
                          }).whenComplete(() => Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  child: SingleChatroom(),
                                  type: PageTransitionType.leftToRight))
                          );
                        }
                       /* FirebaseFirestore.instance
                            .collection('users')
                            .doc(Provider.of<Authentication>(context,
                                    listen: false)
                                .getUserUid)
                            .collection('chatsid')
                            .doc(userUid)
                            .set({'chatid': userUid}).whenComplete(() {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(userUid)
                              .collection('chatsid')
                              .doc(Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid)
                              .set({
                            'chatid': Provider.of<Authentication>(context,
                                    listen: false)
                                .getUserUid
                          });
                        }).whenComplete(() {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid)
                              .collection('singlechats')
                              .doc(uid)
                              .set({
                            'members': FieldValue.arrayUnion(members),
                            'room_name': uid,
                          });
                        }).whenComplete(() {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(userUid)
                              .collection('singlechats')
                              .doc(uid)
                              .set({
                            'members': FieldValue.arrayUnion(members),
                            'room_name': uid,
                          });
                        }).whenComplete(() {
                          Provider.of<FirebaseOperation>(context, listen: false)
                              .createSingleChatroom(uid, {
                            'members': FieldValue.arrayUnion(members),
                            'room_name': uid,
                          });
                        }).whenComplete(() => Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: SingleChatroom(),
                                type: PageTransitionType.leftToRight))
                        );
                        */
                      } catch (e) {
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: SingleChatroom(),
                                type: PageTransitionType.leftToRight));
                      }

                      /*
                        List members = [
                          {
                            'user_uid': Provider.of<Authentication>(context,
                                listen: false)
                                .getUserUid,
                            'user_image': Provider.of<FirebaseOperation>(context,
                                listen: false)
                                .getUserImage,
                            'user_name': Provider.of<FirebaseOperation>(context,
                                listen: false)
                                .getUserName,
                            'user_email': Provider.of<FirebaseOperation>(context,
                                listen: false)
                                .getUserEmail,
                          },
                          {
                            'user_uid': userUid,
                            'user_image': snapshot.data!['user_image'],
                            'user_name': snapshot.data!['user_name'],
                            'user_email': snapshot.data!['user_email'],
                          }
                        ];

                        var uid = uuid.v1();
                        Provider.of<FirebaseOperation>(context, listen: false)
                            .createSingleChatroom(uid, {
                          'members': FieldValue.arrayUnion(members),
                          'room_name': uid,
                        }).whenComplete(() {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(Provider.of<Authentication>(context,
                              listen: false)
                              .getUserUid)
                              .collection('singlechats')
                              .doc(uid)
                              .set({
                            'members': FieldValue.arrayUnion(members),
                            'room_name': uid,
                          });
                        }).whenComplete(() {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(userUid)
                              .collection('singlechats')
                              .doc(uid)
                              .set({
                            'members': FieldValue.arrayUnion(members),
                            'room_name': uid,
                          });
                        }).whenComplete(() {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(userUid).collection('chatsid').doc(Provider.of<Authentication>(context,
                              listen: false)
                              .getUserUid).set({'chatid':Provider.of<Authentication>(context,
                              listen: false)
                              .getUserUid});
                        }).whenComplete(() {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(Provider.of<Authentication>(context,
                              listen: false)
                              .getUserUid).collection('chatsid').doc(userUid).set({'chatid':userUid});
                        }).whenComplete(() {
                          PageTransition(child: SingleChatroom(),type: PageTransitionType.leftToRight);
                        });
                     */
                      // Provider.of<ChatRoomHelper>(context, listen: false)
                      //     .showChatroom(context);
                      */
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /////////////////////////////

  Widget divider() {
    return Center(
      child: SizedBox(
        height: 25,
        width: 352,
        child: Divider(
          color: constantColors.whiteColor,
        ),
      ),
    );
  }

  ////////////////////////////////////////
  Widget middleProfile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  FontAwesomeIcons.userAltSlash,
                  color: constantColors.yellowColor,
                  size: 16,
                ),
                Text(
                  'Recently Added',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: constantColors.whiteColor),
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ],
      ),
    );
  }

//Image.asset('assetes/images/empty.png'),
  Widget footerProfile(BuildContext context, dynamic snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(snapshot.data!['user_uid'])
                .collection('posts')
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  children: snapshot.data.docs
                      .map<Widget>((DocumentSnapshot document) {
                    return GestureDetector(
                      onTap: () {
                        showPostDetails(context, document);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width,
                          child: FittedBox(
                            child: Image.network(document['post_image']),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
            }),
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: constantColors.darkColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  followedNotification(BuildContext context, String name) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150),
                child: Divider(
                  thickness: 4,
                  color: constantColors.whiteColor,
                ),
              ),
              Text(
                'Followed $name',
                style: TextStyle(
                    color: constantColors.whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.darkColor,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }

  checkFollowerSheet(BuildContext context, dynamic snapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(snapshot.data!['user_uid'])
                  .collection('followers')
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView(
                    children: snapshot.data.docs
                        .map<Widget>((DocumentSnapshot document) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return new ListTile(
                          onTap: () {
                            if (document['user_uid'] !=
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid) {
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child: AltProfile(
                                        userUid: document['user_uid'],
                                      ),
                                      type: PageTransitionType.leftToRight));
                            }
                          },
                          trailing: document['user_uid'] ==
                                  Provider.of<Authentication>(context,
                                          listen: false)
                                      .getUserUid
                              ? Container(
                                  height: 0.0,
                                  width: 0.0,
                                )
                              : MaterialButton(
                                  color: constantColors.blueColor,
                                  onPressed: () {},
                                  child: Text('Unfollow',
                                      style: TextStyle(
                                          color: constantColors.yellowColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16))),
                          leading: CircleAvatar(
                            backgroundColor: constantColors.darkColor,
                            backgroundImage:
                                NetworkImage(document['user_image']),
                          ),
                          title: Text(
                            document['user_name'],
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          subtitle: Text(
                            document['user_email'],
                            style: TextStyle(
                                color: constantColors.yellowColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        );
                      }
                    }).toList(),
                  );
                }
              },
            ),
          );
        });
  }

  showPostDetails(BuildContext context, DocumentSnapshot document) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.darkColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                child: FittedBox(
                  child: Image.network(document['post_image']),
                ),
              ),
              Text(
                document['caption'],
                style: TextStyle(
                    color: constantColors.yellowColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              Container(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (document['user_uid'] !=
                            Provider.of<Authentication>(context, listen: false)
                                .getUserUid) {
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  child: AltProfile(
                                    userUid: document['user_uid'],
                                  ),
                                  type: PageTransitionType.bottomToTop));
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: constantColors.blueGreyColor,
                        radius: 20,
                        backgroundImage: NetworkImage(
                          document['user_image'],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  document['caption'].toString(),
                                  style: TextStyle(
                                    color: constantColors.greenColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                child: RichText(
                                  text: TextSpan(
                                    text: document['user_name'],
                                    style: TextStyle(
                                      color: constantColors.blueColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            ' , ${Provider.of<PostFunction>(context, listen: false).getTimePosted.toString()}',
                                        style: TextStyle(
                                          color: constantColors.lightColor
                                              .withOpacity(0.8),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(document['caption'])
                            .collection('awards')
                            .snapshots(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return new ListView(
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data.docs
                                  .map<Widget>((DocumentSnapshot documnt) {
                                return Container(
                                  height: 30,
                                  width: 30,
                                  child: Image.network(document['award']),
                                );
                              }).toList(),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Provider.of<PostFunction>(context, listen: false)
                            .showCommentsSheet(
                                context, document, document['caption']);
                      },
                      child: Icon(
                        FontAwesomeIcons.comment,
                        color: constantColors.blueColor,
                        size: 22,
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(document['caption'])
                          .collection('comments')
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              snapshot.data.docs.length.toString(),
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              Container(
                width: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onLongPress: () {
                        Provider.of<PostFunction>(context, listen: false)
                            .showAwardsPresenter(context, document['caption']);
                      },
                      onTap: () {
                        Provider.of<PostFunction>(context, listen: false)
                            .showRewards(context, document['caption']);
                      },
                      child: Icon(
                        FontAwesomeIcons.award,
                        color: constantColors.yellowColor,
                        size: 22,
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(document['caption'])
                          .collection('awards')
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              snapshot.data.docs.length.toString(),
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  createChat(BuildContext context, String chatid) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
            .collection('chatsid')
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          return ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              chatID.add(document.id);
              notifyListeners();
              print(document.id);
            }),
          );
        });
  }
}

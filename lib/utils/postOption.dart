import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sm/constant/Constantcolors.dart';
import 'package:sm/screen/alt_profile/altProfile.dart';
import 'package:sm/screen/notification_page/notiication_helper.dart';
import 'package:sm/service/authentication.dart';
import 'package:sm/service/firebaseOperation.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostFunction with ChangeNotifier {
  TextEditingController commentController = TextEditingController();
  TextEditingController updateCaptionController = TextEditingController();
  ConstantColors constantColors = new ConstantColors();
  String ? imageTimePosted;
  String get getTimePosted => imageTimePosted!;

  showTimeAgo(dynamic timedata) {
    Timestamp time = timedata;
    DateTime dataTime = time.toDate();
    imageTimePosted = timeago.format(dataTime);
    print(imageTimePosted);
    notifyListeners();
  }

  showPostOptions(BuildContext context, String postId) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        color: constantColors.blueColor,
                        child: Text(
                          'Edit Caption',
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                child: Center(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 300,
                                        height: 50,
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: 'Add New Caption',
                                            hintStyle: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          controller: updateCaptionController,
                                        ),
                                      ),
                                      FloatingActionButton(
                                          backgroundColor:
                                              constantColors.redColor,
                                          child: Icon(
                                            FontAwesomeIcons.fileUpload,
                                            color: constantColors.whiteColor,
                                          ),
                                          onPressed: () {
                                            Provider.of<FirebaseOperation>(
                                                    context,
                                                    listen: false)
                                                .updateCaption(postId, {
                                              'caption':
                                                  updateCaptionController.text
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      MaterialButton(
                        color: constantColors.redColor,
                        child: Text(
                          'Delete Caption',
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: constantColors.darkColor,
                                title: Text(
                                  'Delete This Post',
                                  style: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                actions: [
                                  MaterialButton(
                                    child: Text(
                                      'No',
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: constantColors.whiteColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  MaterialButton(
                                    color: constantColors.redColor,
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () {
                                      Provider.of<FirebaseOperation>(context,
                                              listen: false)
                                          .deleteUserData(postId, 'posts')
                                          .whenComplete(() {
                                        Navigator.pop(context);
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.1,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            ),
          ),
        );
      },
    );
  }

  Future addLike(BuildContext context, String postId, String subDocId, String postUserID) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(subDocId)
        .set({
      'likes': FieldValue.increment(1),
      'user_name':
          Provider.of<FirebaseOperation>(context, listen: false).getUserName,
      'user_uid':
          Provider.of<Authentication>(context, listen: false).getUserUid,
      'user_image':
          Provider.of<FirebaseOperation>(context, listen: false).getUserImage,
      'user_email':
          Provider.of<FirebaseOperation>(context, listen: false).getUserEmail,
      'time': Timestamp.now(),
    }).whenComplete((){
      Provider.of<NotificationHelper>(context,listen: false).addNotification(context, postUserID, 'add Like');

    });
  }

  Future addComment(BuildContext context, String postId, String comment) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(comment)
        .set({
      'comment': comment,
      'user_name':
          Provider.of<FirebaseOperation>(context, listen: false).getUserName,
      'user_uid':
          Provider.of<Authentication>(context, listen: false).getUserUid,
      'user_image':
          Provider.of<FirebaseOperation>(context, listen: false).getUserImage,
      'user_email':
          Provider.of<FirebaseOperation>(context, listen: false).getUserEmail,
      'time': Timestamp.now(),
    });
  }

  showAwardsPresenter(BuildContext context, String postId) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150),
                child: Divider(
                  thickness: 4,
                  color: constantColors.whiteColor,
                ),
              ),
              Container(
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: constantColors.whiteColor,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    'Award Socialites',
                    style: TextStyle(
                        color: constantColors.blueColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(postId)
                        .collection('awards')
                        .orderBy('time')
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                                return ListTile(
                                  leading: GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          PageTransition(
                                              child: AltProfile(
                                                userUid: document['user_uid'],
                                              ),
                                              type: PageTransitionType.bottomToTop));
                                    },
                                    child: CircleAvatar(
                                      backgroundImage:
                                      NetworkImage(document['user_image']),
                                      radius: 15,backgroundColor: constantColors.darkColor,
                                    ),
                                  ),
                                  trailing: Provider.of<Authentication>(context,
                                      listen: false)
                                      .getUserUid ==
                                      document['user_uid']
                                      ? Container(
                                    width: 0,
                                    height: 0,
                                  )
                                      : MaterialButton(
                                    onPressed: () {},
                                    color: constantColors.blueColor,
                                    child: Text(
                                      'Follow',
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ),
                                    title: Text(
                                      document['user_name'],
                                      style: TextStyle(
                                          color: constantColors.blueColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),

                                );
                          }),
                        );
                      }
                    }),
              ),
            ],
          ),
        );
      },
    );
  }

  showCommentsSheet(
      BuildContext context, DocumentSnapshot snapshot, String postId) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          //double bottom = MediaQuery.of(context).viewInsets.bottom;
          return Padding(
            padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.55,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150),
                    child: Divider(
                      thickness: 4,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Container(
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: constantColors.whiteColor,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        'Comments',
                        style: TextStyle(
                            color: constantColors.blueColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.42,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(postId)
                          .collection('comments')
                          .orderBy('time')
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListView(
                            children: snapshot.data.docs
                                .map<Widget>((DocumentSnapshot document) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.167,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  PageTransition(
                                                      child: AltProfile(
                                                        userUid: document[
                                                            'user_uid'],
                                                      ),
                                                      type: PageTransitionType
                                                          .bottomToTop));
                                            },
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  constantColors.darkColor,
                                              radius: 15,
                                              backgroundImage: NetworkImage(
                                                  document['user_image']),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Container(
                                            child: Text(
                                              document['user_name'].toString(),
                                              style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                    FontAwesomeIcons.arrowUp,
                                                    color: constantColors
                                                        .blueColor,
                                                    size: 12,
                                                  )),
                                              Text(
                                                '0',
                                                style: TextStyle(
                                                    color: constantColors
                                                        .whiteColor,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                    FontAwesomeIcons.reply,
                                                    color: constantColors
                                                        .yellowColor,
                                                    size: 12,
                                                  )),
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                    FontAwesomeIcons.trashAlt,size: 12,
                                                    color:
                                                        constantColors.redColor,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 400,
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              color: constantColors.blueColor,
                                              size: 12,
                                            ),
                                            onPressed: () {},
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.75,
                                            child: Text(
                                              document['comment'],
                                              style: TextStyle(
                                                  color:
                                                      constantColors.whiteColor,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: constantColors.darkColor
                                          .withOpacity(0.4),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ),
                  Container(
                    width: 400,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 300,
                          height: 20,
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                                hintText: 'Add Comment....',
                                hintStyle: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            controller: commentController,
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            print('Adding Comment....');
                            addComment(context, snapshot['caption'],
                                    commentController.text)
                                .whenComplete(() {
                                  Provider.of<NotificationHelper>(context,listen: false).addNotification(context, snapshot['user_uid'], 'add Comment');
                              commentController.clear();
                              notifyListeners();
                            });
                          },
                          backgroundColor: constantColors.greenColor,
                          child: Icon(
                            FontAwesomeIcons.comment,
                            color: constantColors.whiteColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    topLeft: Radius.circular(12),
                  )),
            ),
          );
        });
  }

  showLikes(BuildContext context, String postId) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150),
                child: Divider(
                  thickness: 4,
                  color: constantColors.whiteColor,
                ),
              ),
              Container(
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: constantColors.whiteColor,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    'Likes',
                    style: TextStyle(
                        color: constantColors.blueColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(postId)
                        .collection('likes')
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView(
                          children:
                              snapshot.data.docs.map<Widget>((DocumentSnapshot document) {
                            return ListTile(
                              leading: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: AltProfile(
                                            userUid: document['user_uid'],
                                          ),
                                          type: PageTransitionType.bottomToTop));
                                },
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(document['user_image']),
                                ),
                              ),
                              title: Text(
                                document['user_name'],
                                style: TextStyle(
                                    color: constantColors.blueColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              subtitle: Text(
                                document['user_email'],
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                              trailing: Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid ==
                                      document['user_uid']
                                  ? Container(
                                      width: 0,
                                      height: 0,
                                    )
                                  : MaterialButton(
                                      onPressed: () {},
                                      color: constantColors.blueColor,
                                      child: Text(
                                        'Follow',
                                        style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                    ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
              )
            ],
          ),
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft: Radius.circular(12),
              )),
        );
      },
    );
  }

  showRewards(BuildContext context, String postId) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150),
                child: Divider(
                  thickness: 4,
                  color: constantColors.whiteColor,
                ),
              ),
              Container(
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: constantColors.whiteColor,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    'Rewards',
                    style: TextStyle(
                        color: constantColors.blueColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('awards')
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
                                onTap: () async {
                                  await Provider.of<FirebaseOperation>(context,
                                          listen: false)
                                      .addAward(postId, {
                                    'user_name': Provider.of<FirebaseOperation>(
                                            context,
                                            listen: false)
                                        .getUserName,
                                    'user_image':
                                        Provider.of<FirebaseOperation>(context,
                                                listen: false)
                                            .getUserImage,
                                    'user_uid': Provider.of<Authentication>(
                                            context,
                                            listen: false)
                                        .getUserUid,
                                    'time': Timestamp.now(),
                                    'award': document['image'],
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    child: Image.network(document['image']),
                                  ),
                                ),
                              );
                            }),
                          );
                        }
                      }),
                ),
              ),
            ],
          ),
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft: Radius.circular(12),
              )),
        );
      },
    );
  }
}

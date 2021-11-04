import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sm/constant/Constantcolors.dart';
import 'package:sm/screen/alt_profile/altProfile.dart';
import 'package:sm/screen/landing_page/landingPage.dart';
import 'package:sm/screen/stories/stories_widget.dart';
import 'package:sm/service/authentication.dart';
import 'package:sm/utils/postOption.dart';

class ProfileHelper with ChangeNotifier {
  StoryWidget storyWidget = StoryWidget();
  ConstantColors constantColors = new ConstantColors();

  Widget headProfile(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              height: 220,
              //width: MediaQuery.of(context).size.width * 0.48,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      storyWidget.addStory(context);
                    },
                    child: Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              constantColors.transperant.withOpacity(0.5),
                          radius: 60,
                          backgroundImage:
                              NetworkImage(snapshot.data!['user_image']),
                        ),
                        Positioned(
                          top: 91,
                          left: 90,
                          child: Icon(FontAwesomeIcons.plusCircle,
                              color: constantColors.whiteColor),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        snapshot.data!['user_name'],
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:8,top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          EvaIcons.email,
                          color: constantColors.lightBlueColor,
                          size: 16,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                snapshot.data!['user_email'],
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),
                              ),
                            
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
                              'Follower',
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          checkFollowingSheet(context, snapshot);
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
                                'Following',
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
                        Text(
                          '0',
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 28),
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
    );
  }

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

  Widget middleProfile(BuildContext context, dynamic snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 110,
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
                  ' Highlights',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: constantColors.whiteColor),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(snapshot.data!['user_uid'])
                    .collection('highlights')
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      children: snapshot.data.docs
                          .map<Widget>((DocumentSnapshot document) {
                        return GestureDetector(
                          onTap:(){
                            storyWidget.previewAllHighlights(context, document['title']);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor:constantColors.darkColor,
                                    backgroundImage:
                                        NetworkImage(document['cover']),
                                    radius: 20,
                                  ),
                                  Text(
                                    document['title'],
                                    style: TextStyle(
                                        color: constantColors.greenColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                        // Container(
                        //   height: 60,
                        //   width: 60,
                        //   child: Image.network(document['user_image']),
                        // );
                      }).toList(),
                    );
                  }
                },
              ),
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.darkColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
              }else {
                if(snapshot.data.docs.length== 0){
                  return Container(height:100,width: 100,child: Image.asset('asstes/images/empty.png'));
                }
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
                            child:Image.network(document['post_image']),
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

  LogOutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: constantColors.darkColor,
          title: Text(
            'Log Out Of The Social ?',
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
                Provider.of<Authentication>(context, listen: false)
                    .logOutViaEmail()
                    .whenComplete(() {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: LandingPage(),
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

  checkFollowingSheet(BuildContext context, dynamic snapshot) {
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
                  .collection('following')
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView(
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return new ListTile(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: AltProfile(
                                      userUid: document['user_uid'],
                                    ),
                                    type: PageTransitionType.topToBottom));
                          },
                          trailing: MaterialButton(
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
}

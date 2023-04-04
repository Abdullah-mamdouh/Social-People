import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sm/constant/Constantcolors.dart';
import 'package:sm/screen/alt_profile/altProfile.dart';
import 'package:sm/screen/stories/stories.dart';
import 'package:sm/service/authentication.dart';
import 'package:sm/utils/postOption.dart';
import 'package:sm/utils/uploadPost.dart';
import 'package:intl/intl.dart';
import '../../service/firebaseOperation.dart';
import '../live_streaming/agora/host.dart';
import '../live_streaming/agora/join.dart';
import '../live_streaming/home.dart';

class FeedHelper with ChangeNotifier {
  ConstantColors constantColors = new ConstantColors();

  appBar(BuildContext context) {
    return AppBar(
      backgroundColor: constantColors.darkColor.withOpacity(0.6),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            onCreate(context);
          },
          icon: Image.asset('asstes/icons/live.png',fit: BoxFit.cover),),
        IconButton(
            onPressed: () {
              Provider.of<UploadPost>(context, listen: false)
                  .selectPostImageType(context);
            },
            icon: Icon(
              Icons.camera_enhance_rounded,
              color: constantColors.greenColor,
            )),

      ],
      title: RichText(
        text: TextSpan(
          text: 'Social ',
          style: TextStyle(
            color: constantColors.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'Feed ',
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

  Widget feedBody(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));
                    },
                    icon: Icon(
                      Icons.view_stream_outlined,
                      color: constantColors.greenColor,
                    )),
                Expanded(
                  child: Container(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('stories')
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children:
                                snapshot.data.docs.map<Widget>((DocumentSnapshot document) {
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: Stories(documentSnapshot: document,),
                                            type: PageTransitionType.leftToRight));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Container(
                                      height: 30,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(image: NetworkImage(document['user_image']),fit: BoxFit.cover),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: constantColors.blueColor,
                                              width: 2),
                                      ),
                                    ),
                                  ));
                            }).toList(),
                          );
                        }
                      },
                    ),
                    width: size.width,
                    height: size.height * 0.06,
                    decoration: BoxDecoration(
                      color: constantColors.darkColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SizedBox(
                        height: 500,
                        width: 400,
                        child: Lottie.asset('asstes/animations/loading.json'),
                      ),
                    );
                  } else {
                    return //Container();
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Expanded(child: loadPost(context, snapshot)),
                        );
                  }
                }),
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor.withOpacity(0.5),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18)),
            ),
          ),
          //const SizedBox(height: 100,),
        ],
      ),
    );
  }

  Widget loadPost(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView(
      children: snapshot.data!.docs.map<Widget>((DocumentSnapshot document) {
        Provider.of<PostFunction>(context, listen: false)
            .showTimeAgo(document['time']);
        return Expanded(
          child: Container(
            //height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0.2, left: 5),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (document['user_uid'] !=
                              Provider.of<Authentication>(context, listen: false)
                                  .getUserUid) {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: AltProfile(
                                      userUid: document['user_uid'],
                                    ),
                                    type: PageTransitionType.bottomToTop));
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: CircleAvatar(
                            backgroundColor: constantColors.blueGreyColor,
                            radius: 20,
                            backgroundImage: NetworkImage(
                              document['user_image'],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  child: Text(
                                    document['caption'].toString(),
                                    style: TextStyle(
                                      color: constantColors.greenColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
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
                      /*Container(
                        width: MediaQuery.of(context).size.width * 0.3,
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
                      ),*/
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                    /*child: FittedBox(
                      child: Image.network(
                        document['post_image'],fit: BoxFit.cover,
                        //scale: 15,
                      ),
                    ),*/
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage( document['post_image'],),
                        fit: BoxFit.fill,
                      )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0,left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onLongPress: () {
                                Provider.of<PostFunction>(context,
                                        listen: false)
                                    .showLikes(context, document['caption']);
                              },
                              onTap: () {
                                Provider.of<PostFunction>(context,
                                        listen: false)
                                    .addLike(
                                        context,
                                        document['caption'],
                                        Provider.of<Authentication>(context,
                                                listen: false)
                                            .getUserUid, document['user_uid']);
                              },
                              child: Icon(
                                FontAwesomeIcons.heart,
                                color: constantColors.redColor,
                                size: 22,
                              ),
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('posts')
                                  .doc(document['caption'])
                                  .collection('likes')
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
                              onTap: () {
                                Provider.of<PostFunction>(context,
                                        listen: false)
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
                                Provider.of<PostFunction>(context,
                                        listen: false)
                                    .showAwardsPresenter(
                                        context, document['caption']);
                              },
                              onTap: () {
                                Provider.of<PostFunction>(context,
                                        listen: false)
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
                      //Spacer(),
                      Provider.of<Authentication>(context, listen: false)
                                  .getUserUid ==
                              document['user_uid']
                          ? IconButton(
                              onPressed: () {
                                Provider.of<PostFunction>(context,
                                        listen: false)
                                    .showPostOptions(
                                        context, document['caption']);
                              },
                              icon: Icon(
                                EvaIcons.moreHorizontal,
                                color: constantColors.whiteColor,
                              ))
                          : Container(
                              height: 0,
                              width: 0,
                            ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                  child: Divider(
                    thickness: 6,
                    color: constantColors.lightColor.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> onCreate(BuildContext context) async {
    // await for camera and mic permissions before pushing video page
    await _handleCameraAndMic();
    var date = DateTime.now();
    var currentTime = '${DateFormat("dd-MM-yyyy hh:mm:ss").format(date)}';
    // push video page with given channel name
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallPage(
          channelName: Provider.of<FirebaseOperation>(context)
              .getUserName,
          time: currentTime ,
          image: Provider.of<FirebaseOperation>(context)
              .getUserImage,
        ),
      ),
    );

  }

  Future<void> _handleCameraAndMic() async {
    await [Permission.microphone, Permission.camera].request();
    // await PermissionHandler().requestPermissions(
    //   [PermissionGroup.camera, PermissionGroup.microphone],
    // );
  }
}

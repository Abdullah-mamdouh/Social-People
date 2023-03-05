import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sm/constant/Constantcolors.dart';
import 'package:sm/screen/alt_profile/altProfile.dart';
import 'package:sm/screen/home_page/homePage.dart';
import 'package:sm/screen/landing_page/landingService.dart';
import 'package:sm/screen/stories/storiesHelper.dart';
import 'package:sm/service/authentication.dart';
import 'package:sm/service/firebaseOperation.dart';

class StoryWidget {
  final ConstantColors constantColors = new ConstantColors();
  TextEditingController storyHightlightTitleController =
      TextEditingController();

  addStory(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 150),
                child: Divider(
                  thickness: 4,
                  color: constantColors.whiteColor,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    onPressed: () {
                     // pickerUserAvatar(context, ImageSource.gallery);
                      Provider.of<StoriesHepher>(context, listen: false)
                          .selectStoryImage(context, ImageSource.gallery)
                          .whenComplete(() {
                        //Navigator.pop(context);
                      });
                    },
                    child: Text(
                      'Gallery',
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Provider.of<StoriesHepher>(context, listen: false)
                          .selectStoryImage(context, ImageSource.camera)
                          .whenComplete(() {
                        Navigator.pop(context);
                        // Provider.of<LandingService>(context, listen: false)
                        //     .showUserAvatar(context);
                      });
                    },
                    child: Text(
                      'Camera',
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          height: MediaQuery.of(context).size.height * 0.1,
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

  previewStoryImage(BuildContext context, File storyImage) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.darkColor,
          ),
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.file(storyImage),
              ),
              Positioned(
                  top: MediaQuery.of(context).size.height*0.9,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FloatingActionButton(
                            heroTag: 'Reselect Image',
                            backgroundColor: constantColors.redColor,
                            child: Icon(
                              FontAwesomeIcons.backspace,
                              color: constantColors.whiteColor,
                            ),
                            onPressed: () {
                              addStory(context);
                            }),
                        FloatingActionButton(
                            heroTag: 'Confire Image',
                            backgroundColor: constantColors.blueColor,
                            child: Icon(
                              FontAwesomeIcons.check,
                              color: constantColors.whiteColor,
                            ),
                            onPressed: () {
                              Provider.of<StoriesHepher>(context, listen: false)
                                  .uploadStoryImage()
                                  .whenComplete(() async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('stories')
                                      .doc(Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid)
                                      .set({
                                    'image': Provider.of<StoriesHepher>(context,
                                            listen: false)
                                        .getstoryImageUrl,
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
                                  }).whenComplete(() {
                                    Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                            child: HomePage(),
                                            type: PageTransitionType
                                                .bottomToTop));
                                  });
                                } catch (e) {
                                  print(e.toString());
                                }
                              });
                            }),
                      ],
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }

  addToHightlights(BuildContext context, String storyImage) {
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
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor.withOpacity(0.4),
                  ),
                ),
                Text(
                  'Add To Existing Album',
                  style: TextStyle(
                      color: constantColors.yellowColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(Provider.of<Authentication>(context,listen: false)
                            .getUserUid)
                        .collection('highlights')
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      else if(snapshot.hasData) {
                        return ListView(
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data.docs
                              .map<Widget>((DocumentSnapshot document) {
                            return GestureDetector(
                              onTap: () {
                                Provider.of<StoriesHepher>(context,
                                        listen: false)
                                    .addStoryToExistingAlbum(context, Provider.of<Authentication>(context, listen: false)
                                    .getUserUid,
                                        document.id, storyImage);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: document['cover'] != null ? Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            constantColors.darkColor,
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
                                ): const SizedBox(height: 0,width: 0,) ,
                              ),
                            );
                          }).toList(),
                        );
                      }else{
                        return Container(width: 0,height: 0,);
                      }
                    },
                  ),
                  //height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                ),
                Text(
                  'Create New Album',
                  style: TextStyle(
                      color: constantColors.greenColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),

                /// At Future
                /*Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chatroomIcons')
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
                              .map((DocumentSnapshot document) {
                            return GestureDetector(
                              onTap: () {
                                Provider.of<StoriesHepher>(context,
                                        listen: false)
                                    .convertHighlightedIcon(document['image']);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  child: Image.network(document['image']),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
                */
                Container(
                  //height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          textCapitalization: TextCapitalization.sentences,
                          controller: storyHightlightTitleController,
                          style: TextStyle(
                              color: constantColors.yellowColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                          decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  color: constantColors.yellowColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              hintText: 'Add Album Title....'),
                        ),
                      ),
                      FloatingActionButton(
                          backgroundColor: constantColors.blueColor,
                          child: Icon(
                            FontAwesomeIcons.check,
                            color: constantColors.whiteColor,
                          ),
                          onPressed: () {
                            if (storyHightlightTitleController
                                .text.isNotEmpty) {
                              // Provider.of<StoriesHepher>(context, listen: false)
                              //     .addStoryToNewAlbum(
                              //         context,
                              //         Provider.of<Authentication>(context,
                              //                 listen: false)
                              //             .getUserUid,
                              //         storyHightlightTitleController.text,
                              //         storyImage);
                            } else {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    color: constantColors.darkColor,
                                    height: 100,
                                    width: 400,
                                    child: Center(
                                      child: Text('Add Album Title'),
                                    ),
                                  );
                                },
                              );
                            }
                          }),
                    ],
                  ),
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
    );
  }

  showViewers(BuildContext context, String storyId, String personId) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150.0),
                child: Divider(
                  thickness: 4,
                  color: constantColors.whiteColor,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('stories')
                        .doc(storyId)
                        .collection('seen')
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView(
                          children: snapshot.data.docs
                              .map((DocumentSnapshot document) {
                            Provider.of<StoriesHepher>(context, listen: false)
                                .storyTimePosted(document['time']);
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(document['user_image']),
                                backgroundColor: constantColors.darkColor,
                                radius: 25,
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.arrowCircleRight,
                                  color: constantColors.yellowColor,
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          child: AltProfile(
                                            userUid: document['user_uid'],
                                          ),
                                          type:
                                              PageTransitionType.bottomToTop));
                                },
                              ),
                              title: Text(
                                document['user_name'],
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                Provider.of<StoriesHepher>(context,
                                        listen: false)
                                    .getLastSeenTime,
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    }),
              )
            ],
          ),
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: BorderRadius.circular(12.0)),
        );
      },
    );
  }

  previewAllHighlights(BuildContext context, String highlighTitle) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(Provider.of<Authentication>(context, listen: false)
                    .getUserUid)
                .collection('highlights')
                // .doc(highlighTitle)
                // .collection('stories')
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return PageView(
                  children: snapshot.data.docs.map<Widget>((DocumentSnapshot document) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(document['cover']),
                    );
                  }).toList(),
                );
              }
            },
          ),
        );
      },
    );
  }
}

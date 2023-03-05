import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sm/constant/Constantcolors.dart';
import 'package:sm/screen/home_page/homePage.dart';
import 'package:sm/screen/stories/storiesHelper.dart';
import 'package:sm/screen/stories/stories_widget.dart';
import 'package:sm/service/authentication.dart';

class Stories extends StatefulWidget {
  Stories({Key? key, @required this.documentSnapshot}) : super(key: key);
  DocumentSnapshot? documentSnapshot;
  @override
  _StoriesState createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  StoryWidget storyWidget = new StoryWidget();
  ConstantColors constantColors = new ConstantColors();

  @override
  void initState() {
    Provider.of<StoriesHepher>(context, listen: false)
        .storyTimePosted(widget.documentSnapshot!['time']);
    Provider.of<StoriesHepher>(context, listen: false).addSeenStamp(
        context,
        widget.documentSnapshot!.id,
        Provider.of<Authentication>(context, listen: false).getUserUid,
        widget.documentSnapshot!);
    Timer(
        Duration(seconds: 15),
        () => Navigator.pushReplacement(
            context,
            PageTransition(
                child: HomePage(), type: PageTransitionType.bottomToTop)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      //backgroundColor: constantColors.darkColor,
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          // constraints: BoxConstraints(
          //     maxWidth: size.width),
          child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: constantColors.darkColor,
                backgroundImage: NetworkImage(
                  widget.documentSnapshot!['user_image'],
                ),
                radius: 25,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.documentSnapshot!['user_name'],
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    Provider.of<StoriesHepher>(context, listen: false)
                        .getLastSeenTime,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        color: constantColors.greenColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Provider.of<Authentication>(context, listen: false)
                          .getUserUid ==
                      widget.documentSnapshot!['user_uid']
                  ? GestureDetector(
                      onTap: () {
                        storyWidget.showViewers(
                            context,
                            widget.documentSnapshot!.id,
                            widget.documentSnapshot!['user_uid']);
                      },
                      child: Row(
                        // mainAxisAlignment:
                        //     MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            FontAwesomeIcons.solidEye,
                            color: constantColors.yellowColor,
                            size: 16,
                          ),
                          const SizedBox(width: 5,),
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('stories')
                                .doc(widget.documentSnapshot!.id)
                                .collection('seen')
                                .snapshots(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return Text(
                                  snapshot.data.docs.length.toString(),
                                  style: TextStyle(
                                      color: constantColors.greenColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                );
                              }
                            },
                          )
                        ],
                      ),
                    )
                  : Container(
                      width: 0,
                      height: 0,
                    ),
              SizedBox(
                height: 20,
                width: 20,
                child: CircularCountDownTimer(
                  isTimerTextShown: false,
                  duration: 15,
                  fillColor: constantColors.blueColor,
                  width: 10,
                  height: 10,
                  ringColor: constantColors.darkColor,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Provider.of<Authentication>(context, listen: false)
              .getUserUid ==
              widget.documentSnapshot!['user_uid']
              ? IconButton(
              onPressed: () {
                showMenu(
                    color: constantColors.darkColor,
                    context: context,
                    position: RelativeRect.fromLTRB(
                        300.0, 700.0, 0.0, 0.0),
                    items: [
                      PopupMenuItem(
                          child: FlatButton.icon(
                              onPressed: () {
                                Provider.of<StoriesHepher>(
                                    context,
                                    listen: false)
                                    .saveToHighLights(
                                    context,
                                    Provider.of<Authentication>(
                                        context,
                                        listen: false)
                                        .getUserUid,
                                    // storyHightlightTitleController.text,
                                    widget.documentSnapshot![
                                    'image']);
                                // storyWidget.addToHightlights(
                                //     context,
                                //     widget.documentSnapshot!['user_image']);
                              },
                              color: constantColors.blueColor,
                              icon: Icon(
                                FontAwesomeIcons.archive,
                                color: constantColors.whiteColor,
                              ),
                              label: Text(
                                'Add To Hightlights',
                                style: TextStyle(
                                    color: constantColors
                                        .whiteColor),
                              ))),
                      PopupMenuItem(
                          child: FlatButton.icon(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('stories')
                                    .doc(Provider.of<
                                    Authentication>(
                                    context,
                                    listen: false)
                                    .getUserUid)
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
                              icon: Icon(
                                FontAwesomeIcons.archive,
                                color: constantColors.whiteColor,
                              ),
                              label: Text(
                                'Delete',
                                style: TextStyle(
                                    color: constantColors
                                        .whiteColor),
                              )))
                    ]);
              },
              icon: Icon(
                EvaIcons.moreVertical,
                color: constantColors.whiteColor,
              ))
              : Container(
            width: 0,
            height: 0,
          ),
        ],
      ),
      body: GestureDetector(
        onPanUpdate: (update) {
          if (update.delta.dx > 0) {
            debugPrint(update.toString());
            Navigator.pop(context);
            // Navigator.pushReplacement(
            //     context,
            //     PageTransition(
            //         child: HomePage(), type: PageTransitionType.bottomToTop));
          }
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                height: size.height,
                width: size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(widget.documentSnapshot!['image']),
                      fit: BoxFit.cover),
                ),
              ),
            ),
            /*Expanded(
              child: Positioned(
                  top: 15.0,
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: size.width),
                    child: Expanded(
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor: constantColors.darkColor,
                              backgroundImage: NetworkImage(
                                widget.documentSnapshot!['user_image'],
                              ),
                              radius: 25,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Expanded(
                              child: Container(
                                //color: constantColors.redColor,
                                width: size.width * 0.4,
                                constraints: BoxConstraints(
                                    maxWidth:
                                        size.width *
                                            0.9),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.documentSnapshot!['user_name'],
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      Provider.of<StoriesHepher>(context,
                                              listen: false)
                                          .getLastSeenTime,
                                      style: TextStyle(
                                          color: constantColors.greenColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Provider.of<Authentication>(context, listen: false)
                                      .getUserUid ==
                                  widget.documentSnapshot!['user_uid']
                              ? GestureDetector(
                                  onTap: () {
                                    storyWidget.showViewers(
                                        context,
                                        widget.documentSnapshot!.id,
                                        widget.documentSnapshot!['user_uid']);
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 30,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.solidEye,
                                          color: constantColors.yellowColor,
                                          size: 16,
                                        ),
                                        StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('stories')
                                              .doc(widget.documentSnapshot!.id)
                                              .collection('seen')
                                              .snapshots(),
                                          builder: (context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            } else {
                                              return Text(
                                                snapshot.data.docs.length
                                                    .toString(),
                                                style: TextStyle(
                                                    color: constantColors
                                                        .greenColor,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              );
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 0,
                                  height: 0,
                                ),
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularCountDownTimer(
                              isTimerTextShown: false,
                              duration: 15,
                              fillColor: constantColors.blueColor,
                              width: 10,
                              height: 10,
                              ringColor: constantColors.darkColor,
                            ),
                          ),
                          Provider.of<Authentication>(context, listen: false)
                                      .getUserUid ==
                                  widget.documentSnapshot!['user_uid']
                              ? IconButton(
                                  onPressed: () {
                                    showMenu(
                                        color: constantColors.darkColor,
                                        context: context,
                                        position: RelativeRect.fromLTRB(
                                            300.0, 700.0, 0.0, 0.0),
                                        items: [
                                          PopupMenuItem(
                                              child: FlatButton.icon(
                                                  onPressed: () {
                                                    storyWidget.addToHightlights(
                                                        context,
                                                        widget.documentSnapshot![
                                                            'image']);
                                                  },
                                                  color:
                                                      constantColors.blueColor,
                                                  icon: Icon(
                                                    FontAwesomeIcons.archive,
                                                    color: constantColors
                                                        .whiteColor,
                                                  ),
                                                  label: Text(
                                                    'Add To Hightlights',
                                                    style: TextStyle(
                                                        color: constantColors
                                                            .whiteColor),
                                                  ))),
                                          PopupMenuItem(
                                              child: FlatButton.icon(
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection('stories')
                                                        .doc(Provider.of<
                                                                    Authentication>(
                                                                context,
                                                                listen: false)
                                                            .getUserUid)
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
                                                  color:
                                                      constantColors.redColor,
                                                  icon: Icon(
                                                    FontAwesomeIcons.archive,
                                                    color: constantColors
                                                        .whiteColor,
                                                  ),
                                                  label: Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                        color: constantColors
                                                            .whiteColor),
                                                  )))
                                        ]);
                                  },
                                  icon: Icon(
                                    EvaIcons.moreVertical,
                                    color: constantColors.whiteColor,
                                  ))
                              : Container(
                                  width: 0,
                                  height: 0,
                                ),
                        ],
                      ),
                    ),
                  )),
            )*/
          ],
        ),
      ),
    );
  }
}

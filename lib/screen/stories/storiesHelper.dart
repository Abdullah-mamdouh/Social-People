import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sm/screen/stories/stories_widget.dart';
import 'package:sm/service/authentication.dart';
import 'package:sm/service/firebaseOperation.dart';
import 'package:timeago/timeago.dart' as timeago;

class StoriesHepher with ChangeNotifier {
  UploadTask? imageUploadTask;
  final picker = ImagePicker();
  File? storyImage;
  File get getStoryImage => storyImage!;
  final StoryWidget storyWidget = StoryWidget();
  String? storyImageUrl, storyHighlightIcon,lastSeenTime;
  String get getstoryImageUrl => storyImageUrl!;
  String get getstoryHighlightIcon => storyHighlightIcon!;
  //String get getStoryTimePosted => StoryTimePosted!;
  String get getLastSeenTime => lastSeenTime!;

  storyTimePosted(dynamic timedata) {
    Timestamp time = timedata;
    DateTime dataTime = time.toDate();
    lastSeenTime = timeago.format(dataTime);
    print(lastSeenTime);
    notifyListeners();
  }

  Future selectStoryImage(BuildContext context, ImageSource source) async {
    final pickedStoryImage = await picker.getImage(source: source);
    pickedStoryImage == null
        ? print('Error')
        : storyImage = File(pickedStoryImage.path);
    storyImage != null
        ? storyWidget.previewStoryImage(context, storyImage!)
        : print('Error');
    notifyListeners();
  }

  Future uploadStoryImage() async {
    Reference imageReferenc = FirebaseStorage.instance
        .ref()
        .child('stories/${getStoryImage.path}/${TimeOfDay.now()}');
    imageUploadTask = imageReferenc.putFile(getStoryImage);
    await imageUploadTask!.whenComplete(() {
      print('Post Image upload to srorage');
    });
    imageReferenc.getDownloadURL().then((imageUrl) {
      storyImageUrl = imageUrl;
      print(storyImageUrl);
    });
    notifyListeners();
  }

  Future convertHighlightedIcon(String firestoreImageUrl) async {
    storyHighlightIcon = firestoreImageUrl;
    print(storyHighlightIcon);
    notifyListeners();
  }

  Future addStoryToNewAlbum(BuildContext context, String userUid,
      String highlightName, String storyImage) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('highlights')
        .doc(highlightName)
        .set({
      'title': highlightName,
      'cover': storyHighlightIcon,
    }).whenComplete(() {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .collection('highlights')
          .doc(highlightName)
          .collection('stories')
          .add({
        'image': getstoryImageUrl,
        'user_name':
            Provider.of<FirebaseOperation>(context, listen: false).getUserName,
        'user_image':
            Provider.of<FirebaseOperation>(context, listen: false).getUserImage,
      });
    });
  }

  Future addStoryToExistingAlbum(BuildContext context, String userUid,
      String highlightColId, String storyImage) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('highlights')
        .doc(highlightColId).collection('stories').add({
      'image': storyImage,
      'user_name':
      Provider.of<FirebaseOperation>(context, listen: false).getUserName,
      'user_image':
      Provider.of<FirebaseOperation>(context, listen: false).getUserImage,
      'user_uid':
      Provider.of<Authentication>(context, listen: false).getUserUid,
    }
    );

  }

  addSeenStamp(BuildContext context, String storyId, String personId,
      DocumentSnapshot document) async{
    if (document['user_uid'] !=
        Provider.of<Authentication>(context, listen: false).getUserUid) {
      return FirebaseFirestore.instance
          .collection('stories')
          .doc(storyId)
          .collection('seen')
          .doc(personId)
          .set({
        'time': Timestamp.now(),
        'user_name':
            Provider.of<FirebaseOperation>(context, listen: false).getUserName,
        'user_image':
            Provider.of<FirebaseOperation>(context, listen: false).getUserImage,
        'user_uid':
            Provider.of<Authentication>(context, listen: false).getUserUid,
      });
    }
  }
}

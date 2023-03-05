import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sm/screen/landing_page/landingUtils.dart';
import 'package:sm/service/authentication.dart';
import 'package:uuid/uuid.dart';

class FirebaseOperation with ChangeNotifier {
  late UploadTask imageUploadTask;
  String initUserName = '';
  String initUserEmail = '';
  String initUserImage = '';
  String get getUserName => initUserName;
  String get getUserEmail => initUserEmail;
  String get getUserImage => initUserImage;
  late var uuid = Uuid();

  Future uploadUserAvatar(BuildContext context) async {
    Reference imageReferenc = FirebaseStorage.instance.ref().child(
        'userProfileAvatar/${Provider.of<LandingUtils>(context, listen: false).getUserAvatar.path}/${TimeOfDay.now()}');

    imageUploadTask = imageReferenc.putFile(
        Provider.of<LandingUtils>(context, listen: false).getUserAvatar);
    await imageUploadTask.whenComplete(() {
      debugPrint('Image upload');
    });
    imageReferenc.getDownloadURL().then((url) {
      Provider.of<LandingUtils>(context, listen: false).userAvatarUrl =
          url.toString();
      debugPrint(
          'the user profile avatar url => ${Provider.of<LandingUtils>(context, listen: false).getUserAvatar}');
      debugPrint(
          'hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh');
      notifyListeners();
    });
  }

  Future createUserCollectin(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .set(data);
  }

  Future initUserDate(BuildContext context) async {
    debugPrint(Provider.of<Authentication>(context, listen: false).getUserUid);
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .get()
        .then((doc) {
      debugPrint('Fetching user data');
      // debugPrint(Provider.of<Authentication>(context, listen: false).getUserUid);
      initUserName = doc['user_name'];
      initUserEmail = doc['user_email'];
      initUserImage = doc['user_image'];

      debugPrint(initUserName);
      debugPrint(initUserEmail);
      debugPrint(initUserImage);

      notifyListeners();
    });
  }

  Future uploadPostData(String postId, dynamic data) async {
    return FirebaseFirestore.instance.collection('posts').doc(postId).set(data);
  }

  Future deleteUserData(String userUid, String collection) async {
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(userUid)
        .delete();
  }

  Future addAward(String postId, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('awards')
        .add(data);
  }

  Future updateCaption(String postId, dynamic data) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update(data);
  }

  Future followUser(
      String followingUid,
      String followingDocId,
      dynamic followingData,
      String followerUid,
      String followerDocId,
      dynamic followerData) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(followingUid)
        .collection('followers')
        .doc(followingDocId)
        .set(followingData)
        .whenComplete(() async {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(followerUid)
          .collection('following')
          .doc(followerDocId)
          .set(followerData);
    });
  }

  Future submitChatroomData(
      String chatRoomName, dynamic chatRoomData) async{
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomName)
        .set(chatRoomData);
  }
  createSingleChatroom(String uid,dynamic data){
    return FirebaseFirestore.instance
        .collection('singlechats').doc(uid).set(data);
  }
}

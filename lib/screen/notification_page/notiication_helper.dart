
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../service/authentication.dart';
import '../../service/firebaseOperation.dart';

class NotificationHelper with ChangeNotifier {

  addNotification(BuildContext context, String userUid, String type){
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('notification')
        .doc().set({
      'time': DateTime.now(),
      'typeNotifier': type,
      'user_name':
      Provider.of<FirebaseOperation>(context, listen: false).getUserName,
      'user_image':
      Provider.of<FirebaseOperation>(context, listen: false).getUserImage,
      'user_uid': Provider.of<Authentication>(context, listen: false).getUserUid,
    }
    );
  }

  getNotifications(BuildContext context, String userUid){
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('notification').orderBy('time', descending: true).snapshots();
  }
}
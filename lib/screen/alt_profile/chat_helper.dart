
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../constant/firestore_constants.dart';
import '../../models/message_chat.dart';

class ChatHelper with ChangeNotifier {

  UploadTask uploadFile(File image, String fileName) {
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  void sendMessage(String content, int type, String currentUserId, String peerId) {
    createGroupId(currentUserId, peerId);
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('singlechats')
        .doc(groupChatId)
        .collection('messages')
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    MessageChat messageChat = MessageChat(
      idFrom: currentUserId,
      idTo: peerId,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: type,
    );

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        messageChat.toJson(),
      );
    });
  }


  Stream<QuerySnapshot> getChatStream(String chatId, int limit) {
    return FirebaseFirestore.instance
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(chatId)
        .collection('messages')
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .limit(limit)
        .snapshots();
  }

  createChat(String currentId, String peerId, dynamic data){
    createGroupId(currentId, peerId);
    FirebaseFirestore.instance
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId).set(data);
        //.collection(groupChatId).add(data);
  }
  isChatExist(String currentId, String peerId) async{
    createGroupId(currentId, peerId);
    bool isExist = await chatIdIsExist(groupChatId!);

    if(isExist){
      return true;
    }
    return false;
  }

  String? groupChatId;
  createGroupId(String currentId, String peerId){
    if (currentId.hashCode <= peerId.hashCode) {
      groupChatId = '$currentId-$peerId';
    } else {
      groupChatId = '$peerId-$currentId';
    }
    notifyListeners();
  }

  Future<bool> chatIdIsExist(String chatId) async{
    final snapShot = await FirebaseFirestore.instance
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(chatId).get();
    if(snapShot == null || !snapShot.exists){
      return false;
    }else return true;
  }

}


class TypeMessage {
  static const text = 0;
  static const image = 1;
  static const sticker = 2;
}
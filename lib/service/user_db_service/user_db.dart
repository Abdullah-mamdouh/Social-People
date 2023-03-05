


import 'package:cloud_firestore/cloud_firestore.dart';

class UserDB{

  getUsers(){
    return FirebaseFirestore.instance.collection('users').snapshots();
  }
}
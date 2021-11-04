

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication with  ChangeNotifier {

   //FirebaeAuth ? firebaeAuth = FirebaseAuth.instance ;
   FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn ? googleSignIn = GoogleSignIn();

  String ? userUid;

  String get getUserUid => userUid!;

  Future logIntoAccount(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth.
    signInWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;
    userUid = user!.uid;
    print(userUid! + '4444444444444444444444444444');
    notifyListeners();

  }

   Future createAccount(String email, String password) async {
     UserCredential userCredential = await _firebaseAuth.
     createUserWithEmailAndPassword(email: email, password: password);
     User ? user = userCredential.user;
     userUid = user!.uid;
     print('kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk');
     print(userUid);
     notifyListeners();

   }

   Future logOutViaEmail() {
    return _firebaseAuth.signOut();
   }

   Future signInWithGoogle()async {
    GoogleSignInAccount ? googleSignInAccount = await googleSignIn!.signIn();
    GoogleSignInAuthentication ? googleSignInAuthentication = await googleSignInAccount!.authentication;
    AuthCredential authCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken:  googleSignInAuthentication.idToken,
    );
    UserCredential userCredential = await _firebaseAuth.signInWithCredential(authCredential);
    User? user = userCredential.user;
    assert( user!.uid != null);
    userUid = user!.uid;
    print('Google User Uid => $userUid');
    notifyListeners();
   }
   Future signOutWithGoogle () async {
    return googleSignIn!.signOut();
   }
}
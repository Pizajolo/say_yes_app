import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:say_yes_app/pages/feed_page.dart';
import 'package:say_yes_app/pages/login_page.dart';

class AuthService{

  static final _auth = FirebaseAuth.instance;
  static final _firestore = Firestore.instance;

  static void signUpUser(BuildContext context, String name, String email, String password) async{
    try{
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser signedInUser = authResult.user;
      if (signedInUser != null){
        _firestore.collection('/users').document(signedInUser.uid).setData({
          'username': name,
          'email': email,
          'profileImageUrl': '',
        });
        Navigator.pushReplacementNamed(context, FeedPage.id);
      }
    } catch (e) {
      print(e);
    }
  }

  static void logout() {
    _auth.signOut();
  }

  static void login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e);
    }
  }
}
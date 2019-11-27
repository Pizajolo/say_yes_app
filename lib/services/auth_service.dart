import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:say_yes_app/models/user_data.dart';
import 'package:say_yes_app/models/user_model.dart';
import 'package:say_yes_app/pages/feed_page.dart';
import 'package:say_yes_app/pages/home_page.dart';
import 'package:say_yes_app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:say_yes_app/utilities/constants.dart';
import 'package:say_yes_app/utilities/globals.dart' as globals;

class AuthService{

  static final _auth = FirebaseAuth.instance;
  static final _firestore = Firestore.instance;

  static void signUpUser(BuildContext context, String username,String firstName, String surname, String email, String password, Map address, ) async{
    try{
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser signedInUser = authResult.user;
      if (signedInUser != null){
        _firestore.collection('/users').document(signedInUser.uid).setData({
          'username': username,
          'firstName': firstName,
          'surname': surname,
          'email': email,
          'bio': '',
          'profileImageUrl': '',
          'address': address,
          'phoneNumber': '',
          'authenticated': true,
          'participated': [],
          'organized': [],
          'yeses': 0,
          'yesCoins': 200,
        });
        Provider.of<UserData>(context).currentUserId = signedInUser.uid;
        usersRef.document(signedInUser.uid).get().then((doc) {
          User user = User.fromDoc(doc);
          globals.yesCoins = user.yesCoins;
          globals.authenticated = user.authenticated;
          globals.yeses = user.yeses;
        });
        Navigator.pop(context);
//        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePage(userId: signedInUser.uid)));
      }
    } catch (e) {
      print(e);
    }
  }

  static void logout(BuildContext context) {
    _auth.signOut();
//    Navigator.pushReplacementNamed(context, LoginPage.id);
  }

  static void login(BuildContext context, String email, String password) async {
    try {
      AuthResult authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser signedInUser = authResult.user;
      Provider.of<UserData>(context).currentUserId = signedInUser.uid;
      usersRef.document(signedInUser.uid).get().then((doc){
        User user = User.fromDoc(doc);
        globals.yesCoins = user.yesCoins;
        globals.authenticated = user.authenticated;
        globals.yeses = user.yeses;
      });
//      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePage(userId: signedInUser.uid)));
    } catch (e) {
      print(e);
    }
  }
}
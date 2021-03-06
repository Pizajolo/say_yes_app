import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:say_yes_app/models/user_data.dart';
import 'package:say_yes_app/models/user_model.dart';
import 'package:say_yes_app/pages/feed_page.dart';
import 'package:say_yes_app/pages/home_page.dart';
import 'package:say_yes_app/pages/signup_page.dart';
import 'package:say_yes_app/pages/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  Widget _getScreenId() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          Provider.of<UserData>(context).currentUserId = snapshot.data.uid;
          return HomePage();
        } else {
          return LoginPage();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => UserData(),
      child: MaterialApp(
        title: 'Say YES App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryIconTheme: Theme.of(context).primaryIconTheme.copyWith(
                  color: Colors.black,
                )),
        home: _getScreenId(),
        routes: {
          LoginPage.id: (context) => LoginPage(),
          SignupPage.id: (context) => SignupPage(),
          FeedPage.id: (context) => FeedPage(),
        },
      ),
    );
  }
}

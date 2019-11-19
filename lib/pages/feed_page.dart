import 'package:flutter/material.dart';
import 'package:say_yes_app/services/auth_service.dart';

class FeedPage extends StatefulWidget {
  static final String id = 'feed_page';
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: FlatButton(
          onPressed: () => AuthService.logout(context),
          child: Text('LOGOUT'),
        ),
      ),
    );
  }
}

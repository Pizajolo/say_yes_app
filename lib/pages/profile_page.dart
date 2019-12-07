import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:say_yes_app/models/event_model.dart';
import 'package:say_yes_app/models/user_data.dart';
import 'package:say_yes_app/pages/chat_page.dart';
import 'package:say_yes_app/pages/edit_profile_page.dart';
import 'package:say_yes_app/services/database_service.dart';
import 'package:say_yes_app/utilities/constants.dart';
import 'package:say_yes_app/models/user_model.dart';
import 'package:say_yes_app/utilities/globals.dart' as globals;
import 'package:uuid/uuid.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  ProfilePage({this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _yeses;
  int _yesCoins;
  List<Event> _events = [];
  User _user;

  @override
  void initState() {
    _yesCoins = globals.yesCoins;
    _yeses = globals.yeses;
    _getUserEvents();
    super.initState();
  }

//  _update(){
//    if (this.mounted) {
//      setState(() {});
//    }
//  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.userId == Provider.of<UserData>(context).currentUserId
          ? AppBar(
              backgroundColor: Colors.white,
              title: Text(
                'Say YES',
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0),
              ),
              leading: Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 12.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      _yesCoins == null ? '0' : _yesCoins.toString(),
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      'YC',
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        _yeses == null ? '0' : _yeses.toString(),
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        'YESes',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : AppBar(
              backgroundColor: Colors.white,
              title: Text(
                'Say YES',
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: new IconButton(
                    icon: new Icon(Icons.message),
                    onPressed: () => _creatNewChat(),
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: usersRef.document(widget.userId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          User user = User.fromDoc(snapshot.data);
          _user = user;
          globals.yesCoins = user.yesCoins;
          globals.authenticated = user.authenticated;
          globals.yeses = user.yeses;
          return Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: user.profileImageUrl.isEmpty
                          ? AssetImage('assets/images/default_avatar.png')
                          : CachedNetworkImageProvider(user.profileImageUrl),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    user.participated.length.toString(),
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'participated',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    user.organized.length.toString(),
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'organized',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    user.yeses.toString(),
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'YESes',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          widget.userId ==
                                  Provider.of<UserData>(context).currentUserId
                              ? Container(
                                  width: 200.0,
                                  child: FlatButton(
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => EditProfilePage(
                                                  user: user,
                                                ))),
                                    color: Colors.blueAccent,
                                    textColor: Colors.white,
                                    child: Text(
                                      'Edit Profile',
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user.username,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      height: 40.0,
                      child: Text(
                        user.bio,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
              _events.length != 0
                  ? Container(
                      height: 500.0,
                      child: ListView(children: _createFeed()),
                    )
                  : SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }

  _getUserEvents() async {
    DocumentSnapshot userSnap = await usersRef.document(widget.userId).get();
    User user = User.fromDoc(userSnap);
    int len = user.organized.length + user.participated.length;
    List<Event> events = new List(len);
    for (int i = 0; i < user.participated.length; i++) {
      await eventRef.document(user.participated[i]).get().then((doc) {
        Event event = Event.fromDoc(doc);
        events[i] = event;
      });
    }
    for (int i = 0; i < user.organized.length; i++) {
      await eventRef.document(user.organized[i]).get().then((doc) {
        Event event = Event.fromDoc(doc);
        events[i + user.participated.length] = event;
      });
    }
    setState(() {
      _events.addAll(events);
    });
  }

  List<Widget> _createFeed() {
    List<Widget> feed = [SizedBox.shrink()];
    _events.sort((b, a) => a.date.compareTo(b.date));
    for (Event event in _events) {
      int value;
      var color;
      if (event.hostId == widget.userId) {
        value = event.price * (event.guests.length - 1);
        color = Colors.blueAccent;
      } else {
        value = event.price;
        color = Colors.lightBlueAccent;
      }
      feed.add(
        Container(
          height: 150,
          color: color,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          event.eventName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              event.type,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.black54),
                            ),
                            SizedBox(
                              width: 30.0,
                            ),
                            Text(
                              event.date.toString().substring(0, 16),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          value.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                              color: Colors.black54),
                        ),
                        Text(
                          'YESes',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                              color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 68.0,
                          width: MediaQuery.of(context).size.width - 20,
                          child: Text(
                            event.description,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: 5.0,
                color: Colors.white,
              ),
            ],
          ),
        ),
      );
    }
    return feed;
  }

  _creatNewChat() async{
    var doc = await usersRef.document(Provider.of<UserData>(context).currentUserId).get();
    User user = User.fromDoc(doc);
    Map writer = {
      'username': user.username,
      'id': Provider.of<UserData>(context).currentUserId
    };
    List<Map> receiver = [{
      'username': _user.username,
      'id': widget.userId
    }];
    usersRef
        .document(Provider.of<UserData>(context).currentUserId)
        .collection('chats')
        .where('users', isEqualTo: receiver)
        .getDocuments()
        .then((docs) {
      if (docs.documents.isEmpty) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                    chatId: Uuid().v4(),
                    receivers: receiver,
                    writer: writer)));
      } else {
        var doc = docs.documents[0];
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                    chatId: doc['chatId'],
                    writer: writer,
                    receivers: doc['users'])));
      }
    });
  }
}

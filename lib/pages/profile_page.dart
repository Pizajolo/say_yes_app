import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:say_yes_app/models/user_data.dart';
import 'package:say_yes_app/pages/edit_profile_page.dart';
import 'package:say_yes_app/utilities/constants.dart';
import 'package:say_yes_app/models/user_model.dart';
import 'package:say_yes_app/utilities/globals.dart' as globals;


class ProfilePage extends StatefulWidget {
  final String userId;

  ProfilePage({this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {
  int _yeses;
  int _yesCoins;

  @override
  void initState() {
    _yesCoins = globals.yesCoins;
    _yeses = globals.yeses;
    super.initState();
  }

//  _update(){
//    if (this.mounted) {
//      setState(() {});
//    }
//  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.userId == Provider.of<UserData>(context).currentUserId? AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Say YES',
            style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 30.0),
          ),
        leading: Padding(
          padding: const EdgeInsets.only(left:12.0, top: 12.0),
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
                style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold, fontSize: 12.0),
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
                  style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold, fontSize: 12.0),
                ),
              ],
            ),
          ),
        ],
      ) : AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Say YES',
          style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
              fontSize: 30.0),
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: usersRef.document(widget.userId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }
          User user = User.fromDoc(snapshot.data);
          globals.yesCoins = user.yesCoins;
          globals.authenticated = user.authenticated;
          globals.yeses = user.yeses;
          return ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          user.profileImageUrl.isEmpty ? AssetImage('assets/images/default_avatar.png') : CachedNetworkImageProvider(user.profileImageUrl),
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
                          widget.userId == Provider.of<UserData>(context).currentUserId ?
                          Container(
                            width: 200.0,
                            child: FlatButton(
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfilePage(user: user,))),
                              color: Colors.blueAccent,
                              textColor: Colors.white,
                              child: Text(
                                'Edit Profile',
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                          ) : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
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
                      height: 80.0,
                      child: Text(
                        user.bio,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    Divider()
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

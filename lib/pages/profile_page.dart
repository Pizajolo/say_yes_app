import 'package:flutter/material.dart';
import 'package:say_yes_app/pages/edit_profile_page.dart';
import 'package:say_yes_app/utilities/constants.dart';
import 'package:say_yes_app/models/user_model.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  ProfilePage({this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: userRef.document(widget.userId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }
          User user = User.fromDoc(snapshot.data);
          print(user.username);
          print(user.email);
          print(user.bio);
          return ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50.0,
                      backgroundImage:
                          NetworkImage('https://i.redd.it/dmdqlcdpjlwz.jpg'),
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
                                    '12',
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
                                    '20',
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
                                    '10234',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'YES',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 1.0),
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

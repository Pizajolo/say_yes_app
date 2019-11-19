import 'package:flutter/material.dart';
import 'package:say_yes_app/models/user_model.dart';

class EditProfilePage extends StatefulWidget {
  final User user;

  EditProfilePage({this.user});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Edit Profile', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 60.0,
                  backgroundImage:
                      NetworkImage('https://i.redd.it/dmdqlcdpjlwz.jpg'),
                ),
                FlatButton(
                  onPressed: () => print('Change profile image'),
                  child: Text('Change Profile Image',
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 16.0)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

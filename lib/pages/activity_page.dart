import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:say_yes_app/models/activity_model.dart';
import 'package:say_yes_app/models/user_data.dart';
import 'package:say_yes_app/services/database_service.dart';
import 'package:say_yes_app/utilities/globals.dart' as globals;

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
                  globals.yesCoins == null ? '0' : globals.yesCoins.toString(),
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
                    globals.yeses == null ? '0' : globals.yeses.toString(),
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
        ),
        body: StreamBuilder(
          stream: DatabaseService.getActivities(
              Provider.of<UserData>(context).currentUserId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                padding: const EdgeInsets.all(5.0),
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.documents[index];
                  String title;
                  Color backgroundColor;
                  if (ds["type"] == "Created") {
                    title = "You created a new event:";
                    backgroundColor = Colors.blueAccent;
                  } else {
                    title = "Somebody joined your event:";
                    backgroundColor = Colors.lightBlueAccent;
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Container(
                      height: 100.0,
                      color: backgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(title, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical:8.0),
                              child: Text(ds["title"], style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                            ),
                            Text(ds['date'].toDate().toString().substring(0,16))
                          ],
                        ),
                      ),
                    ),
                  );
                });
          },
        ));
  }
}

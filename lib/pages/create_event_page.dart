import 'package:flutter/material.dart';
import 'package:say_yes_app/pages/add_event_page.dart';
import 'package:say_yes_app/utilities/globals.dart' as globals;

class CreateEventPage extends StatefulWidget {
  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
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
          padding: const EdgeInsets.only(left:12.0, top: 12.0),
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
                  globals.yeses == null ? '0' : globals.yeses.toString(),
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
        ),
      body: globals.authenticated == true ? authenticated(context) : info(context),
    );
  }

  Widget authenticated(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Create a new Event',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30.0,),
            IconButton(
              iconSize: 100.0,
              color: Colors.blueAccent,
              icon: Icon(Icons.add_circle_outline),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddEventPage())),
            )
          ],
        ),
      ],
    );
  }

  Widget info(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You can only create an event if you are authenticated',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }
}
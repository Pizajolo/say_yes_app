import 'package:flutter/material.dart';
import 'package:say_yes_app/pages/add_event_page.dart';

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
        actions: <Widget>[
          IconButton(
            color: Colors.blueAccent,
            icon: Icon(Icons.add),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddEventPage())),
          )
        ],),
      body: Center(
        child: Text(
          'Create a new Event',
        ),
      ),
    );
  }
}
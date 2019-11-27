import 'package:flutter/material.dart';
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
      body: Center(
        child: Text(
          'Activity Page',
        ),
      ),
    );
  }
}

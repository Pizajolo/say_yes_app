import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:say_yes_app/models/event_model.dart';
import 'package:say_yes_app/models/user_model.dart';
import 'package:say_yes_app/services/database_service.dart';
import 'package:say_yes_app/services/storage_service.dart';
import 'package:say_yes_app/models/user_data.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';

class EventPage extends StatefulWidget {
  final Event event;

  EventPage({this.event});

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  _submit() async {
    if (!_isLoading) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Event', style: TextStyle(color: Colors.black)),
      ),
      body: ListView(
        children: <Widget>[
          _isLoading
              ? LinearProgressIndicator(
                  backgroundColor: Colors.black,
                  valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
                )
              : SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                Text(
                  widget.event.eventName,
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 25.0,),
                Text(
                  widget.event.type,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 25.0,),
                Text(
                  widget.event.description,
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Address:',
                        style: TextStyle(fontSize: 20.0),
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 200.0,
                            child: Text(
                              widget.event.address['street'],
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.black),
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Container(
                            width: 130.0,
                            child: Text(
                              widget.event.address['houseNumber'],
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 200.0,
                            child: Text(
                              widget.event.address['postcode'],
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.black),
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Container(
                            width: 130.0,
                            child: Text(
                              widget.event.address['city'],
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.event.address['country'],
                            style: TextStyle(fontSize: 18.0, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  widget.event.date.toLocal().toString(),
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                ),
                SizedBox(height:25.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 120.0,
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Total invites:',
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.black),
                          ),
                          Text(
                            widget.event.guestNumber.toString(),
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 100.0,
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Invites left:',
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.black),
                          ),
                          Text(
                            (widget.event.guestNumber -
                                    widget.event.guests.length +
                                    1)
                                .toString(),
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 100.0,
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Price:',
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.black),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                widget.event.price.toString(),
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.black),
                              ),
                              Text(
                                ' YC',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 40.0),
                    height: 40.0,
                    width: 330.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: 150.0,
                          child: FlatButton(
                            onPressed: _submit,
                            color: Colors.blueAccent,
                            textColor: Colors.white,
                            child: Text(
                              'Close',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 150.0,
                          child: FlatButton(
                            onPressed: _submit,
                            color: Colors.blueAccent,
                            textColor: Colors.white,
                            child: Text(
                              'Join Event',
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
        ],
      ),
    );
  }
}

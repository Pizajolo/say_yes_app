import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:say_yes_app/models/user_model.dart';
import 'package:say_yes_app/services/database_service.dart';
import 'package:say_yes_app/services/storage_service.dart';
import 'package:say_yes_app/models/user_data.dart';
import 'package:uuid/uuid.dart';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  String _eventName;
  String _description;
  String _type;
  String _hostId;
  Map _address;
  String _houseNumber;
  String _street;
  String _postcode;
  String _city;
  String _country;
  GeoPoint _location;
  DateTime _date;
  List _guests;
  int _guestNumber;
  bool _active;
  int _price;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  _submit() async {
    if (_formKey.currentState.validate() && !_isLoading) {
      _formKey.currentState.save();

      setState(() {
        _isLoading = true;
      });
      _hostId = Provider.of<UserData>(context).currentUserId;
      _guests = [Provider.of<UserData>(context).currentUserId];
      String _eventId = Uuid().v4();

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Create Event', style: TextStyle(color: Colors.black)),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          children: <Widget>[
            _isLoading
                ? LinearProgressIndicator(
                    backgroundColor: Colors.black,
                    valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
                  )
                : SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _eventName,
                      style: TextStyle(fontSize: 18.0),
                      decoration: InputDecoration(
                        labelText: 'Event Name',
                      ),
                      validator: (input) => input.trim().length < 1
                          ? 'Please enter a valid event name'
                          : null,
                      onSaved: (input) => _eventName = input,
                    ),
                    TextFormField(
                      initialValue: _description,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      style: TextStyle(fontSize: 18.0),
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      validator: (input) => input.trim().length < 50
                          ? 'Please enter more than 50 characters'
                          : null,
                      onSaved: (input) => _description = input,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Address:',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: 200.0,
                                child: TextFormField(
                                  initialValue: _street,
                                  style: TextStyle(fontSize: 18.0),
                                  decoration: InputDecoration(
                                    labelText: 'Street',
                                  ),
                                  validator: (input) => input.trim().length < 5
                                      ? 'Please enter a valid street name'
                                      : null,
                                  onSaved: (input) => _street = input,
                                ),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Container(
                                width: 130.0,
                                child: TextFormField(
                                  initialValue: _houseNumber,
                                  style: TextStyle(fontSize: 18.0),
                                  decoration: InputDecoration(
                                    labelText: 'House Number',
                                  ),
                                  validator: (input) => input.trim().length < 1
                                      ? 'Please enter a valid house number'
                                      : null,
                                  onSaved: (input) => _houseNumber = input,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: 200.0,
                                child: TextFormField(
                                  initialValue: _postcode,
                                  style: TextStyle(fontSize: 18.0),
                                  decoration: InputDecoration(
                                    labelText: 'Post Code',
                                  ),
                                  validator: (input) => input.trim().length < 5
                                      ? 'Please enter a valid post code'
                                      : null,
                                  onSaved: (input) => _postcode = input,
                                ),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Container(
                                width: 130.0,
                                child: TextFormField(
                                  initialValue: _city,
                                  style: TextStyle(fontSize: 18.0),
                                  decoration: InputDecoration(
                                    labelText: 'City',
                                  ),
                                  validator: (input) => input.trim().length < 3
                                      ? 'Please enter a valid city name'
                                      : null,
                                  onSaved: (input) => _city = input,
                                ),
                              ),
                            ],
                          ),
                          TextFormField(
                            initialValue: _country,
                            style: TextStyle(fontSize: 18.0),
                            decoration: InputDecoration(
                              labelText: 'Country',
                            ),
                            validator: (input) => input.trim().length < 1
                                ? 'Please enter a valid country name'
                                : null,
                            onSaved: (input) => _country = input,
                          ),
                        ],
                      ),
                    ),
                    DateTimeField(
                      style: TextStyle(fontSize: 18.0),
                      decoration: InputDecoration(
                        labelText: 'Date and Time',
                      ),
                      format: DateFormat("yyyy-MM-dd HH:mm"),
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue ?? DateTime.now()),
                          );
                          return DateTimeField.combine(date, time);
                        } else {
                          return currentValue;
                        }
                      },
                      onSaved: (input) => _date,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 150.0,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 18.0),
                            decoration: InputDecoration(
                              labelText: 'Number of invites',
                            ),
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            validator: (input) => input.trim().length < 1
                                ? 'Please enter a valid number'
                                : null,
                            onSaved: (input) =>
                                _guestNumber = num.tryParse(input),
                          ),
                        ),
                        Container(
                          width: 150.0,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 18.0),
                            decoration: InputDecoration(
                              labelText: 'Price',
                            ),
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            validator: (input) => input.trim().length < 1
                                ? 'Please enter a valid price'
                                : null,
                            onSaved: (input) =>
                            _guestNumber = num.tryParse(input),
                          ),
                        ),
                      ],
                    ),
                    Container(
                        margin: EdgeInsets.all(40.0),
                        height: 40.0,
                        width: 250.0,
                        child: FlatButton(
                          onPressed: _submit,
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          child: Text(
                            'Create Event',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

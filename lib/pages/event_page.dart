import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:say_yes_app/models/activity_model.dart';
import 'package:say_yes_app/models/event_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:say_yes_app/models/user_data.dart';
import 'package:say_yes_app/models/user_model.dart';
import 'package:say_yes_app/pages/create_event_page.dart';
import 'package:say_yes_app/pages/home_page.dart';
import 'package:say_yes_app/services/database_service.dart';
import 'package:say_yes_app/utilities/constants.dart';
import 'package:uuid/uuid.dart';

class EventPage extends StatefulWidget {
  final Event event;
  final bool join;

  EventPage({this.event, this.join});

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  bool _isLoading = false;
  Marker _marker;

  @override
  void initState() {
    _createMarker();
    super.initState();
  }

  _submit() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      usersRef
          .document(Provider.of<UserData>(context).currentUserId)
          .get()
          .then((userSnap) {
        User user = User.fromDoc(userSnap);
        var participated = new List<String>.from(user.participated);
        participated.add(widget.event.id);
        var guests = new List<String>.from(widget.event.guests);
        guests.add(Provider.of<UserData>(context).currentUserId);
        DatabaseService.updateEvent(widget.event.id, guests,
            Provider.of<UserData>(context).currentUserId, participated);
      });
      Activity activityHost = new Activity(
        id: Uuid().v4(),
        date: DateTime.now(),
        type: "Joined",
        title: widget.event.eventName,
        eventId: widget.event.id,
      );
      DatabaseService.createActivity(activityHost, widget.event.hostId);

      Activity activityPart = new Activity(
        id: Uuid().v4(),
        date: DateTime.now(),
        type: "I joined",
        title: widget.event.eventName,
        eventId: widget.event.id,
      );
      DatabaseService.createActivity(activityPart, Provider.of<UserData>(context).currentUserId);

      Navigator.pop(context);
    }
  }

  _createEvent() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      usersRef
          .document(Provider.of<UserData>(context).currentUserId)
          .get()
          .then((userSnap) {
        User user = User.fromDoc(userSnap);
        var organized = new List<String>.from(user.organized);
        organized.add(widget.event.id);
        DatabaseService.createEvent(widget.event, organized);
        Navigator.pop(context);
      });
      Activity activityHost = new Activity(
        id: Uuid().v4(),
        date: DateTime.now(),
        type: "Created",
        title: widget.event.eventName,
        eventId: widget.event.id,
      );
      DatabaseService.createActivity(activityHost, widget.event.hostId);
      Navigator.pop(context);
    }
  }

  _close() async {
    if (!_isLoading) {
      Navigator.pop(context);
    }
  }

  _createMarker() async {
    LatLng latLngMarker =
        LatLng(widget.event.location.latitude, widget.event.location.longitude);
    Marker marker = Marker(
      markerId: MarkerId(widget.event.id),
      position: latLngMarker,
    );
    setState(() {
      _marker = marker;
    });
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
                SizedBox(
                  height: 25.0,
                ),
                Text(
                  widget.event.type,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 25.0,
                ),
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
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: SizedBox(
                    height: 200.0,
                    width: 350.0,
                    child: _GoogleMap(context),
                  ),
                ),
                Text(
                  widget.event.date.toLocal().toString(),
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                ),
                SizedBox(height: 25.0),
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
                          onPressed: _close,
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          child: Text(
                            'Close',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ),
                      widget.join == false
                          ? _createButton(context)
                          : widget.event.guests.length ==
                                  widget.event.guestNumber + 1
                              ? Container()
                              : _joinButton(context),
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

  Widget _joinButton(BuildContext context) {
    if (widget.event.guests
        .contains(Provider.of<UserData>(context).currentUserId)) {
      return SizedBox.shrink();
    }
    return SizedBox(
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
    );
  }

  Widget _createButton(BuildContext context) {
    return SizedBox(
      width: 150.0,
      child: FlatButton(
        onPressed: _createEvent,
        color: Colors.blueAccent,
        textColor: Colors.white,
        child: Text(
          'Create Event',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }

  Widget _GoogleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 233,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        compassEnabled: false,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
            target: LatLng(widget.event.location.latitude,
                widget.event.location.longitude),
            zoom: 16),
        markers: Set.from(
          {_marker},
        ),
      ),
    );
  }
}

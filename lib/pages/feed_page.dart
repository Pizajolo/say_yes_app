import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:say_yes_app/models/event_model.dart';
import 'package:say_yes_app/pages/event_page.dart';
import 'package:say_yes_app/services/auth_service.dart';
import 'package:say_yes_app/services/database_service.dart';
import 'package:say_yes_app/utilities/constants.dart';

class FeedPage extends StatefulWidget {
  static final String id = 'feed_page';

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  Completer<GoogleMapController> _controller = Completer();
  Future<QuerySnapshot> _events;
  Iterable markers = [];
  double _zoomValue = 12.0;
  double _long;
  double _lat;

  @override
  void initState(){
    _getCurrentLocation();
    _events = DatabaseService.getEvents();
    _events.then((list) {
      Iterable _markers = Iterable.generate(list.documents.length, (index) {
        Event result = Event.fromDoc(list.documents[index]);
        LatLng latLngMarker = LatLng(
            result.location.latitude, result.location.longitude);
        return Marker(
          onTap: (){
            _openEvent(result.id);
          },
          markerId: MarkerId(result.id),
          position: latLngMarker,
          infoWindow: InfoWindow(title: result.eventName),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue,
          ),
        );
      });
      setState(() {
        markers = _markers;
      });
    });
    super.initState();
  }

  _openEvent(eventId) {
    eventRef.document(eventId).get().then((event){
      if(event.data != null){
        Event ev = Event.fromDoc(event);
        Navigator.push(context, MaterialPageRoute(builder: (_) => EventPage(event: ev,)));
      }
    });
  }

  void _getCurrentLocation() async {
    GeolocationStatus geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus();
    if(geolocationStatus.toString() == 'granted'){
      Position res = await Geolocator().getCurrentPosition();
      setState(() {
        _lat = res.latitude;
        _long = res.longitude;
        _gotoHome();
      });
    }
    else{
      _lat = 50.785549;
      _long = 6.078375;
      _gotoHome();
    }
  }

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
              icon: Icon(Icons.lock),
              onPressed: () => AuthService.logout(context),
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            _GoogleMap(context),
            _BuildContainer(context),
            _zoomMinusFunction(),
            _zoomPlusFunction(),
          ],
        ));
  }

  Widget _BuildContainer(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 150.0,
        child: _events == null
            ? Center(
          child: Text('Loading events'),
        )
            : FutureBuilder(
            future: _events,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data.documents.length == 0) {
                return Center(
                  child: Text('No events found!'),
                );
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  Event event = Event.fromDoc(snapshot.data.documents[index]);
                  return _boxes(event);
                },
              );
            })

      ),
    );
  }


  Widget _boxes(Event event) {
    double lat = event.location.latitude;
    double long = event.location.longitude;
    String eventName = event.eventName;
    int price = event.price;
    String type = event.type;
//    DateTime date = event.date;
    return GestureDetector(
      onTap: () {
        _gotoLocation(lat, long);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Container(
            width: 200.0,
            height: 150.0,
            child: new FittedBox(
                child: Material(
                    color: Colors.white,
                    elevation: 14.0,
                    borderRadius: BorderRadius.circular(24.0),
                    shadowColor: Colors.transparent,
                    child: Container(
                        width: 200.0,
                        height: 150.0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                  child: Text(
                                eventName,
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              )),
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                  child: Text(
                                type,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                ),
                              )),
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    price.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  Text(
                                    'YC',
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                            ],
                          ),
                        ))))),
      ),
    );
  }

  Widget _GoogleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          compassEnabled: false,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
              target: LatLng(34.052235, -118.243683), zoom: _zoomValue),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: Set.from(
            markers,
          ),),
    );
  }


  Future<void> _gotoHome() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(_lat, _long),
      zoom: _zoomValue,
    )));
  }

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    _zoomValue = 15.0;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(lat, long),
        zoom: _zoomValue,
        tilt: 50.0,
        bearing: 45.0)));
  }

  Widget _zoomMinusFunction() {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
          iconSize: 40.0,
          icon: Icon(
            Icons.zoom_out,
            color: Colors.blueAccent,
          ),
          onPressed: () {
            _zoomValue--;
            _zoom();
          }),
    );
  }

  Widget _zoomPlusFunction() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
          iconSize: 40.0,
          icon: Icon(
            Icons.zoom_in,
            color: Colors.blueAccent,
          ),
          onPressed: () {
            _zoomValue++;
            _zoom();
          }),
    );
  }

  Future<void> _zoom() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(_lat, _long), zoom: _zoomValue)));
  }
}

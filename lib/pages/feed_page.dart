import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:say_yes_app/services/auth_service.dart';

class FeedPage extends StatefulWidget {
  static final String id = 'feed_page';

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  Completer<GoogleMapController> _controller = Completer();
  double _zoomValue = 12.0;
  double _long;
  double _lat;

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
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
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            SizedBox(
              width: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(50.782, 6.07, "Hiton", 200, "Party"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  50.785549, 6.078375, "Big Party to alll", 200, "Party"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  51.782549, 6.076375, "Best Meetup ever", 200, "Meetup"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _boxes(
      double lat, double long, String eventName, int price, String type) {
    return GestureDetector(
      onTap: () {
        _gotoLocation(lat, long);
      },
      child: Container(
          child: new FittedBox(
              child: Material(
                  color: Colors.white,
                  elevation: 14.0,
                  borderRadius: BorderRadius.circular(24.0),
                  shadowColor: Colors.transparent,
                  child: Container(
                      width: 150.0,
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
          markers: {aachenMarker}),
    );
  }

  Marker aachenMarker = Marker(
    markerId: MarkerId('aachen1'),
    position: LatLng(50.782, 6.076),
    infoWindow: InfoWindow(title: 'Hilton'),
    icon: BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueBlue,
    ),
  );

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

import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String eventName;
  final String description;
  final String type;
  final String hostId;
  final Map address;
  final GeoPoint location;
  final DateTime date;
  final List guests;
  final int guestNumber;
  final bool active;
  final int price;


  Event({this.id, this.eventName, this.description,this.type, this.hostId, this.address, this.location, this.date, this.guests, this.guestNumber, this.active, this.price});

  factory Event.fromDoc(DocumentSnapshot doc){
    return Event(
      id: doc.documentID,
      eventName: doc['eventName'],
      description: doc['description'],
      type: doc['type'],
      hostId: doc['hostId'],
      address: doc['address'],
      location: doc['location'],
      date: doc['date'].toDate(),
      guests: doc['guests'] ?? [doc.documentID],
      guestNumber: doc['guestNumber'],
      active: doc['active'],
      price: doc['price'],
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String id;
  final String eventId;
  final String title;
  final String type;
  final DateTime date;


  Activity({this.id, this.eventId, this.title, this.type, this.date});

  factory Activity.fromDoc(DocumentSnapshot doc){
    return Activity(
      id: doc.documentID,
      eventId: doc['eventId'],
      title: doc['title'],
      type: doc['type'],
      date: doc['date'],
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:say_yes_app/models/event_model.dart';
import 'package:say_yes_app/utilities/constants.dart';
import 'package:say_yes_app/models/user_model.dart';

//com.example.sayYesApp

class DatabaseService{

  static void updateUser(User user) {
    usersRef.document(user.id).updateData({
      'username': user.username,
      'profileImageUrl': user.profileImageUrl,
      'bio': user.bio,
    });
  }

  static Future<QuerySnapshot> searchUser(String name) {
    Future<QuerySnapshot> users = usersRef.where('username', isGreaterThanOrEqualTo: name).getDocuments();
    return users;
  }

  static Future<QuerySnapshot> getEvents(String city) async {
    Future<QuerySnapshot> events = eventRef.where('address.city', isEqualTo: city).where('active', isEqualTo: true).getDocuments();
    return events;
  }

  static Future<DocumentSnapshot> getEvent(String id) async {
    Future<DocumentSnapshot> event = eventRef.document(id).get();
    return event;
  }

  static void updateEvent(String eventId, List guests, String userId, List participated) {
    usersRef.document(userId).updateData({
      'participated': participated,
    });
    eventRef.document(eventId).updateData({
      'guests': guests,
    });
  }

  static void createEvent(Event event, List organized) {
    usersRef.document(event.hostId).updateData({
      'organized': organized,
    });
    eventRef.document(event.id).setData({
      'eventName': event.eventName,
      'description': event.description,
      'type': event.type,
      'hostId': event.hostId,
      'address': event.address,
      'location': event.location,
      'date': event.date,
      'guests': event.guests,
      'guestNumber': event.guestNumber,
      'active': event.active,
      'price': event.price,
    });
  }
}
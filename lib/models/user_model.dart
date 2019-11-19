import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String profileImageUrl;
  final String email;
  final String bio;

  User({this.id, this.username, this.profileImageUrl, this.email, this.bio});

  factory User.fromDoc(DocumentSnapshot doc){
    return User(
      id: doc.documentID,
      username: doc['username'],
      profileImageUrl: doc['profileImageUrl'],
      email: doc['email'],
      bio: doc['bio'] ?? '',
    );
  }
}

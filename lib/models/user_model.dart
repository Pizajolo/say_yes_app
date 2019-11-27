import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String firstName;
  final String surname;
  final String profileImageUrl;
  final String email;
  final String bio;
  final Map address;
  final String phoneNumber;
  final bool authenticated;
  final List participated;
  final List organized;
  final int yeses;
  final int yesCoins;

  User({this.id, this.username, this.firstName, this.surname, this.profileImageUrl, this.email, this.bio, this.address, this.phoneNumber, this.authenticated, this.participated, this.organized, this.yeses, this.yesCoins});

  factory User.fromDoc(DocumentSnapshot doc){
    return User(
      id: doc.documentID,
      username: doc['username'],
      firstName: doc['firstName'],
      surname: doc['surname'],
      profileImageUrl: doc['profileImageUrl'],
      email: doc['email'],
      bio: doc['bio'] ?? '',
      address: doc['address'],
      phoneNumber: doc['phoneNumber'],
      authenticated: doc['authenticated'],
      participated: doc['participated'],
      organized: doc['organized'],
      yeses: doc['yeses'],
      yesCoins: doc['yesCoins'],
    );
  }
}

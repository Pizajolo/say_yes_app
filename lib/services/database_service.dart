import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:say_yes_app/utilities/constants.dart';
import 'package:say_yes_app/models/user_model.dart';

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
}
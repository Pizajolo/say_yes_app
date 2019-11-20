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
}
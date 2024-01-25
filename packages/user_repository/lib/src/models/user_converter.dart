// user_converter.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/src/models/user.dart';

class UserConverter {
  static MyUser fromFirebaseUser(User firebaseUser) {

    return MyUser(
      userId: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: '',
    );
  }
}
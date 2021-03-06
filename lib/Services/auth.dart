import 'package:aim/Services/database.dart';
import 'package:aim/model/community.dart';
import 'package:aim/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';

class AuthServices {
  final _auth = FirebaseAuth.instance;

  User _fromFirebaseUser(FirebaseUser user) {
    return user != null ? User(id: user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_fromFirebaseUser);
  }

  Future userEmailSignIn({String email, String password, String token}) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      await DataBaseServices(uid: user.uid).userUpdateToken(token);
      return _fromFirebaseUser(user);
    } catch (e) {
      return null;
    }
  }

  Future userRegisterWithEmail(
      {String email, String password, String name, String token}) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      await DataBaseServices(uid: user.uid).userUpdateDatabase(
          email: email, password: password, name: name, token: token);

      return _fromFirebaseUser(user);
    } catch (e) {
      return null;
    }
  }

  Future communityEmailSignIn(
      {String email, String password, String token}) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      await DataBaseServices(uid: user.uid).communityUpdateToken(token);
      return _fromFirebaseUser(user);
    } catch (e) {
      return null;
    }
  }

  Future communityRegisterWithEmail(
      {String email,
      String password,
      String name,
      String city,
      String state,
      String address,
      String phonenumber,
      String token}) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      await DataBaseServices(uid: user.uid).communityUpdateDatabase(
          email: email,
          password: password,
          name: name,
          city: city,
          state: state,
          address: address,
          phonenumber: phonenumber,
          token: token);

      return _fromFirebaseUser(user);
    } catch (e) {
      return null;
    }
  }

  Future signOut() async {
    try {
      _auth.signOut();
    } catch (e) {
      print('Failed to logout');
    }
  }
}

import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_with_android/reponsive/storage_method.dart';
import '../model/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot documentSnapshot = await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List? file,
  }) async {
    var res = 'Some error occurred';
    try {
      if (email.isNotEmpty && password.isNotEmpty && bio.isNotEmpty && file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

        String photourl = await StorageMethod().uploadImagetoStorage('ProfilePics', file, false);

        final user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          followers: [],
          following: [],
          profileImage: photourl,
        );

        _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());

        res = 'Success';
      }
    } on FirebaseAuthException catch (err) {
      print(['error', err]);
      res = err.toString();
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    var res = 'Some error occurred';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential cred = await _auth.signInWithEmailAndPassword(email: email, password: password);

        res = 'Success';
      }
    } on FirebaseAuthException catch (err) {
      print(['error', err]);
      res = err.code.toString();
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

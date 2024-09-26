import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import './models/models.dart';
import './entities/entities.dart';
import './user_repo.dart';

class FirebaseUserRepo extends ChangeNotifier implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  final usersCollection = FirebaseFirestore.instance.collection('users');

  FirebaseUserRepo({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Future<MyUser> getUser() {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<void> setUserData(MyUser myuser) async {
    try {
      await usersCollection.doc(myuser.uid).set(myuser.toEntity().toDocument());
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<MyUser> signUp(
      {required MyUser myuser, required String password}) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: myuser.email, password: password);
      myuser.uid = user.user!.uid;

      // Store user details in Firestore
      await usersCollection.doc(myuser.uid).set(myuser.toEntity().toDocument());
      return myuser;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<void> updateUser(MyUser user) async {
    try {
      await usersCollection.doc(user.uid).update(user.toEntity().toDocument());

      // Store user details in Firestore
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Stream<MyUser> get user {
    return _firebaseAuth.authStateChanges().flatMap((firebaseUser) async* {
      if (firebaseUser == null) {
        yield MyUser.empty;
      } else {
        yield await usersCollection.doc(firebaseUser.uid).get().then((doc) {
          if (doc.exists) {
            return MyUser.fromEntity(MyUserEntity.fromDocument(doc.data()!));
          } else {
            return MyUser.empty;
          }
        });
      }
    });
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}

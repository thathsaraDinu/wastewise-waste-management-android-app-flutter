import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import './models/user.dart';
import './entities/user_entity.dart';
import './user_repo.dart';

class FirebaseUserRepo implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  final usersCollection = FirebaseFirestore.instance.collection('users');

  FirebaseUserRepo({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
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

      return myuser;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<void> updateUser(MyUser user) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

  @override
  // TODO: implement user
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

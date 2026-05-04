import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserCredential> register({required String email,required String password,required String name,required String username,}) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;

    if (user != null) {
      final userRef = _db.collection('users').doc(user.uid);

      await userRef.set({
        'email': email,
        'name': name,
        'username': username,
        'createdAt': Timestamp.now(),
      });

      await userRef.collection('journals').add({
        'title': 'Daily Journal',
        'cover': 'assets/images/red_cover.png',
        'type': 'daily',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    return credential;
  }

  Future<UserCredential> signIn({required String email,required String password,}) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}
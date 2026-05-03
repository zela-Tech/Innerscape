import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MoodService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> logMood({
    required String label,
    required String image,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final uid = user.uid;

    final now = DateTime.now();

    final dateKey = "${now.year}-${now.month}-${now.day}";

    await _db
        .collection('users')
        .doc(uid)
        .collection('moods')
        .add({
      'label': label,
      'image': image,
      'timestamp': FieldValue.serverTimestamp(),
      'dateKey': dateKey,
    });
  }
}
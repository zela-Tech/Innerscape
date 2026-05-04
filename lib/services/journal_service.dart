import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JournalService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  User _requireUser() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    return user;
  }

  Future<void> addMoodEntry({required String journalId,required String content,required String moodLabel,}) async {
    final user = _requireUser();
    final uid = user.uid;

    await _db
        .collection('users')
        .doc(uid)
        .collection('journals')
        .doc(journalId)
        .collection('entries')
        .add({
      'content': content,
      'moodLabel': moodLabel,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
  Future<void> addEntry({required String journalId,required String content,}) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final uid = user.uid;

    await _db
        .collection('users')
        .doc(uid)
        .collection('journals')
        .doc(journalId)
        .collection('entries')
        .add({
      'content': content,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _db
        .collection('users')
        .doc(uid)
        .collection('journals')
        .doc(journalId)
        .update({
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
  Future<List<Map<String, dynamic>>> getPages(String journalId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final uid = user.uid;

    final snapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('journals')
        .doc(journalId)
        .collection('entries')
        .orderBy('createdAt', descending: false)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<String> createJournal({required String title,required String cover,}) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final uid = user.uid;

    final docRef = await _db
        .collection('users')
        .doc(uid)
        .collection('journals')
        .add({
      'title': title,
      'cover': cover,
      'type': 'custom',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }
  Future<String> getOrCreateDailyJournal() async {
    final user = _requireUser();
    final uid = user.uid;

    final ref = _db
        .collection('users')
        .doc(uid)
        .collection('journals');

    final query = await ref
        .where('type', isEqualTo: 'daily')
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      return query.docs.first.id;
    }

    final newDoc = await ref.add({
      'title': 'Daily Journal',
      'cover': 'assets/images/red_cover.png',
      'type': 'daily',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return newDoc.id;
  }
}
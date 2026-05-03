import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JournalService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<String> createOrGetDailyJournal({required String moodLabel,required String moodImage,}) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final uid = user.uid;
    final now = DateTime.now();

    final dateKey = "${now.year}-${now.month}-${now.day}";

    final query = await _db
      .collection('users')
      .doc(uid)
      .collection('journals')
      .where('dateKey', isEqualTo: dateKey)
      .where('type', isEqualTo: 'daily')
      .limit(1)
      .get();

    if (query.docs.isNotEmpty) {
      return query.docs.first.id;
    }

    final docRef = await _db
        .collection('users')
        .doc(uid)
        .collection('journals')
        .add({
      'title': "Daily Journal",
      'type': "daily",
      'moodLabel': moodLabel,
      'moodImage': moodImage,
      'dateKey': dateKey,
      'createdAt': FieldValue.serverTimestamp(),
    });

    //create first entry page
    await docRef.collection('entries').add({
      'content': "",
      'pageNumber': 1,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }

  Future<void> addEntry({required String journalId,required int pageNumber,required String content,}) async {
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
      'pageNumber': pageNumber,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
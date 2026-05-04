import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JournalService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> savePage({required String journalId,required int pageNumber,required String content,}) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final uid = user.uid;

    final pageId = "page_$pageNumber";

    await _db
        .collection('users')
        .doc(uid)
        .collection('journals')
        .doc(journalId)
        .collection('entries')
        .doc(pageId)
        .set({
      'content': content,
      'pageNumber': pageNumber,
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
        .orderBy('pageNumber')
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
}
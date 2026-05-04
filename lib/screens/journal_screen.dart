import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './add_Journal_screen.dart';
import '../model/journal_model.dart';
import './daily_journal_screen.dart';
import './journal_editior_screen.dart';
import '../services/journal_service.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  Stream<List<Journal>> getJournals() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('journals')
      .orderBy('updatedAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => Journal.fromFirestore(doc.id, doc.data())).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Journal",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AddJournalScreen(),
                            ),
                          );

                          if (result != null) {
                            final journalService = JournalService();

                            final journalId = await journalService.createJournal(
                              title: result['title'],
                              cover: result['cover'],
                            );

                            if (!mounted) return;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => JournalEditorScreen(
                                  journalId: journalId,
                                  title: result['title'],
                                  cover: result['cover'],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey,
                      )
                    ],
                  )
                ],
              ),

              const SizedBox(height: 20),
              //recents
              SizedBox(
                height: 120,
                child: StreamBuilder<List<Journal>>(
                  stream: getJournals(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final journals = snapshot.data!;

                    final recent = journals.take(5).toList();

                    if (recent.isEmpty) {
                      return const Center(
                        child: Text(
                          "No recent journals yet",
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recent.length,
                      itemBuilder: (context, index) {
                        final journal = recent[index];

                        return GestureDetector(
                          onTap: () {
                            if (journal.isDaily) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DailyJournalScreen(
                                    journalId: journal.id,
                                    moodLabel: "Happy",
                                    moodImage: "assets/images/happy.png",
                                  ),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => JournalEditorScreen(
                                    journalId: journal.id,
                                    title: journal.title,
                                    cover: journal.cover,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: 90,
                            margin: const EdgeInsets.only(right: 12),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                              child: Image.asset(
                                journal.cover,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "All",
                  style: TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: StreamBuilder<List<Journal>>(
                  stream: getJournals(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final journals = snapshot.data!;

                    if (journals.isEmpty) {
                      return const Center(
                        child: Text("No journals yet"),
                      );
                    }

                    return ListView.builder(
                      itemCount: journals.length,
                      itemBuilder: (context, index) {
                        return _journalTile(journals[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _journalTile(Journal journal) {
    return GestureDetector(
      onTap: () {
        if (journal.isDaily) {
          //for daily journaal only
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DailyJournalScreen(
                journalId: journal.id,
                moodLabel: "Happy",
                moodImage: "assets/images/happy.png",
              ),
            ),
          );
        } else {
          //for all other journals
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => JournalEditorScreen(
                journalId: journal.id,
                title: journal.title,
                cover: journal.cover,
              ),
            ),
          );
        }
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 60,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(3, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                child: Image.asset(
                  journal.cover,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                journal.id,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),

            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
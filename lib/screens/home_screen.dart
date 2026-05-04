import 'package:flutter/material.dart';
import 'settings_screen.dart';
import '../services/mood_service.dart';
import './daily_journal_screen.dart';
import '../services/journal_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './journal_editior_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "☀️ Good morning, User";
    } else if (hour < 18) {
      return "☀️ Good afternoon, User";
    } else {
      return "🌘 Good evening, User";
    }
  }
  final List<Map<String, dynamic>> moods = const [
    {"image": "assets/images/angry.png", "label": "Angry", "color": Color.fromRGBO(235, 98, 218, 1)},
    {"image": "assets/images/happy.png", "label": "Happy", "color": Color.fromRGBO(58,203, 218, 1)},
    {"image": "assets/images/anxious.png", "label": "Anxious", "color": Color.fromRGBO(211, 169, 241, 1)},
    {"image": "assets/images/sad.png", "label": "Sad", "color": Color.fromRGBO(145, 207, 251, 1)},
    {"image": "assets/images/meh.png", "label": "Meh", "color": Color.fromRGBO(171, 144, 242, 1)},
    {"image": "assets/images/tired.png", "label": "Tired", "color": Color.fromRGBO(237, 126, 188
    , 1)},
  ];

  final MoodService _moodService = MoodService();
  final JournalService _journalService = JournalService();
  List<Map<String, dynamic>> journals = [];

  Future<void> loadJournals() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('journals')
        .orderBy('createdAt', descending: true)
        .get();

    setState(() {
      journals = snapshot.docs.map((e) {
        final data = e.data();
        return {...data,'id': e.id,};
      }).toList();
    });
  }
  @override
  void initState() {
    super.initState();
    loadJournals();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child:SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 10),

                //top Bar -- setings icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 24),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SettingsScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: const Icon(Icons.settings, size: 20),
                      ),
                    ),
                  ],
                ),

                //greeting  section
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text(
                        getGreeting(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "How are you feeling today?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: moods.map((m) {
                    return GestureDetector(
                      onTap: () async {
                        final label = m["label"] as String;
                        final image = m["image"] as String;

                        try {
                          final journalId = await _journalService.getOrCreateDailyJournal();

                          await _moodService.logMood(
                            label: label,
                            image: image,
                          );

                          await _journalService.addMoodEntry(
                            journalId: journalId,
                            content: "",
                            moodLabel: label,
                          );

                          if (!mounted) return;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DailyJournalScreen(
                                moodLabel: label,
                                moodImage: image,
                                journalId: journalId,
                              ),
                            ),
                          );
                        } catch (e, stack) {
                          debugPrint("FULL ERROR: $e");
                          debugPrint("STACK: $stack");

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error logging mood: $e")),
                          );
                        }
                      },
                      child: _moodCard(
                        m["image"] as String,
                        m["label"] as String,
                        m["color"] as Color,
                      ),
                    );
                  }).toList(),
                ),

                //ai analytics cta-card 
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(217, 246, 250, 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Take control of your mind,\none day at a time.",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "Check in. Breathe. Move forward",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                              ),
                              onPressed: () {},
                              icon: const Icon(Icons.auto_awesome, size: 16, color: Color.fromRGBO(185, 248, 255, 1),),
                              label: const Text(
                                "Help with AI",
                                style: TextStyle(color: Colors.white,  fontWeight :FontWeight.w600),
                              ),
                            )
                          ],
                        ),

                        // for floating emojis on ai card above
                        Positioned(
                          right: -5,
                          top: -20,
                          child: Transform.rotate(
                            angle: 3.0,
                            child: Image.asset(
                              "assets/images/meh.png",
                              width: 70,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 20,
                          bottom: -20,
                          child: Image.asset(
                            "assets/images/tired.png",
                            width: 60,
                          ),
                        ),
                        Positioned(
                          right: 70,
                          bottom: 30,
                          child: Image.asset(
                            "assets/images/sad.png",
                            width: 60,
                          ),
                        ),
                        Positioned(
                          right: 80,
                          bottom: 65,
                          child: Image.asset(
                            "assets/images/extra0.png",
                            width: 35,
                          ),
                        ),
                        Positioned(
                          left: 95,
                          bottom: 15,
                          child: Transform.rotate(
                            angle: 0.5,
                            child: Image.asset(
                              "assets/images/happy.png",
                              width: 55,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //journal section
                const SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Your Journal",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "See All",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
                //TODO: replace with most recent 2 journals
                const SizedBox(height: 14),
                Column(
                  children: journals.take(2).map((j) {
                    return GestureDetector(
                      onTap: () async {
                        final journalId = j['id']; // IMPORTANT FIX

                        if (journalId == null) return;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => JournalEditorScreen(
                              journalId: journalId,
                              title: j['title'] ?? 'Untitled',
                              cover: j['cover'] ?? 'assets/images/red_cover.png',
                            ),
                          ),
                        );
                      },
                      child: _journalCard(
                        title: j['title'] ?? 'Untitled',
                        subtitle: "Wellness",
                        colors: [
                          const Color(0xFF1F3602),
                          const Color(0xFFDADA5E),
                          const Color(0xFF7AA00B),
                          const Color(0xFF1D4F58),
                          const Color(0xFF50BFC6),
                        ],
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _moodCard(String imagePath, String label, Color color) {
    return Container(
      width: 110,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 42,
            height: 33,
            fit: BoxFit.contain,
          ),
          Text(label),
        ],
      ),
    );
  }

  Widget _journalCard({required String title,required String subtitle,required List<Color> colors,}) {
    return Container(
      height:90,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(20, 97, 112, 0.07),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          //journal cover
          Container(
            width: 100,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: SweepGradient(
                center: Alignment.center,
                startAngle: 0.0,
                endAngle: 3.14 * 2,
                colors: colors,
                stops:const [0.0, 0.5, 0.75, 0.88,1.0],
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16,),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
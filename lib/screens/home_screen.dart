import 'package:flutter/material.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 10),

              //top Bar
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
                    onTap: () {
                      // future: Firebase / state update
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
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(217, 246, 250, 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Take control of your mind,\none day at a time.",
                            style: TextStyle(
                              fontSize: 25,
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
                          const SizedBox(height: 12),
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
                    ],
                  ),
                ),
              ),
            ],
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
}
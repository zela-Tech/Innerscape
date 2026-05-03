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

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> moods = const [
      {"image": "assets/images/angry.png", "label": "Angry", "color": Color.fromRGBO(235, 98, 218, 1)},
      {"image": "assets/images/happy.png", "label": "Happy", "color": Color.fromRGBO(58,203, 218, 1)},
      {"image": "assets/images/anxious.png", "label": "Anxious", "color": Color.fromRGBO(211, 169, 241, 1)},
      {"image": "assets/images/sad.png", "label": "Sad", "color": Color.fromRGBO(145, 207, 251, 1)},
      {"image": "assets/images/meh.png", "label": "Meh", "color": Color.fromRGBO(171, 144, 242, 1)},
      {"image": "assets/images/tired.png", "label": "Tired", "color": Color.fromRGBO(237, 126, 188
      , 1)},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
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
              
              const SizedBox(height: 14),
              Expanded(
                child: ListView(
                  children: [
                    _journalCard(
                      title: "Daily Journal",
                      subtitle: "Wellness · Mar 27",
                      colors: [
                        Color(0xFF1F3602),
                        Color(0xFFDADA5E),
                        Color(0xFF7AA00B),
                        Color(0xFF1D4F58),
                        Color(0xFF50BFC6),

                      ],
                    ),
                    const SizedBox(height: 12),
                    _journalCard(
                      title: "Journal Name",
                      subtitle: "Wellness · Mar 27",
                      colors: [
                        Color(0xFFD2E7EC),
                        Color(0xFF85E1CC),
                        Color(0xFF6BC5C6),
                        Color(0xFF6BC5C6),
                        Color(0xFF055B58),
                      ],
                    ),
                  ],
                ),
              )
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

  Widget _journalCard({required String title,required String subtitle,required List<Color> colors,}) {
    return Container(
      height:100,
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
import 'package:flutter/material.dart';

class DailyJournalScreen extends StatelessWidget {
  final String moodLabel;
  final String moodImage;

  const DailyJournalScreen({
    super.key,
    required this.moodLabel,
    required this.moodImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daily Journal")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(moodImage, width: 80),
            const SizedBox(height: 10),
            Text("Mood: $moodLabel"),
          ],
        ),
      ),
    );
  }
}
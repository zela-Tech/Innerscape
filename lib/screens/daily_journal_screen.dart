import 'package:flutter/material.dart';
import '../services/journal_service.dart';

class DailyJournalScreen extends StatefulWidget {
  final String moodLabel;
  final String moodImage;
  final String journalId;

  const DailyJournalScreen({
    super.key,
    required this.moodLabel,
    required this.moodImage,
    required this.journalId,
  });

  @override
  State<DailyJournalScreen> createState() => _DailyJournalScreenState();
}

class _DailyJournalScreenState extends State<DailyJournalScreen> {
  final List<TextEditingController> _pages = [TextEditingController()];
  final JournalService _journalService = JournalService();


  int currentPage = 0;

  void _addPage() {
    setState(() {
      _pages.add(TextEditingController());
      currentPage = _pages.length - 1;
    });
  }

  Future<void> _saveCurrentPage() async {
    final content = _pages[currentPage].text;

    await _journalService.saveEntry(
      journalId: widget.journalId,
      pageNumber: currentPage + 1,
      content: content,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Saved")),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Journal"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(widget.moodImage, width: 40),
                const SizedBox(width: 10),
                Text(widget.moodLabel),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: TextField(
                controller: _pages[currentPage],
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: "Write your thoughts...",
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(height: 10),
            //TODO: later replace with auto-save
            ElevatedButton(
              onPressed: () {},
              child: const Text("Save Entry"),
            )
          ],
        ),
      ),
    );
  }
}
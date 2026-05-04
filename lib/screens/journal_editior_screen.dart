import 'package:flutter/material.dart';
import '../services/journal_service.dart';

class JournalEditorScreen extends StatefulWidget {
  final String journalId;
  final String title;
  final String cover;

  const JournalEditorScreen({
    super.key,
    required this.journalId,
    required this.title,
    required this.cover,
  });

  @override
  State<JournalEditorScreen> createState() => _JournalEditorScreenState();
}

class _JournalEditorScreenState extends State<JournalEditorScreen> {
  final List<TextEditingController> _pages = [TextEditingController()];
  final JournalService _journalService = JournalService();
  bool _isLoading = true;
  bool isBold = false;
  bool isBullet = false;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }
  Future<void> _loadEntries() async {
    try {
      final entries = await _journalService.getPages(widget.journalId);

      _pages.clear();

      if (entries.isEmpty) {
        _pages.add(TextEditingController());
      } else {
        for (var entry in entries) {
          _pages.add(
            TextEditingController(text: entry['content'] ?? ""),
          );
        }
      }
    } catch (e) {
      _pages.clear();
      _pages.add(TextEditingController());
    }

    setState(() {
      _isLoading = false;
    });
  }


  int currentPage = 0;

  void _addPage() {
    setState(() {
      _pages.add(TextEditingController());
      currentPage = _pages.length - 1;
    });
  }

  Future<void> _saveCurrentPage() async {
    final content = _pages[currentPage].text;

    try {
      await _journalService.addEntry(
        journalId: widget.journalId,
        content: content,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Saved successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),

      body: SafeArea(
        child: _isLoading ? const Center(child: CircularProgressIndicator()) : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            const SizedBox(height: 6),

            // header section -----------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 78,
                    height: 96,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/images/red_cover.png'),
                        fit: BoxFit.cover,
                      ),

                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                        topLeft: Radius.circular(0),
                        bottomLeft: Radius.circular(0),
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.6),
                          blurRadius: 10,
                          offset: const Offset(4, 6),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 18),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 16),

           
            //text box
            Expanded(
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _pages[currentPage],
                  maxLines: null,
                  expands: true,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Start writing your thoughts...",
                  ),
                ),
              ),
            ),

            //page counter 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 42,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final isActive = index == currentPage;

                    return GestureDetector(
                      onTap: () {
                        setState(() => currentPage = index);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 38,
                        decoration: BoxDecoration(
                          color: isActive
                              ? Colors.black
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(
                            color: isActive
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            //toolbar---------------------------------
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 14,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.camera_alt_outlined),
                      onPressed: () {
                        final controller = _pages[currentPage];
                        controller.text += "\n📷 [Image Placeholder]\n";
                      },
                    ),

                    IconButton(
                      icon: Icon(
                        Icons.format_list_bulleted,
                        color: isBullet ? Colors.black : Colors.grey[700],
                      ),
                      onPressed: () {
                        setState(() => isBullet = !isBullet);

                        final controller = _pages[currentPage];

                        if (isBullet) {
                          controller.text += "\n• ";
                        }
                      },
                    ),

                    IconButton(
                      icon: Icon(
                        Icons.format_bold,
                        color: isBold ? Colors.black : Colors.grey[700],
                      ),
                      onPressed: () {
                        setState(() => isBold = !isBold);
                      },
                    ),

                    GestureDetector(
                      onTap: _addPage,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 6),

            //TODO using save button change to auto save later
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveCurrentPage,
                  child: const Text("Save Page"),
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
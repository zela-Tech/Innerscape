import 'package:flutter/material.dart';

class AddJournalScreen extends StatelessWidget {
  const AddJournalScreen({super.key});

  final List<String> journalDesigns = const [
    "assets/images/green_cover.png",
    "assets/images/red_cover.png",
    "assets/images/teal_cover.png",
    "assets/images/orange_cover.png",
    "assets/images/pink_cover.png",
    "assets/images/blue_cover.png",
    "assets/images/purple_cover.png",
  ];

  BoxDecoration _bookDecoration() {
    return BoxDecoration(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(18),
        bottomRight:Radius.circular(18),
        topLeft: Radius.circular(0),
        bottomLeft: Radius.circular(0),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.25),
          blurRadius: 14,
          offset: const Offset(5, 8),
        ),
      ],
    );
  }

  Widget _buildCover(String asset) {
    return Container(
      decoration: _bookDecoration(),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
        child: Image.asset(
          asset,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildAddTile() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 12,
            offset: const Offset(4, 6),
          ),
        ],
      ),
      child: const Center(
        child: Icon(Icons.add, size: 28, color: Colors.black54),
      ),
    );
  }
  
  Future<String?> _showCreateDialog(BuildContext context) async {
    final TextEditingController controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("New Journal"),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "Enter journal name",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isEmpty) return;

                Navigator.pop(context, controller.text.trim());
              },
              child: const Text("Create"),
            ),
          ],
        );
      },
    );
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

              //nav
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                "Choose your next\nDesign",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: GridView.builder(
                  itemCount: journalDesigns.length + 1,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.78,
                  ),
                  itemBuilder: (context, index) {
                    if (index == journalDesigns.length) {
                      return _buildAddTile();
                    }

                    return GestureDetector(
                      onTap: () async {
                        final title = await _showCreateDialog(context);

                        if (title != null && title.isNotEmpty) {
                          Navigator.pop(context, {
                            "title": title,
                            "cover": journalDesigns[index],
                          });
                        }
                      },
                      child: _buildCover(journalDesigns[index]),
                    );
                  },
                ),
              ),

              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade300,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Journal Title",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Tap a design to select",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
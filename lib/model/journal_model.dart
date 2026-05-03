class Journal {
  final String title;
  final String cover;
  final bool isDaily;
  final DateTime updatedAt;


  Journal({required this.title, required this.cover, required this.updatedAt,this.isDaily = false,});
}
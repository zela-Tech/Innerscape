import 'package:cloud_firestore/cloud_firestore.dart';

class Journal {
  final String id;
  final String title;
  final String cover;
  final bool isDaily;
  final DateTime updatedAt;

  Journal({required this.id,required this.title,required this.cover,required this.updatedAt,this.isDaily = false,});

  factory Journal.fromFirestore(String id, Map<String, dynamic> data) {
    return Journal(
      id: id,
      title: data['title'] ?? '',
      cover: data['cover'] ?? '',
      isDaily: data['type'] == 'daily',
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
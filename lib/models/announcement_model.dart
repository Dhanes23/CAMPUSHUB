import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementModel {
  final String id;
  final String title;
  final String content;
  final String priority; // 'high', 'normal', 'low'
  final String category;
  final DateTime createdAt;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.priority,
    required this.category,
    required this.createdAt,
  });

  factory AnnouncementModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AnnouncementModel(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      priority: data['priority'] ?? 'normal',
      category: data['category'] ?? 'general',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'priority': priority,
      'category': category,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

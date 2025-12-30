import 'package:cloud_firestore/cloud_firestore.dart';

class AcademicInfoModel {
  final String id;
  final String title;
  final String description;
  final String type; // 'schedule', 'exam', 'deadline'
  final DateTime? date;
  final DateTime createdAt;

  AcademicInfoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.date,
    required this.createdAt,
  });

  factory AcademicInfoModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AcademicInfoModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      type: data['type'] ?? 'general',
      date: data['date'] != null ? (data['date'] as Timestamp).toDate() : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'type': type,
      'date': date != null ? Timestamp.fromDate(date!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

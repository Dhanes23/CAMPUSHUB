import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String category; // 'academic', 'social', 'competition'
  final String? imageUrl;
  final DateTime createdAt;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.category,
    this.imageUrl,
    required this.createdAt,
  });

  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return EventModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      location: data['location'] ?? '',
      category: data['category'] ?? 'general',
      imageUrl: data['imageUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'location': location,
      'category': category,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

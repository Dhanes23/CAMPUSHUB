import 'package:cloud_firestore/cloud_firestore.dart';

class JobModel {
  final String id;
  final String title;
  final String company;
  final String description;
  final String type; // 'internship', 'fulltime', 'parttime'
  final String? location;
  final String? applyLink;
  final DateTime createdAt;

  JobModel({
    required this.id,
    required this.title,
    required this.company,
    required this.description,
    required this.type,
    this.location,
    this.applyLink,
    required this.createdAt,
  });

  factory JobModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return JobModel(
      id: doc.id,
      title: data['title'] ?? '',
      company: data['company'] ?? '',
      description: data['description'] ?? '',
      type: data['type'] ?? 'internship',
      location: data['location'],
      applyLink: data['applyLink'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'company': company,
      'description': description,
      'type': type,
      'location': location,
      'applyLink': applyLink,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

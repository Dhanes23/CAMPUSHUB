import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role;
  final DateTime createdAt;
  final String? studentId;
  final String? major;
  final int? yearOfStudy;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
    this.studentId,
    this.major,
    this.yearOfStudy,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'user',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      studentId: data['studentId'],
      major: data['major'],
      yearOfStudy: data['yearOfStudy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role,
      'createdAt': Timestamp.fromDate(createdAt),
      'studentId': studentId,
      'major': major,
      'yearOfStudy': yearOfStudy,
    };
  }
}

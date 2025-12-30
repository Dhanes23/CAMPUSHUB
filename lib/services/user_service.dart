import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all users with optional role filter
  Stream<List<UserModel>> getUsers({String? role}) {
    Query query = _firestore.collection('users');

    if (role != null) {
      query = query.where('role', isEqualTo: role);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
    });
  }

  // Get all students (users with role 'user')
  Stream<List<UserModel>> getStudents() {
    return getUsers(role: 'user');
  }

  // Get student count
  Future<int> getStudentCount() async {
    final snapshot = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'user')
        .get();
    return snapshot.docs.length;
  }

  // Get user by ID
  Future<UserModel?> getUserById(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
    } catch (e) {
      // Error handled
    }
    return null;
  }

  // Update user data (admin operation)
  Future<void> updateUser(
    String uid, {
    String? name,
    String? studentId,
    String? major,
    int? yearOfStudy,
    String? role,
  }) async {
    final Map<String, dynamic> updates = {};

    if (name != null) updates['name'] = name;
    if (studentId != null) updates['studentId'] = studentId;
    if (major != null) updates['major'] = major;
    if (yearOfStudy != null) updates['yearOfStudy'] = yearOfStudy;
    if (role != null) updates['role'] = role;

    if (updates.isNotEmpty) {
      await _firestore.collection('users').doc(uid).update(updates);
    }
  }

  // Delete user
  Future<void> deleteUser(String uid) async {
    await _firestore.collection('users').doc(uid).delete();
  }

  // Search students by name or NIM
  Stream<List<UserModel>> searchStudents(String query) {
    if (query.isEmpty) {
      return getStudents();
    }

    return getStudents().map((students) {
      return students.where((student) {
        final nameLower = student.name.toLowerCase();
        final queryLower = query.toLowerCase();
        final nimMatch =
            student.studentId?.toLowerCase().contains(queryLower) ?? false;

        return nameLower.contains(queryLower) || nimMatch;
      }).toList();
    });
  }

  // Get total counts for dashboard statistics
  Future<Map<String, int>> getStatistics() async {
    final usersSnapshot = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'user')
        .get();

    final eventsSnapshot = await _firestore.collection('events').get();
    final announcementsSnapshot = await _firestore
        .collection('announcements')
        .get();
    final jobsSnapshot = await _firestore.collection('jobs').get();

    return {
      'students': usersSnapshot.docs.length,
      'events': eventsSnapshot.docs.length,
      'announcements': announcementsSnapshot.docs.length,
      'jobs': jobsSnapshot.docs.length,
    };
  }
}

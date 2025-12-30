import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/announcement_model.dart';

class AnnouncementService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'announcements';

  // Get all announcements stream
  Stream<List<AnnouncementModel>> getAnnouncements() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true) // Newest first
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => AnnouncementModel.fromFirestore(doc))
              .toList();
        });
  }

  // Create announcement
  Future<void> createAnnouncement(AnnouncementModel announcement) async {
    await _firestore
        .collection(_collection)
        .doc(announcement.id)
        .set(announcement.toMap());
  }

  // Update announcement
  Future<void> updateAnnouncement(AnnouncementModel announcement) async {
    await _firestore
        .collection(_collection)
        .doc(announcement.id)
        .update(announcement.toMap());
  }

  // Delete announcement
  Future<void> deleteAnnouncement(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'events';

  // Get all events stream
  Stream<List<EventModel>> getEvents() {
    return _firestore
        .collection(_collection)
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => EventModel.fromFirestore(doc))
              .toList();
        });
  }

  // Get single event
  Future<EventModel?> getEventById(String id) async {
    final doc = await _firestore.collection(_collection).doc(id).get();
    if (doc.exists) {
      return EventModel.fromFirestore(doc);
    }
    return null;
  }

  // Create event (Admin only)
  Future<void> createEvent(EventModel event) async {
    await _firestore.collection(_collection).doc(event.id).set(event.toMap());
  }

  // Update event (Admin only)
  Future<void> updateEvent(EventModel event) async {
    await _firestore
        .collection(_collection)
        .doc(event.id)
        .update(event.toMap());
  }

  // Delete event (Admin only)
  Future<void> deleteEvent(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
}

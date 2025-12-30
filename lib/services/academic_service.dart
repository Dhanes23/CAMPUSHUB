import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/academic_info_model.dart';

class AcademicService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'academic_info';

  // Get academic info stream
  Stream<List<AcademicInfoModel>> getAcademicInfo() {
    return _firestore
        .collection(_collection)
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => AcademicInfoModel.fromFirestore(doc))
              .toList();
        });
  }

  // Create info
  Future<void> createInfo(AcademicInfoModel info) async {
    await _firestore.collection(_collection).doc(info.id).set(info.toMap());
  }

  // Update info
  Future<void> updateInfo(AcademicInfoModel info) async {
    await _firestore.collection(_collection).doc(info.id).update(info.toMap());
  }

  // Delete info
  Future<void> deleteInfo(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
}

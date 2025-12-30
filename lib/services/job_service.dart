import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/job_model.dart';

class JobService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'jobs';

  // Get jobs stream
  Stream<List<JobModel>> getJobs() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => JobModel.fromFirestore(doc))
              .toList();
        });
  }

  // Create job
  Future<void> createJob(JobModel job) async {
    await _firestore.collection(_collection).doc(job.id).set(job.toMap());
  }

  // Update job
  Future<void> updateJob(JobModel job) async {
    await _firestore.collection(_collection).doc(job.id).update(job.toMap());
  }

  // Delete job
  Future<void> deleteJob(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
}

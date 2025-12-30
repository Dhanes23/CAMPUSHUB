import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/event_service.dart';
import '../services/announcement_service.dart';
import '../services/academic_service.dart';
import '../services/job_service.dart';
import '../models/event_model.dart';
import '../models/announcement_model.dart';
import '../models/academic_info_model.dart';
import '../models/job_model.dart';

// Services Providers
final eventServiceProvider = Provider((ref) => EventService());
final announcementServiceProvider = Provider((ref) => AnnouncementService());
final academicServiceProvider = Provider((ref) => AcademicService());
final jobServiceProvider = Provider((ref) => JobService());

// Streams Providers
final eventsProvider = StreamProvider<List<EventModel>>((ref) {
  return ref.watch(eventServiceProvider).getEvents();
});

final announcementsProvider = StreamProvider<List<AnnouncementModel>>((ref) {
  return ref.watch(announcementServiceProvider).getAnnouncements();
});

final academicInfoProvider = StreamProvider<List<AcademicInfoModel>>((ref) {
  return ref.watch(academicServiceProvider).getAcademicInfo();
});

final jobsProvider = StreamProvider<List<JobModel>>((ref) {
  return ref.watch(jobServiceProvider).getJobs();
});

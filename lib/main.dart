import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'models/event_model.dart';
import 'features/auth/login_page.dart';
import 'features/auth/register_page.dart';
import 'features/dashboard/dashboard_page.dart';
import 'features/events/events_list_page.dart';
import 'features/events/event_detail_page.dart';
import 'features/announcements/announcements_page.dart';
import 'features/academic/academic_info_page.dart';
import 'features/jobs/jobs_list_page.dart';
import 'features/profile/profile_page.dart';
import 'features/admin/admin_dashboard.dart';
import 'features/admin/manage_events.dart';
import 'features/admin/manage_announcements.dart';
import 'features/admin/manage_academic.dart';
import 'features/admin/manage_jobs.dart';
import 'features/admin/forms/event_form.dart';
import 'features/admin/forms/announcement_form.dart';
import 'features/admin/forms/academic_form.dart';
import 'features/admin/forms/job_form.dart';
import 'models/announcement_model.dart';
import 'models/academic_info_model.dart';
import 'models/job_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: CampusHubApp()));
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final userRoleState = ref.watch(currentUserRoleProvider);

  return GoRouter(
    initialLocation: '/login', // Start at login
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isLoggingIn =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      if (isLoggedIn && isLoggingIn) {
        // Wait for role to load
        if (userRoleState.isLoading) {
          return null;
        }

        final role = userRoleState.value;
        if (role == 'admin') {
          return '/admin';
        } else {
          return '/dashboard';
        }
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/events',
        builder: (context, state) => const EventsListPage(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return EventDetailPage(id: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/announcements',
        builder: (context, state) => const AnnouncementsPage(),
      ),
      GoRoute(
        path: '/academic',
        builder: (context, state) => const AcademicInfoPage(),
      ),
      GoRoute(path: '/jobs', builder: (context, state) => const JobsListPage()),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      // Admin Routes
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboard(),
        routes: [
          GoRoute(
            path: 'events',
            builder: (context, state) => const ManageEvents(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) => const EventFormPage(),
              ),
              GoRoute(
                path: 'edit/:id',
                builder: (context, state) {
                  final event = state.extra as EventModel?;
                  return EventFormPage(event: event);
                },
              ),
            ],
          ),
          GoRoute(
            path: 'announcements',
            builder: (context, state) => const ManageAnnouncements(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) => const AnnouncementFormPage(),
              ),
              GoRoute(
                path: 'edit/:id',
                builder: (context, state) {
                  final announcement = state.extra as AnnouncementModel?;
                  return AnnouncementFormPage(announcement: announcement);
                },
              ),
            ],
          ),
          GoRoute(
            path: 'academic',
            builder: (context, state) => const ManageAcademic(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) => const AcademicFormPage(),
              ),
              GoRoute(
                path: 'edit/:id',
                builder: (context, state) {
                  final info = state.extra as AcademicInfoModel?;
                  return AcademicFormPage(info: info);
                },
              ),
            ],
          ),
          GoRoute(
            path: 'jobs',
            builder: (context, state) => const ManageJobs(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) => const JobFormPage(),
              ),
              GoRoute(
                path: 'edit/:id',
                builder: (context, state) {
                  final job = state.extra as JobModel?;
                  return JobFormPage(job: job);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final dynamic _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class CampusHubApp extends ConsumerWidget {
  const CampusHubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'CampusHub',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

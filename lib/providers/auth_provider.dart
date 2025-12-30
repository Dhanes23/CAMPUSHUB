import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

final userRoleProvider = FutureProvider.family<String?, String>((
  ref,
  uid,
) async {
  return ref.watch(authServiceProvider).getUserRole(uid);
});

// Current user role provider (dependent on auth state)
final currentUserRoleProvider = FutureProvider<String?>((ref) async {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) async {
      if (user == null) return null;
      return ref.watch(authServiceProvider).getUserRole(user.uid);
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

// Current user profile provider
final currentUserProfileProvider = FutureProvider<UserModel?>((ref) async {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) async {
      if (user == null) return null;
      return ref.watch(authServiceProvider).getUserProfile(user.uid);
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/feature_providers.dart';
import 'widgets/announcement_card.dart';

class AnnouncementsPage extends ConsumerWidget {
  const AnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementsAsync = ref.watch(announcementsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pengumuman')),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(announcementsProvider),
        child: announcementsAsync.when(
          data: (announcements) {
            if (announcements.isEmpty) {
              return const Center(child: Text('Belum ada pengumuman'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: announcements.length,
              itemBuilder: (context, index) {
                return AnnouncementCard(announcement: announcements[index]);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }
}

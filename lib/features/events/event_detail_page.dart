import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../providers/feature_providers.dart';

class EventDetailPage extends ConsumerWidget {
  final String id;
  const EventDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Event')),
      body: eventsAsync.when(
        data: (events) {
          final event = events.firstWhere(
            (e) => e.id == id,
            orElse: () => throw Exception('Event not found'),
          );

          final dateFormat = DateFormat('EEEE, d MMMM yyyy', 'id_ID');

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (event.imageUrl != null && event.imageUrl!.isNotEmpty)
                  Image.network(
                    event.imageUrl!,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox(height: 100),
                  ),

                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          event.category.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Title
                      Text(
                        event.title,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),

                      // Info Row (Date & Location)
                      _buildInfoRow(
                        context,
                        Icons.calendar_today,
                        dateFormat.format(event.date),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(context, Icons.location_on, event.location),

                      const Divider(height: 48),

                      // Description Title
                      Text(
                        'Deskripsi',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),

                      // Description Content
                      Text(
                        event.description,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            const Center(child: Text('Gagal memuat detail event')),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }
}

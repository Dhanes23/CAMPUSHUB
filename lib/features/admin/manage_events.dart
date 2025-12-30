import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../providers/feature_providers.dart';
import '../../../models/event_model.dart';

class ManageEvents extends ConsumerWidget {
  const ManageEvents({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);
    final dateFormat = DateFormat('d MMM yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Events')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/admin/events/create'),
        child: const Icon(Icons.add),
      ),
      body: eventsAsync.when(
        data: (events) {
          if (events.isEmpty) {
            return const Center(child: Text('No events found'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final event = events[index];
              return ListTile(
                title: Text(
                  event.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${dateFormat.format(event.date)} - ${event.category}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => context.push(
                        '/admin/events/edit/${event.id}',
                        extra: event,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteEvent(context, ref, event),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Future<void> _deleteEvent(
    BuildContext context,
    WidgetRef ref,
    EventModel event,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete "${event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(eventServiceProvider).deleteEvent(event.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event deleted successfully')),
        );
      }
    }
  }
}

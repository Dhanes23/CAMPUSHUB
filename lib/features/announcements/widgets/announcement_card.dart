import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../models/announcement_model.dart';
import '../../../../core/constants/app_colors.dart';

class AnnouncementCard extends StatelessWidget {
  final AnnouncementModel announcement;

  const AnnouncementCard({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM yyyy, HH:mm', 'id_ID');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Priority Indicator Strip
            Container(
              width: 6,
              color: _getPriorityColor(announcement.priority),
            ),

            // Content
            Expanded(
              child: ExpansionTile(
                shape: const Border(), // Remove default borders
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildCategoryBadge(announcement.category),
                        const Spacer(),
                        if (announcement.priority == 'high')
                          const Icon(
                            Icons.priority_high,
                            size: 16,
                            color: Colors.red,
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      announcement.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateFormat.format(announcement.createdAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        announcement.content,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(height: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium': // 'normal' in model, but handling alias
      case 'normal':
        return Colors.blue;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildCategoryBadge(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(
        category.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    );
  }
}

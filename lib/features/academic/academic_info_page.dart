import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../providers/feature_providers.dart';
import '../../../../models/academic_info_model.dart';
import '../../../../core/constants/app_colors.dart';

class AcademicInfoPage extends ConsumerWidget {
  const AcademicInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final academicInfoAsync = ref.watch(academicInfoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Informasi Akademik')),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(academicInfoProvider),
        child: academicInfoAsync.when(
          data: (infoList) {
            if (infoList.isEmpty) {
              return const Center(child: Text('Belum ada informasi akademik'));
            }

            // Group by type
            final schedules = infoList
                .where((i) => i.type == 'schedule')
                .toList();
            final exams = infoList.where((i) => i.type == 'exam').toList();
            final deadlines = infoList
                .where((i) => i.type == 'deadline')
                .toList();
            final general = infoList
                .where(
                  (i) => !['schedule', 'exam', 'deadline'].contains(i.type),
                )
                .toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (schedules.isNotEmpty) ...[
                    _buildSectionHeader(
                      context,
                      'Jadwal Kuliah',
                      Icons.schedule,
                    ),
                    ...schedules.map((i) => _buildInfoCard(context, i)),
                    const SizedBox(height: 24),
                  ],
                  if (exams.isNotEmpty) ...[
                    _buildSectionHeader(
                      context,
                      'Ujian & Kuis',
                      Icons.assignment_outlined,
                    ),
                    ...exams.map((i) => _buildInfoCard(context, i)),
                    const SizedBox(height: 24),
                  ],
                  if (deadlines.isNotEmpty) ...[
                    _buildSectionHeader(
                      context,
                      'Deadlines',
                      Icons.timer_outlined,
                      color: Colors.red,
                    ),
                    ...deadlines.map((i) => _buildInfoCard(context, i)),
                    const SizedBox(height: 24),
                  ],
                  if (general.isNotEmpty) ...[
                    _buildSectionHeader(
                      context,
                      'Informasi Lain',
                      Icons.info_outline,
                    ),
                    ...general.map((i) => _buildInfoCard(context, i)),
                  ],
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon, {
    Color color = AppColors.primary,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, AcademicInfoModel info) {
    final dateFormat = DateFormat('EEE, d MMM yyyy, HH:mm', 'id_ID');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(
          info.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(info.description),
            if (info.date != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    dateFormat.format(info.date!),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

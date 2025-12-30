import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../providers/feature_providers.dart';
import '../../../../models/job_model.dart';
import '../../../../core/constants/app_colors.dart';

class JobsListPage extends ConsumerWidget {
  const JobsListPage({super.key});

  // Helper to open link
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(jobsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Karir & Magang')),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(jobsProvider),
        child: jobsAsync.when(
          data: (jobs) {
            if (jobs.isEmpty) {
              return const Center(child: Text('Belum ada lowongan tersedia'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                return _buildJobCard(context, jobs[index]);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, JobModel job) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.business,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        job.company,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildJobTypeChip(job.type),
              ],
            ),
            const SizedBox(height: 16),
            if (job.location != null) ...[
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    job.location!,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            Text(
              job.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(height: 1.4),
            ),
            if (job.applyLink != null && job.applyLink!.isNotEmpty) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _launchUrl(job.applyLink!),
                  child: const Text('Lihat Detail & Daftar'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildJobTypeChip(String type) {
    Color color;
    switch (type.toLowerCase()) {
      case 'internship':
        color = Colors.blue;
        break;
      case 'fulltime':
        color = Colors.green;
        break;
      case 'parttime':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        type.toUpperCase(), // Display simplified type
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

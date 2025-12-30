import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../providers/feature_providers.dart';
import '../../models/academic_info_model.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_layout.dart';

class ManageAcademic extends ConsumerWidget {
  const ManageAcademic({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final academicAsync = ref.watch(academicInfoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Akademik')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/admin/academic/create'),
        child: const Icon(Icons.add),
      ),
      body: academicAsync.when(
        data: (infoList) {
          if (infoList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.school_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada informasi akademik',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final padding = ResponsiveLayout.getResponsivePadding(context);
              final columns = ResponsiveLayout.getColumnCount(
                context,
                mobile: 1,
                tablet: 2,
                desktop: 2,
              );
              final isMobile = ResponsiveLayout.isMobile(context);

              return ResponsiveLayout.constrainWidth(
                child: isMobile
                    ? ListView.builder(
                        padding: EdgeInsets.all(padding),
                        itemCount: infoList.length,
                        itemBuilder: (context, index) {
                          final info = infoList[index];
                          return _AcademicInfoCard(info: info);
                        },
                      )
                    : GridView.builder(
                        padding: EdgeInsets.all(padding),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 2.5,
                        ),
                        itemCount: infoList.length,
                        itemBuilder: (context, index) {
                          final info = infoList[index];
                          return _AcademicInfoCard(info: info);
                        },
                      ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _AcademicInfoCard extends ConsumerWidget {
  final AcademicInfoModel info;

  const _AcademicInfoCard({required this.info});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _TypeBadge(type: info.type),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    info.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              info.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (info.date != null) ...[
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('EEEE, dd MMM yyyy').format(info.date!),
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    context.push(
                      '/admin/academic/edit/${info.id}',
                      extra: info,
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Hapus Informasi'),
                        content: const Text(
                          'Apakah Anda yakin ingin menghapus informasi akademik ini?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text('Hapus'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await ref
                          .read(academicServiceProvider)
                          .deleteInfo(info.id);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Informasi berhasil dihapus'),
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final String type;

  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;

    switch (type.toLowerCase()) {
      case 'exam':
        color = Colors.red;
        icon = Icons.assignment_late;
        break;
      case 'schedule':
        color = Colors.blue;
        icon = Icons.schedule;
        break;
      case 'deadline':
        color = Colors.orange;
        icon = Icons.timer;
        break;
      default:
        color = AppColors.primary;
        icon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

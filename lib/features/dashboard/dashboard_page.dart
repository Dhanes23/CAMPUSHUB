import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../core/constants/app_colors.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(currentUserProfileProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              userProfileAsync.when(
                data: (user) => _buildHeader(context, user?.name ?? 'Student'),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Text('Error loading profile'),
              ),
              const SizedBox(height: 32),

              // Quick Access Grid
              Text(
                'Menu Utama',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _QuickAccessCard(
                    title: 'Events',
                    icon: Icons.event,
                    color: Colors.blue,
                    onTap: () => context.push('/events'),
                  ),
                  _QuickAccessCard(
                    title: 'Pengumuman',
                    icon: Icons.campaign,
                    color: Colors.orange,
                    onTap: () => context.push('/announcements'),
                  ),
                  _QuickAccessCard(
                    title: 'Akademik',
                    icon: Icons.school,
                    color: Colors.green,
                    onTap: () => context.push('/academic'),
                  ),
                  _QuickAccessCard(
                    title: 'Karir',
                    icon: Icons.work,
                    color: Colors.purple,
                    onTap: () => context.push('/jobs'),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Recent Updates (Placeholder for now)
              Text(
                'Terbaru',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Belum ada update terbaru'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String name) {
    return InkWell(
      onTap: () => context.push('/profile'),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.primary,
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'U',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat Datang,',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

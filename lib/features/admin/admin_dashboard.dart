import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../services/user_service.dart';
import '../../core/utils/responsive_layout.dart';

// Provider for UserService
final userServiceProvider = Provider((ref) => UserService());

// Provider for statistics
final statisticsProvider = FutureProvider<Map<String, int>>((ref) async {
  final userService = ref.watch(userServiceProvider);
  return await userService.getStatistics();
});

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statisticsAsync = ref.watch(statisticsProvider);
    final userProfileAsync = ref.watch(currentUserProfileProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern Gradient App Bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Admin Dashboard',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 56),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: userProfileAsync.when(
                        data: (user) => Text(
                          'Welcome back, ${user?.name ?? 'Admin'}!',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.95),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout_outlined),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: const Text('Konfirmasi Logout'),
                      content: const Text('Apakah Anda yakin ingin keluar?'),
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
                          child: const Text('Keluar'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    ref.read(authServiceProvider).signOut();
                  }
                },
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final padding = ResponsiveLayout.getResponsivePadding(context);
                final statsColumns = ResponsiveLayout.getColumnCount(
                  context,
                  mobile: 2,
                  tablet: 3,
                  desktop: 4,
                );
                final menuColumns = ResponsiveLayout.getColumnCount(
                  context,
                  mobile: 2,
                  tablet: 3,
                  desktop: 3,
                );
                final statAspectRatio = ResponsiveLayout.getCardAspectRatio(
                  context,
                  mobile: 1.5,
                  tablet: 1.6,
                  desktop: 1.4,
                );

                return ResponsiveLayout.constrainWidth(
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Statistics Section
                        Text(
                          'Statistik',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                        ),
                        const SizedBox(height: 16),
                        statisticsAsync.when(
                          data: (stats) => GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: statsColumns,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: statAspectRatio,
                            children: [
                              _StatCard(
                                title: 'Mahasiswa',
                                count: stats['students'] ?? 0,
                                icon: Icons.people_outline,
                                gradient: AppColors.primaryGradient,
                              ),
                              _StatCard(
                                title: 'Events',
                                count: stats['events'] ?? 0,
                                icon: Icons.event_outlined,
                                gradient: AppColors.accentGradient,
                              ),
                              _StatCard(
                                title: 'Pengumuman',
                                count: stats['announcements'] ?? 0,
                                icon: Icons.campaign_outlined,
                                gradient: AppColors.successGradient,
                              ),
                              _StatCard(
                                title: 'Lowongan',
                                count: stats['jobs'] ?? 0,
                                icon: Icons.work_outline,
                                gradient: AppColors.purpleGradient,
                              ),
                            ],
                          ),
                          loading: () => const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          error: (err, stack) => Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text('Error loading statistics: $err'),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Management Section
                        Text(
                          'Kelola Konten',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                        ),
                        const SizedBox(height: 16),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: menuColumns,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.0,
                          children: [
                            _AdminMenuCard(
                              title: 'Mahasiswa',
                              icon: Icons.people,
                              gradient: AppColors.primaryGradient,
                              onTap: () => context.push('/admin/students'),
                            ),
                            _AdminMenuCard(
                              title: 'Events',
                              icon: Icons.event,
                              gradient: AppColors.accentGradient,
                              onTap: () => context.push('/admin/events'),
                            ),
                            _AdminMenuCard(
                              title: 'Pengumuman',
                              icon: Icons.campaign,
                              gradient: AppColors.successGradient,
                              onTap: () => context.push('/admin/announcements'),
                            ),
                            _AdminMenuCard(
                              title: 'Akademik',
                              icon: Icons.school,
                              gradient: AppColors.purpleGradient,
                              onTap: () => context.push('/admin/academic'),
                            ),
                            _AdminMenuCard(
                              title: 'Lowongan',
                              icon: Icons.work,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.indigo.shade400,
                                  Colors.indigo.shade600,
                                ],
                              ),
                              onTap: () => context.push('/admin/jobs'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final LinearGradient gradient;

  const _StatCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const Spacer(),
          Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _AdminMenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _AdminMenuCard({
    required this.title,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowMedium,
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative circle
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(icon, size: 32, color: Colors.grey[800]),
                    ),
                    const Spacer(),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              ref.read(authServiceProvider).signOut();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Management',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _AdminMenuCard(
                  title: 'Events',
                  icon: Icons.event,
                  color: Colors.blue,
                  onTap: () => context.push('/admin/events'),
                ),
                _AdminMenuCard(
                  title: 'Announcements',
                  icon: Icons.campaign,
                  color: Colors.orange,
                  onTap: () => context.push('/admin/announcements'),
                ),
                _AdminMenuCard(
                  title: 'Academic',
                  icon: Icons.school,
                  color: Colors.green,
                  onTap: () => context.push('/admin/academic'),
                ),
                _AdminMenuCard(
                  title: 'Jobs',
                  icon: Icons.work,
                  color: Colors.purple,
                  onTap: () => context.push('/admin/jobs'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminMenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _AdminMenuCard({
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 40),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

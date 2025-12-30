import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../core/constants/app_colors.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(currentUserProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya'), centerTitle: true),
      body: userProfileAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('User details not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Profile Picture
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Name & Role
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: user.role == 'admin'
                        ? Colors.red[50]
                        : Colors.blue[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: user.role == 'admin' ? Colors.red : Colors.blue,
                    ),
                  ),
                  child: Text(
                    user.role == 'admin' ? 'Administrator' : 'Mahasiswa',
                    style: TextStyle(
                      color: user.role == 'admin' ? Colors.red : Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Details Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _ProfileDetailItem(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: user.email,
                        ),
                        const Divider(),
                        _ProfileDetailItem(
                          icon: Icons.badge_outlined,
                          label: 'NIM',
                          value: user.studentId ?? '-',
                        ),
                        const Divider(),
                        _ProfileDetailItem(
                          icon: Icons.school_outlined,
                          label: 'Program Studi',
                          value: user.major ?? '-',
                        ),
                        const Divider(),
                        _ProfileDetailItem(
                          icon: Icons.calendar_today_outlined,
                          label: 'Angkatan',
                          value: user.yearOfStudy?.toString() ?? '-',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Konfirmasi Logout'),
                          content: const Text(
                            'Apakah Anda yakin ingin keluar?',
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
                              child: const Text('Keluar'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        ref.read(authServiceProvider).signOut();
                      }
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Keluar Aplikasi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _ProfileDetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileDetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
